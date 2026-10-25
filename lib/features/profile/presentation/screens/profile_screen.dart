import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/profile/domain/domain.dart';
import 'package:agrifober_resellers/features/profile/presentation/providers/index.dart';

/// "Profil" tab. The information is managed by Agrifober, so it is read-only.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.refresh(profileProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBarHeader(title: 'Profil'),
                _buildProfileCard(context, profile),
                const SizedBox(height: AppSpacing.sm),
                _buildMenu(context),
                const _AppVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tappable like bookify's: opens "Mon compte" (details, deletion).
  Widget _buildProfileCard(BuildContext context, Profile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Material(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.tiny),
        child: InkWell(
          onTap: () => context.push(Routes.accountInfo.route),
          borderRadius: BorderRadius.circular(AppRadius.tiny),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.base,
            ),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                AvatarUI(radius: 30, name: profile.fullName),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xxs,
                    children: [
                      TextUI(
                        profile.fullName,
                        maxLines: 1,
                        style: CustomTextStyle(
                          fontSize: AppFontSize.base,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.black,
                        ),
                      ),
                      TextUI(
                        profile.phone.display,
                        maxLines: 1,
                        style: CustomTextStyle(
                          fontSize: AppFontSize.sm - 1,
                          color: AppColors.black54,
                        ),
                      ),
                      TextUI(
                        'Voir mon compte',
                        maxLines: 1,
                        style: CustomTextStyle(
                          fontSize: AppFontSize.sm - 1,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppIcons.angleSmallRightIconRR(
                  size: AppFontSize.lg,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Column(
      children: [
        ListTileUI(
          icon: AppIcons.userPenRR,
          title: 'Modifier mot de passe',
          onTap: () => context.push(Routes.changePassword.route),
        ),
        ListTileUI(
          icon: AppIcons.phoneCallRR,
          title: 'Appeler Agrifober',
          onTap: () =>
              UrlService.launchExternalUrlString('tel:$supportPhoneNumber'),
        ),
        ListTileUI(
          icon: AppIcons.whatsappSR,
          title: 'Écrire sur WhatsApp',
          onTap: () => UrlService.launchExternalUrlString(
            'https://wa.me/$supportWhatsAppNumber',
          ),
        ),
        ListTileUI(
          icon: AppIcons.signOutAltRR,
          title: 'Se déconnecter',
          color: AppColors.danger,
          divider: false,
          onTap: () => _confirmLogout(context),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    final isLoading = ValueNotifier(false);
    DialogService.showConfirmDialog(
      context: context,
      title: 'Se déconnecter ?',
      content: 'Vous devrez saisir à nouveau votre mot de passe.',
      confirmText: 'Se déconnecter',
      cancelText: 'Annuler',
      isLoadingNotifier: isLoading,
      onConfirm: ({required onClose}) {
        onClose();
        AuthEvents.emit(LogOutEvent());
      },
    );
  }
}

class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (info == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Center(
            child: TextUI(
              'Version ${info.version} (${info.buildNumber})',
              style: CustomTextStyle(
                fontSize: AppFontSize.xs,
                color: AppColors.black54,
              ),
            ),
          ),
        );
      },
    );
  }
}
