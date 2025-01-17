import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/chart/chart_data_type.dart';
import 'package:gym_partner/models/total_stats_data.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/utils/form_validators.dart';
import 'package:gym_partner/utils/scaffold_messeger_utils.dart';
import 'package:gym_partner/utils/show_info_dialog.dart';
import 'package:gym_partner/widgets/badges/circle_icon.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/chart/chart.dart';
import 'package:gym_partner/widgets/circle_user_avatar.dart';
import 'package:gym_partner/widgets/modals/change_profile_picture.dart';
import 'package:gym_partner/widgets/modals/change_user_data.dart';
import 'package:gym_partner/widgets/modals/confirmation_modal.dart';
import 'package:gym_partner/widgets/modals/sign_out_confirmation_modal.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDarkMode = false;

  void _showChangeUserDataModal({
    required String title,
    required String label,
    required FormFieldType type,
    String passwordLabel = 'Password',
  }) async {
    final Future<void> Function(String newData, String password) onSaveCallback;
    switch (type) {
      case FormFieldType.username:
        onSaveCallback = _changeUsername;
      case FormFieldType.email:
        onSaveCallback = _changeEmail;
      case FormFieldType.password:
        onSaveCallback = _changePassword;
    }
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => ChangeUserDataModal(
        type: type,
        title: title,
        fieldLabel: label,
        passwordFieldLabel: passwordLabel,
        onSave: onSaveCallback,
      ),
    );
  }

  void _showChangeProfilePictureModal() {
    final oldAvatarUrl = ref.watch(userProvider).avatarUrl;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => ChangeProfilePictureModal(
        onPickImage: _changeProfilePicture,
        oldAvatarUrl: oldAvatarUrl,
      ),
    );
  }

  void _showSignOutModal() {
    showDialog(
        context: context,
        builder: (context) => SignoutConfirmationModal(onSignOut: _signOut));
  }

  Future<void> _changeUsername(
      String newUsername, String providedPassword) async {
    if (await ref
        .read(userProvider.notifier)
        .changeUsername(newUsername, providedPassword)) {
      Navigator.of(context).pop();
    } else {
      _showErrorDialog();
    }
  }

  Future<void> _changeEmail(String newEmail, String providedPassword) async {
    if (await ref
        .read(userProvider.notifier)
        .changeEmail(newEmail, providedPassword)) {
      _signOut();
      _showVerifyEmailDialog(newEmail);
    } else {
      _showErrorDialog();
    }
  }

  Future<void> _changePassword(
      String newPassword, String currentPassword) async {
    if (await ref
        .read(userProvider.notifier)
        .changePassword(newPassword, currentPassword)) {
      _signOut();
      _showPasswordChangedDialog();
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showCustomInfoDialog(context, 'Alert',
        'Something went wrong. Check your password and try again.');
  }

  void _showVerifyEmailDialog(String email) {
    showCustomInfoDialog(context, 'Email verification',
        'Verification link was send to $email. Click it to change your email.');
  }

  void _showPasswordChangedDialog() {
    showCustomInfoDialog(context, 'Success',
        'Your password was successfully updated. You can now use new password to sign in.');
  }

  Future<void> _changeProfilePicture(File image) async {
    await ref.read(userProvider.notifier).changeAvatar(image);
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final username = userData.username;
    final email = userData.email;
    final avatarUrl = userData.avatarUrl;
    var userProfileCard = Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Row(
          children: [
            CircleUserAvatar(avatarUrl: avatarUrl, radius: 30),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(email, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              userProfileCard,
              const SizedBox(height: 8),
              clickableSettingCard(
                context,
                Icons.person,
                'Change username',
                () => _showChangeUserDataModal(
                  title: 'Change username',
                  label: 'New username',
                  type: FormFieldType.username,
                ),
              ),
              clickableSettingCard(
                context,
                Icons.mail,
                'Change email',
                () => _showChangeUserDataModal(
                  title: 'Change email',
                  label: 'New email',
                  type: FormFieldType.email,
                ),
              ),
              clickableSettingCard(
                context,
                Icons.lock,
                'Change password',
                () => _showChangeUserDataModal(
                  title: 'Change password',
                  label: 'New password',
                  passwordLabel: 'Current password',
                  type: FormFieldType.password,
                ),
              ),
              clickableSettingCard(context, Icons.photo,
                  'Change profile picture', _showChangeProfilePictureModal),
              clickableSettingCard(
                  context, Icons.logout, 'Sign out', _showSignOutModal),
            ],
          ),
        ),
      ),
    );
  }

  Widget clickableSettingCard(
      BuildContext context, IconData icon, String text, void Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleIcon(iconData: icon),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
