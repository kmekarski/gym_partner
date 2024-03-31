import 'package:flutter/material.dart';

class CircleUserAvatar extends StatelessWidget {
  const CircleUserAvatar({
    super.key,
    required this.avatarUrl,
    this.radius = 20,
  });

  final String avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: avatarUrl != ''
          ? NetworkImage(avatarUrl) as ImageProvider
          : const AssetImage('assets/images/default.png'),
      radius: radius,
    );
  }
}
