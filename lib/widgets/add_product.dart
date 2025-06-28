import 'dart:io';

import 'package:baftopia/core/constants.dart';
import 'package:baftopia/data/product_data.dart';
import 'package:baftopia/models/category.dart';
import 'package:baftopia/models/product.dart';
import 'package:baftopia/provider/category_provider.dart';
import 'package:baftopia/provider/product_provider.dart';
import 'package:baftopia/widgets/image_input.dart';
import 'package:baftopia/widgets/persian_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

enum Difficulty { beginner, intermediate, advanced }

extension DifficultyExtension on Difficulty {
  String get persianLabel {
    switch (this) {
      case Difficulty.beginner:
        return 'مبتدی';
      case Difficulty.intermediate:
        return 'متوسط';
      case Difficulty.advanced:
        return 'پیشرفته';
    }
  }

  IconData get icon {
    switch (this) {
      case Difficulty.beginner:
        return Icons.self_improvement;
      case Difficulty.intermediate:
        return Icons.directions_walk;
      case Difficulty.advanced:
        return Icons.whatshot;
    }
  }
}

class AddProduct extends ConsumerStatefulWidget {
  final ProductModel? product;
  const AddProduct({super.key, this.product});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeSpentController = TextEditingController();
  Difficulty _difficultyController = Difficulty.beginner;
  Category? _categoryController;
  DateTime _dateController = DateTime.now();
  File? _imageController;
  String? _existingImageUrl;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _nameController.text = widget.product!.title;
      _timeSpentController.text = widget.product!.timeSpent;
      _difficultyController = Difficulty.values.firstWhere(
        (d) => d.name == widget.product!.difficultyLevel,
        orElse: () => Difficulty.beginner,
      );
      _dateController = widget.product!.date;
      _existingImageUrl = widget.product!.image;
      _descriptionController.text = widget.product!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeSpentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImageToSupabase(File imageFile) async {
    try {
      final fileBytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$fileExt';
      final supabase = Supabase.instance.client;

      await supabase.storage
          .from('product-images')
          .uploadBinary(fileName, fileBytes);

      return supabase.storage.from('product-images').getPublicUrl(fileName);
    } catch (e) {
      debugPrint('Supabase upload error: $e');
      return null;
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageController == null && widget.product == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppTexts.selectImage)));
      return;
    }

    if (_categoryController == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppTexts.selectCategory)));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String imageUrl;
      if (_imageController != null) {
        final uploadedUrl = await _uploadImageToSupabase(_imageController!);
        if (uploadedUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(AppTexts.uploadError)));
          return;
        }
        imageUrl = uploadedUrl;
      } else {
        imageUrl = widget.product!.image;
      }

      final product = ProductModel(
        id: widget.product?.id ?? const Uuid().v4(),
        title: _nameController.text.trim(),
        image: imageUrl,
        date: _dateController,
        timeSpent: _timeSpentController.text.trim(),
        difficultyLevel: _difficultyController.name,
        description: _descriptionController.text.trim(),
        category: _categoryController!,
      );

      if (widget.product != null) {
        await ProductService().updateProduct(product);
      } else {
        await ProductService().addProduct(product);
      }

      ref.invalidate(productProvider);
      ref.invalidate(categoryProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product != null
                ? AppTexts.productEdited
                : AppTexts.productAdded,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop(widget.product != null ? product : true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطا در ${widget.product != null ? 'ویرایش' : 'افزودن'} محصول: $e',
          ),
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (_categoryController == null && categories.isNotEmpty) {
          if (widget.product != null) {
            _categoryController = categories.firstWhere(
              (cat) => cat.id == widget.product!.category.id,
              orElse: () => categories.first,
            );
          } else {
            _categoryController = categories.first;
          }
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppConstants.paddingMedium,
                right: AppConstants.paddingMedium,
                top: AppConstants.paddingMedium,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    AppConstants.paddingMedium,
              ),
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 50,
                    controller: _nameController,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? AppTexts.enterName
                                : null,
                    decoration: const InputDecoration(
                      labelText: AppTexts.productName,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  DropdownButtonFormField<Difficulty>(
                    value: _difficultyController,
                    items:
                        Difficulty.values
                            .map(
                              (d) => DropdownMenuItem(
                                value: d,
                                child: Text(d.persianLabel),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _difficultyController = val);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: AppTexts.productDifficulty,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  DropdownButtonFormField<Category>(
                    value: _categoryController,
                    items:
                        categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.title),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _categoryController = val);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: AppTexts.productCategory,
                    ),
                    validator:
                        (value) =>
                            value == null ? AppTexts.selectCategory : null,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  TextFormField(
                    maxLength: 50,
                    controller: _timeSpentController,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? AppTexts.enterTimeSpent
                                : null,
                    decoration: const InputDecoration(
                      labelText: AppTexts.productTimeSpent,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  JalaliDatePickerField(
                    labelText: AppTexts.productDate,
                    initialDate: _dateController,
                    onChanged: (jalaliDate) {
                      final parts = jalaliDate.split('/');
                      final jalali = Jalali(
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                        int.parse(parts[2]),
                      );
                      final gregorian = jalali.toGregorian();
                      setState(() {
                        _dateController = DateTime(
                          gregorian.year,
                          gregorian.month,
                          gregorian.day,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  ImageInput(
                    onPickImage:
                        (file) => setState(() => _imageController = file),
                    existingImageUrl: _existingImageUrl,
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.productDescription,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _onSubmit,
                        child:
                            _isSubmitting
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text(
                                  widget.product != null
                                      ? AppTexts.edit
                                      : AppTexts.add,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => Center(child: Text('خطا در بارگذاری دسته بندی‌ها')),
    );
  }
}
