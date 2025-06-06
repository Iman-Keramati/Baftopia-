import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onPickImage,
    this.imageSelectionType = 'camera',
  });

  final void Function(File image) onPickImage;
  final String? imageSelectionType;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source:
          widget.imageSelectionType == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
      maxWidth: 250,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      label: Text(
        widget.imageSelectionType == 'camera'
            ? 'عکس بگیرید'
            : 'انتخاب از گالری',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      icon: Icon(
        widget.imageSelectionType == 'camera'
            ? Icons.camera_alt
            : Icons.photo_library,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: double.infinity,
            height: 250,
            child: Image.file(_selectedImage!, fit: BoxFit.cover),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
