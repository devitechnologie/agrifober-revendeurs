import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/index.dart';

/// Shop bar at the bottom of the catalogue, shown once the cart holds a
/// product: cart icon with the count, articles + total, "Voir le panier".
class CartBar extends ConsumerWidget {
  const CartBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    if (cart.isEmpty) return const SizedBox.shrink();

    final radius = BorderRadius.circular(AppRadius.base);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.xs,
          AppSpacing.sm,
          AppSpacing.xs,
        ),
        child: Material(
          color: AppColors.primary,
          borderRadius: radius,
          child: InkWell(
            onTap: () => context.push(Routes.cart.route),
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  _CartIcon(count: cart.itemsCount),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextUI(
                          Helpers.plural(cart.itemsCount, 'article'),
                          style: CustomTextStyle(
                            fontSize: AppFontSize.xs,
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: TextUI(
                            Helpers.formatMad(cart.total),
                            style: CustomTextStyle(
                              fontSize: AppFontSize.base,
                              fontWeight: AppFontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextUI(
                    'Voir le panier',
                    style: CustomTextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  AppIcons.arrowSmallRightIconRR(
                    color: AppColors.white,
                    size: AppFontSize.lg,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcons.cartRR(
                color: AppColors.white,
                size: AppFontSize.lg,
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.circle),
              ),
              child: Center(
                child: TextUI(
                  count > 99 ? '99+' : '$count',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.xxs,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
