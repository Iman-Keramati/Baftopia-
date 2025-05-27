import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/data/category_data.dart';
import 'package:fuck/models/category.dart';
import 'package:fuck/provider/category_Provider.dart';
import 'package:fuck/widgets/image_input.dart';
import 'package:uuid/uuid.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  File? _image;

  void _onPickImage(File image) {
    setState(() {
      _image = image;
    });
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        id: const Uuid().v4(),
        title: _titleController.text,
        image: _image!.path,
      );

      await CategoryService().addCategory(category);
      ref.invalidate(categoryProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'دسته بندی با موفقیت افزوده شد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'عنوان دسته بندی'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'لطفاً عنوان دسته بندی را وارد کنید';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ImageInput(
              onPickImage: _onPickImage,
              imageSelectionType: 'gallery',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: _onSubmit,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onSecondary,
                    ),
                    foregroundColor: MaterialStateProperty.all((Colors.white)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  child: Text('افزودن دسته بندی'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
