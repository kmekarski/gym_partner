import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePictureModal extends StatefulWidget {
  const ChangeProfilePictureModal({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<ChangeProfilePictureModal> createState() =>
      _ChangeProfilePictureModalState();
}

class _ChangeProfilePictureModalState extends State<ChangeProfilePictureModal> {
  File? _pickedImageFile;

  void _pickPicture(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
  }

  void _save() {
    if (_pickedImageFile == null) {
      return;
    }
    widget.onPickImage(_pickedImageFile!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Change profile picture',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (_pickedImageFile != null)
            Column(
              children: [
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 100,
                  foregroundImage: _pickedImageFile != null
                      ? FileImage(_pickedImageFile!)
                      : null,
                ),
              ],
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              button(Icons.photo, 'Upload photo', ImageSource.gallery),
              button(Icons.camera_alt, 'Take photo', ImageSource.camera),
            ],
          ),
          const SizedBox(height: 24),
          if (_pickedImageFile != null)
            WideButton(
              onPressed: _save,
              text: 'Save',
            )
        ],
      ),
    );
  }

  Widget button(IconData icon, String text, ImageSource source) => InkWell(
        onTap: () => _pickPicture(source),
        borderRadius: BorderRadius.circular(16),
        child: Card(
          margin: const EdgeInsets.all(0),
          child: Container(
            width: 150,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 6),
                Text(text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      );
}
