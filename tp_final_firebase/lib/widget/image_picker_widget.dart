import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(XFile pickImage) imagePickFn;
  const UserImagePicker(this.imagePickFn, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? _photoFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _pickedImage = XFile(_photoFile!.path);
      widget.imagePickFn(_pickedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: (_pickedImage != null)
              ? FileImage(File(_pickedImage!.path))
              : null,
        ),
        TextButton.icon(
          onPressed: (() {
            _pickImage();
          }),
          icon: const Icon(Icons.image),
          label: const Text("Add Image"),
        ),
      ],
    );
  }
}
