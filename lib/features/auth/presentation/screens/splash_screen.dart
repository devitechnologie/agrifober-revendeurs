import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/gen/assets.gen.dart';
import 'package:agrifober_resellers/config/config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.brand.logo.image(width: 220),
            const SizedBox(height: AppSpacing.xl4),
            const CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
