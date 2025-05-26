import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/data/category_data.dart';
import 'package:fuck/models/product.dart';
import 'package:fuck/provider/product_provider.dart';
import 'package:fuck/widgets/image_input.dart';
import 'package:fuck/widgets/persian_date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key, required this.defaultCategory});

  final CategoryData defaultCategory;

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  Dificulty _dificultyController = Dificulty.beginner;
  late CategoryData _categoryController;
  DateTime _startDateController = DateTime.now();
  DateTime _endDateController = DateTime.now();
  File _imageController = File('');

  @override
  void initState() {
    super.initState();
    _categoryController = widget.defaultCategory;
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Process the data
      final product = Product(
        title: _nameController.text,
        image: _imageController,
        startDate: _startDateController,
        endDate: _endDateController,
        dificulty: _dificultyController,
        category: _categoryController,
      );
      ref.read(productProvider.notifier).addProduct(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'بافتنی با موفقیت افزوده شد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green[700], // your custom background color
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop(); // Close the form after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // 🔥 right-to-left everywhere
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                autofocus: false,
                maxLength: 50,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفا نام محصول را وارد کنید';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'نام'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<Dificulty>(
                value: _dificultyController,
                items:
                    Dificulty.values
                        .map(
                          (dificulty) => DropdownMenuItem<Dificulty>(
                            value: dificulty,
                            child: Text(dificulty.title),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _dificultyController = value;
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _categoryController.persianTitle,
                items:
                    CategoryData.values
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category.persianTitle,
                            child: Text(category.persianTitle),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _categoryController = CategoryData.values.firstWhere(
                        (category) => category.persianTitle == value,
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              JalaliDatePickerField(
                labelText: 'تاریخ شروع',
                onChanged: (jalaliDate) {
                  setState(() {
                    final parts = jalaliDate.split('/');
                    final jalali = Jalali(
                      int.parse(parts[0]),
                      int.parse(parts[1]),
                      int.parse(parts[2]),
                    );

                    final gregorian = jalali.toGregorian();
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
                  setState(() {
                    final parts = jalaliDate.split('/');
                    final jalali = Jalali(
                      int.parse(parts[0]),
                      int.parse(parts[1]),
                      int.parse(parts[2]),
                    );
                    final gregorian = jalali.toGregorian();
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
                onPickImage: (file) {
                  setState(() {
                    _imageController = file;
                  });
                },
              ),
              const SizedBox(height: 10),
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
                        (Colors.white),
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
  }
}
