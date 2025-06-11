import 'dart:io';

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
  File? _imageController; // nullable to check if selected
  String? _existingImageUrl; // Add this for existing image URL
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If in edit mode, populate the fields
    if (widget.product != null) {
      _nameController.text = widget.product!.title;
      _timeSpentController.text = widget.product!.timeSpent;
      _difficultyController = Difficulty.values.firstWhere(
        (d) => d.name == widget.product!.difficultyLevel,
        orElse: () => Difficulty.beginner,
      );
      _categoryController = null;
      _dateController = widget.product!.date;
      _existingImageUrl = widget.product!.image; // Store existing image URL
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

  Future<String?> uploadImageToSupabase(File imageFile) async {
    try {
      final fileBytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$fileExt'; // Unique file name
      final supabase = Supabase.instance.client;

      // Upload returns String path or throws on error
      await supabase.storage
          .from('product-images')
          .uploadBinary(fileName, fileBytes);

      // Get public URL of the uploaded file
      final publicUrl = supabase.storage
          .from('product-images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      debugPrint('Supabase upload error: $e');
      return null;
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageController == null && widget.product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفا تصویر محصول را انتخاب کنید')),
      );
      return;
    }

    if (_categoryController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفا یک دسته‌بندی انتخاب کنید')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String imageUrl;
      if (_imageController != null) {
        final uploadedUrl = await uploadImageToSupabase(_imageController!);
        if (uploadedUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('خطا در بارگذاری تصویر')),
          );
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

      // Invalidate both product and category providers to ensure UI updates
      ref.invalidate(productProvider);
      ref.invalidate(categoryProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product != null
                ? 'بافتنی با موفقیت ویرایش شد'
                : 'بافتنی با موفقیت افزوده شد',
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
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Pop with the updated product to update the detail view
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
        // Initialize category in build where categories are available
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
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 50,
                    controller: _nameController,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'لطفا نام محصول را وارد کنید'
                                : null,
                    decoration: const InputDecoration(labelText: 'نام'),
                  ),
                  const SizedBox(height: 10),
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
                    decoration: const InputDecoration(labelText: 'سطح دشواری'),
                  ),
                  const SizedBox(height: 10),

                  // Category dropdown
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
                    decoration: const InputDecoration(labelText: 'دسته بندی'),
                    validator:
                        (value) =>
                            value == null
                                ? 'لطفا دسته بندی را انتخاب کنید'
                                : null,
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    maxLength: 50,
                    controller: _timeSpentController,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'لطفا زمان صرف شده را وارد کنید'
                                : null,
                    decoration: const InputDecoration(
                      labelText: 'زمان صرف شده',
                    ),
                  ),
                  const SizedBox(height: 10),
                  JalaliDatePickerField(
                    labelText: 'تاریخ پایان',
                    initialDate: _dateController, // Add initial date
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
                  const SizedBox(height: 10),
                  ImageInput(
                    onPickImage:
                        (file) => setState(() => _imageController = file),
                    existingImageUrl:
                        _existingImageUrl, // Pass existing image URL
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'توضیحات'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _onSubmit,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.onSecondary,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
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
                                  widget.product != null ? 'ویرایش' : 'افزودن',
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
