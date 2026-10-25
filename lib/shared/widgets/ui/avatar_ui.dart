import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/gen/assets.gen.dart';

class AvatarUI extends StatelessWidget {
  const AvatarUI({super.key, this.url, this.name, this.radius = 18});

  final String? url;
  final String? name;
  final double radius;

  String get _initials {
    final parts = name!
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) return _buildNetworkImage();
    if (name != null && name!.trim().isNotEmpty) return _buildInitialsAvatar();
    return _buildDefaultImage();
  }

  Widget _buildNetworkImage() {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url!),
      backgroundColor: AppColors.gray,
    );
  }

  Widget _buildInitialsAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.accent,
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: radius * 0.72,
          fontWeight: AppFontWeight.regular,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(Assets.images.shared.avatar.path),
      backgroundColor: AppColors.gray,
    );
  }
}
