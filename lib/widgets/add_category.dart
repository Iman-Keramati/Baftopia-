import 'dart:io';

import 'package:baftopia/data/category_data.dart';
import 'package:baftopia/models/category.dart';
import 'package:baftopia/provider/category_provider.dart';
import 'package:baftopia/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key, this.modalContext});

  final BuildContext? modalContext;

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  File? _image;
  bool _isSubmitting = false;

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
        setState(() => _isSubmitting = true); // 🟢 trigger loading spinner

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
        setState(() => _isSubmitting = false); // 🔴 stop loading on failure
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

      try {
        await CategoryService().addCategory(category);

        if (!mounted) return;
        Navigator.of(widget.modalContext ?? context).pop(true);
        ref.invalidate(categoryProvider);

        Future.microtask(() {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'دسته بندی با موفقیت افزوده شد',
                style: TextStyle(
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
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در افزودن دسته‌بندی: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
      } finally {
        if (mounted) {
          setState(
            () => _isSubmitting = false,
          ); // ✅ always stop loading at the end
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: bottomInset + 20,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                ImageInput(onPickImage: _onPickImage),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.onSecondary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'انصراف',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: _isSubmitting ? null : Icon(Icons.add),
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
                      label:
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
                              : const Text(
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
      ),
    );
  }
}
