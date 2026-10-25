import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/profile/domain/domain.dart';
import 'package:agrifober_resellers/features/profile/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/profile/presentation/widgets/delete_account_sheet.dart';

/// "Mon compte", opened from the profile card (bookify's account-info
/// pattern): what Agrifober recorded for the revendeur — read-only, changes go
/// through Agrifober — and account deletion.
class AccountInfoScreen extends ConsumerWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The stored session renders at once; /me refreshes it in the background.
    final user = ref.watch(currentUserProvider);
    final profile =
        ref.watch(profileProvider).value ??
        Profile(
          uid: user.uid,
          fullName: user.fullName,
          phone: user.phone,
          region: user.region,
          locationUrl: user.locationUrl,
        );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const MainAppBar(title: 'Mon compte'),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.refresh(profileProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            _buildDetails(profile),
            const SizedBox(height: AppSpacing.xs),
            TextUI(
              'Une information à corriger ? Contactez Agrifober.',
              style: CustomTextStyle(
                fontSize: AppFontSize.xs,
                color: AppColors.black54,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ButtonUI(
              onPressed: () => showDeleteAccountSheet(context),
              text: 'Supprimer mon compte',
              icon: AppIcons.trashIconRR,
              variant: ButtonVariant.outlined,
              setTextColor: AppColors.danger,
              textSize: AppFontSize.base,
              minHeight: 48,
            ),
            const SizedBox(height: AppSpacing.xs),
            TextUI(
              'Supprime votre accès à l\'application. Votre historique reste chez Agrifober.',
              textAlign: CustomTextAlign.center,
              style: CustomTextStyle(
                fontSize: AppFontSize.xs,
                color: AppColors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(Profile profile) {
    return SectionCardUI(
      title: 'Informations',
      child: Column(
        children: [
          InfoRowUI(label: 'Nom complet', value: profile.fullName),
          InfoRowUI(
            label: 'Téléphone',
            value: profile.phone.display.isEmpty ? '—' : profile.phone.display,
          ),
          InfoRowUI(
            label: 'Région',
            value: profile.region.isEmpty ? '—' : profile.region,
          ),
          if (profile.locationUrl.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            GestureDetector(
              onTap: () =>
                  UrlService.launchExternalUrlString(profile.locationUrl),
              child: Row(
                children: [
                  AppIcons.markerRR(
                    color: AppColors.primary,
                    size: AppFontSize.base,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  TextUI(
                    'Voir ma localisation sur la carte',
                    style: CustomTextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: AppFontWeight.medium,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
