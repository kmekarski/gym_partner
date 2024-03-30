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
import 'package:gym_partner/widgets/badges/circle_icon.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/chart/chart.dart';
import 'package:gym_partner/widgets/modals/change_profile_picture.dart';
import 'package:gym_partner/widgets/modals/sign_out_confirmation_modal.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDarkMode = false;

  void _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  void _showSignOutModal() {
    showDialog(
        context: context,
        builder: (context) => SignoutConfirmationModal(onSignOut: _signOut));
  }

  void _showChangeUserDataModal({
    required String title,
    required String label,
    String passwordLabel = 'Password',
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => _changeUserDataModalContent(
        title: title,
        fieldLabel: label,
        passwordFieldLabel: passwordLabel,
      ),
    );
  }

  void _changeProfilePicture(File image) {
    print('profile picture changed');
  }

  void _changeUsername() {}

  void _showChangeProfilePictureModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ChangeProfilePictureModal(
              onPickImage: _changeProfilePicture,
            ));
  }

  Widget _changeUserDataModalContent({
    required String title,
    required String fieldLabel,
    required String passwordFieldLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 24),
          Form(
              child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text(fieldLabel)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(label: Text(passwordFieldLabel)),
              ),
              const SizedBox(height: 24),
              WideButton(
                onPressed: () {},
                text: 'Save',
              ),
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final username = userData.username;
    final email = userData.email;
    var userProfileCard = Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/default.png'),
              radius: 26,
            ),
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
                Text(email),
              ],
            ),
          ],
        ),
      ),
    );
    var darkModeCard = Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const CircleIcon(iconData: Icons.dark_mode),
            const SizedBox(width: 12),
            Text(
              'Dark mode',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
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
              darkModeCard,
              const SizedBox(height: 8),
              clickableSettingCard(
                context,
                Icons.person,
                'Change username',
                () => _showChangeUserDataModal(
                    title: 'Change username', label: 'New username'),
              ),
              clickableSettingCard(
                context,
                Icons.mail,
                'Change email',
                () => _showChangeUserDataModal(
                    title: 'Change email', label: 'New email'),
              ),
              clickableSettingCard(
                context,
                Icons.lock,
                'Change password',
                () => _showChangeUserDataModal(
                    title: 'Change password',
                    label: 'New password',
                    passwordLabel: 'Current password'),
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
