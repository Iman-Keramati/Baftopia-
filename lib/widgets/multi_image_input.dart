import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageInput extends StatefulWidget {
  final void Function(List<File> images) onPickImages;
  final List<String>? existingImageUrls; // for edit mode preview
  final int maxImages;

  const MultiImageInput({
    super.key,
    required this.onPickImages,
    this.existingImageUrls,
    this.maxImages = 10,
  });

  @override
  State<MultiImageInput> createState() => _MultiImageInputState();
}

class _MultiImageInputState extends State<MultiImageInput> {
  final List<File> _selectedImages = [];

  void _notifyParent() {
    widget.onPickImages(List<File>.unmodifiable(_selectedImages));
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(maxWidth: 1024);
    if (picked.isEmpty) return;

    final remaining = widget.maxImages - _selectedImages.length;
    final toAdd = picked.take(remaining).map((x) => File(x.path)).toList();
    if (toAdd.isEmpty) return;

    setState(() {
      _selectedImages.addAll(toAdd);
    });
    _notifyParent();
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final shot = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
    );
    if (shot == null) return;

    if (_selectedImages.length >= widget.maxImages) return;

    setState(() {
      _selectedImages.add(File(shot.path));
    });
    _notifyParent();
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('انتخاب چند عکس از گالری'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('گرفتن عکس با دوربین'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromCamera();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _removeAt(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    _notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    final hasAny =
        _selectedImages.isNotEmpty ||
        (widget.existingImageUrls != null &&
            widget.existingImageUrls!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _showPickerSheet,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('انتخاب عکس'),
            ),
            const SizedBox(width: 12),
            Text(
              '${_selectedImages.length}/${widget.maxImages}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (hasAny)
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount:
                  _selectedImages.length +
                  (widget.existingImageUrls?.length ?? 0),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final existingCount = widget.existingImageUrls?.length ?? 0;
                final isExisting = index < existingCount;

                Widget thumb;
                if (isExisting) {
                  final url = widget.existingImageUrls![index];
                  thumb = ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  final file = _selectedImages[index - existingCount];
                  thumb = ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      file,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  );
                }

                return Stack(
                  children: [
                    thumb,
                    if (!isExisting)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeAt(index - existingCount),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
