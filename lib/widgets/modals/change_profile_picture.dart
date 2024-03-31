import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePictureModal extends StatefulWidget {
  const ChangeProfilePictureModal(
      {super.key, required this.onPickImage, required this.oldAvatarUrl});

  final void Function(File pickedImage) onPickImage;
  final String oldAvatarUrl;

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
    final showDefaultAvatar =
        _pickedImageFile == null && widget.oldAvatarUrl == '';
    final showOldAvatar = _pickedImageFile == null && widget.oldAvatarUrl != '';

    var circleAvatar = CircleAvatar(
      radius: 100,
      backgroundImage: showDefaultAvatar
          ? const AssetImage('assets/images/default.png') as ImageProvider
          : showOldAvatar
              ? NetworkImage(widget.oldAvatarUrl) as ImageProvider
              : FileImage(_pickedImageFile!),
    );
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
          const SizedBox(height: 24),
          circleAvatar,
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
