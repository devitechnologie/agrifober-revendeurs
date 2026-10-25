import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/shared.dart';

/// Guest mode: pushes login rather than going to it, so "back" returns to
/// the catalogue; `from` brings the revendeur back to this page once signed
/// in (the router turns `/browse` into `/catalog`).
void pushSignIn(BuildContext context) {
  final from = GoRouterState.of(context).uri.toString();
  context.push(
    Uri(path: Routes.login.route, queryParameters: {'from': from}).toString(),
  );
}

/// Stands in for a price while signed out: "🔒 Prix réservé aux revendeurs".
class GuestPriceNotice extends StatelessWidget {
  const GuestPriceNotice({super.key, this.fontSize = AppFontSize.xs});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.xxs,
      children: [
        AppIcons.lockRR(color: AppColors.black54, size: fontSize),
        Flexible(
          child: TextUI(
            'Prix réservé aux revendeurs',
            maxLines: 1,
            style: CustomTextStyle(
              fontSize: fontSize,
              fontWeight: AppFontWeight.medium,
              color: AppColors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
