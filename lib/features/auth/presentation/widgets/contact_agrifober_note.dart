import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';

/// Accounts are created and reset by Agrifober: no sign-up, no self-service
/// password reset — this note tells the revendeur how to reach Agrifober
/// instead (phone call or WhatsApp).
class ContactAgrifoberNote extends StatelessWidget {
  const ContactAgrifoberNote({super.key});

  static final _whatsAppMessage = Uri.encodeComponent(
    "Bonjour Agrifober, j'ai besoin d'aide pour accéder à mon compte revendeur.",
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.tiny),
      ),
      child: Column(
        children: [
          TextUI(
            "Pas de compte ou mot de passe oublié ?",
            textAlign: CustomTextAlign.center,
            style: CustomTextStyle(
              fontWeight: AppFontWeight.regular,
              fontSize: AppFontSize.sm,
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
          _link(
            icon: AppIcons.phoneSR,
            label: "Contactez Agrifober",
            url: 'tel:$supportPhoneNumber',
          ),
          SizedBox(height: AppSpacing.xxs),
          _link(
            icon: AppIcons.whatsappSR,
            label: "Écrire sur WhatsApp",
            url: 'https://wa.me/$supportWhatsAppNumber?text=$_whatsAppMessage',
          ),
        ],
      ),
    );
  }

  Widget _link({
    required AppIcon icon,
    required String label,
    required String url,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => UrlService.launchExternalUrlString(url),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xxs,
          children: [
            icon(size: AppFontSize.sm),
            TextUI(
              label,
              style: CustomTextStyle(
                fontWeight: AppFontWeight.medium,
                fontSize: AppFontSize.sm,
                color: AppColors.primary,
                decoration: CustomTextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
