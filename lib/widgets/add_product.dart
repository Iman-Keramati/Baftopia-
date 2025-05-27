import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/data/product_data.dart';
import 'package:fuck/models/category.dart';
import 'package:fuck/models/product.dart';
import 'package:fuck/provider/category_provider.dart';
import 'package:fuck/provider/product_provider.dart';
import 'package:fuck/widgets/image_input.dart';
import 'package:fuck/widgets/persian_date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:uuid/uuid.dart';

enum Difficulty { beginner, intermediate, advanced }

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  Difficulty _difficultyController = Difficulty.beginner;
  Category? _categoryController;
  DateTime _startDateController = DateTime.now();
  DateTime _endDateController = DateTime.now();
  File? _imageController; // nullable to check if selected

  @override
  void initState() {
    super.initState();
    _categoryController = null;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_imageController == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لطفا تصویر محصول را انتخاب کنید')),
        );
        return;
      }

      final product = ProductModel(
        id: const Uuid().v4(),
        title: _nameController.text.trim(),
        image: _imageController!.path,
        startDate: _startDateController,
        endDate: _endDateController,
        difficultyLevel: _difficultyController.name,
        description: '', // You can add a description field if needed
        category: _categoryController!,
      );

      try {
        await ProductService().addProduct(product);
        ref.invalidate(productProvider);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'بافتنی با موفقیت افزوده شد',
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

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا در افزودن محصول: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (_categoryController == null && categories.isNotEmpty) {
          // Set default category if none selected yet
          _categoryController = categories.first;
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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
                                child: Text(d.name),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null)
                        setState(() => _difficultyController = val);
                    },
                    decoration: const InputDecoration(labelText: 'سطح دشواری'),
                  ),
                  const SizedBox(height: 10),

                  // *** Your dynamic categories dropdown ***
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
                      if (val != null)
                        setState(() => _categoryController = val);
                    },
                    decoration: const InputDecoration(labelText: 'دسته بندی'),
                    validator:
                        (value) =>
                            value == null
                                ? 'لطفا دسته بندی را انتخاب کنید'
                                : null,
                  ),

                  const SizedBox(height: 10),
                  JalaliDatePickerField(
                    labelText: 'تاریخ شروع',
                    onChanged: (jalaliDate) {
                      final parts = jalaliDate.split('/');
                      final jalali = Jalali(
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                        int.parse(parts[2]),
                      );
                      final gregorian = jalali.toGregorian();
                      setState(() {
                        _startDateController = DateTime(
                          gregorian.year,
                          gregorian.month,
                          gregorian.day,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  JalaliDatePickerField(
                    labelText: 'تاریخ پایان',
                    onChanged: (jalaliDate) {
                      final parts = jalaliDate.split('/');
                      final jalali = Jalali(
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                        int.parse(parts[2]),
                      );
                      final gregorian = jalali.toGregorian();
                      setState(() {
                        _endDateController = DateTime(
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
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: _onSubmit,
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
                        child: const Text(
                          'افزودن',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
