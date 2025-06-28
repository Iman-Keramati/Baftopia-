import 'dart:io';

import 'package:baftopia/core/constants.dart';
import 'package:baftopia/data/category_data.dart';
import 'package:baftopia/models/category.dart';
import 'package:baftopia/provider/category_provider.dart';
import 'package:baftopia/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddCategory extends ConsumerStatefulWidget {
  final Category? category;
  final BuildContext? modalContext;

  const AddCategory({super.key, this.category, this.modalContext});

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  File? _image;
  String? _existingImageUrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      _titleController.text = widget.category!.title;
      _existingImageUrl = widget.category!.image;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onPickImage(File image) {
    setState(() {
      _image = image;
    });
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate() &&
        (_image != null || widget.category != null)) {
      final supabase = Supabase.instance.client;
      final categoryId = widget.category?.id ?? const Uuid().v4();

      String? publicUrl;

      if (_image != null) {
        final fileExt = _image!.path.split('.').last;
        final filePath = 'categories/$categoryId.$fileExt';
        final fileBytes = await _image!.readAsBytes();

        try {
          setState(() => _isSubmitting = true);

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
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('خطا در آپلود تصویر: $e')));
          return;
        }
      } else {
        publicUrl = widget.category!.image;
      }

      final category = Category(
        id: categoryId,
        title: _titleController.text,
        image: publicUrl,
      );

      try {
        if (widget.category != null) {
          await CategoryService().updateCategory(category);
        } else {
          await CategoryService().addCategory(category);
        }

        if (!mounted) return;
        Navigator.of(
          widget.modalContext ?? context,
        ).pop(widget.category != null ? category : true);
        ref.invalidate(categoryProvider);

        Future.microtask(() {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.category != null
                    ? AppTexts.categoryEdited
                    : AppTexts.categoryAdded,
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
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطا در ${widget.category != null ? 'ویرایش' : 'افزودن'} دسته‌بندی: $e',
            ),
            backgroundColor: Colors.red[700],
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
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
            bottom: bottomInset + AppConstants.paddingLarge,
            left: AppConstants.paddingMedium,
            right: AppConstants.paddingMedium,
            top: AppConstants.paddingMedium,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: AppTexts.categoryTitle,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppTexts.enterCategoryTitle;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                ImageInput(
                  onPickImage: _onPickImage,
                  existingImageUrl: _existingImageUrl,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  children: [
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppTexts.cancel),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    ElevatedButton.icon(
                      icon:
                          _isSubmitting
                              ? null
                              : Icon(
                                widget.category != null
                                    ? Icons.edit
                                    : Icons.add,
                              ),
                      onPressed: _isSubmitting ? null : _onSubmit,
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
                              : Text(
                                widget.category != null
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
      ),
    );
  }
}
