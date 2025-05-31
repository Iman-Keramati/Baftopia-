import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/data/category_data.dart';
import 'package:fuck/models/category.dart';
import 'package:fuck/provider/category_Provider.dart';
import 'package:fuck/widgets/image_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    if (_formKey.currentState!.validate() && _image != null) {
      final supabase = Supabase.instance.client;
      final categoryId = const Uuid().v4();
      final fileExt = _image!.path.split('.').last;
      final filePath = 'categories/$categoryId.$fileExt';
      final fileBytes = await _image!.readAsBytes();

      String? publicUrl;

      try {
        final uploadPath = await supabase.storage
            .from('category-images')
            .uploadBinary(
              filePath,
              fileBytes,
              fileOptions: FileOptions(
                contentType: 'image/$fileExt',
                upsert: true,
              ),
            );

        if (uploadPath.isEmpty) throw Exception("Upload failed");
        publicUrl = supabase.storage
            .from('category-images')
            .getPublicUrl(filePath);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا در آپلود تصویر: $e')));
        return;
      }

      final category = Category(
        id: categoryId,
        title: _titleController.text,
        image: publicUrl,
      );

      await CategoryService().addCategory(category);
      ref.invalidate(categoryProvider);

      if (!mounted) return;

      // First pop the modal
      Navigator.of(context).pop();

      // Then show the SnackBar on the underlying scaffold's context
      // Use a delay or Future.microtask to ensure modal is closed before showing SnackBar
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'دسته بندی با موفقیت افزوده شد',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
      });
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
