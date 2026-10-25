import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';
import 'package:agrifober_resellers/features/catalog/presentation/widgets/product_card.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/index.dart';

/// "Ajouter" on a product card: asks how many, then puts that quantity in the
/// cart. Opened again on a product already in the cart, it edits its quantity.
Future<void> showAddToCartSheet(BuildContext context, Product product) {
  return showAdaptiveModalSheet<void>(
    context: context,
    builder: (ctx, modalRef) => ModalSheetWrapper(
      modalRef: modalRef,
      title: 'Ajouter au panier',
      padding: const EdgeInsets.only(top: AppSpacing.base),
      child: _AddToCartForm(product: product, sheetContext: ctx),
    ),
  );
}

class _AddToCartForm extends ConsumerStatefulWidget {
  const _AddToCartForm({required this.product, required this.sheetContext});

  final Product product;
  final BuildContext sheetContext;

  @override
  ConsumerState<_AddToCartForm> createState() => _AddToCartFormState();
}

class _AddToCartFormState extends ConsumerState<_AddToCartForm> {
  static const _quickPicks = [1, 5, 10, 20, 50];

  late final bool _inCart;
  late int _qty;

  @override
  void initState() {
    super.initState();
    final current = ref.read(cartProvider.notifier).qtyOf(widget.product.uid);
    _inCart = current > 0;
    _qty = _inCart ? current : 1;
  }

  void _set(int qty) =>
      setState(() => _qty = qty.clamp(0, CartNotifier.maxQty));

  void _onTyped(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    _set(int.tryParse(digits) ?? 0);
  }

  void _submit() {
    if (_qty < 1) return;
    ref.read(cartProvider.notifier).setQty(widget.product, _qty);
    Navigator.of(widget.sheetContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProduct(product),
              const SizedBox(height: AppSpacing.lg),
              TextUI(
                'Quantité',
                style: CustomTextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              _buildQtyInput(),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final pick in _quickPicks)
                    ChipUI(
                      text: '$pick',
                      onPressed: () => _set(pick),
                      backgroundColor: _qty == pick
                          ? AppColors.primary
                          : AppColors.white,
                      textColor: _qty == pick
                          ? AppColors.white
                          : AppColors.black,
                      borderColor: _qty == pick
                          ? AppColors.primary
                          : AppColors.gray500,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
        _buildFooter(product),
      ],
    );
  }

  Widget _buildProduct(Product product) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: Border.all(color: AppColors.gray),
          ),
          child: Center(child: ProductImage(product: product, size: 52)),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUI(
                product.name,
                maxLines: 2,
                style: CustomTextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              TextUI(
                '${Helpers.formatMad(product.resellerPrice)} / unité',
                style: CustomTextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: AppFontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// `[−] [  12  ] [+]`: type the quantity or nudge it.
  Widget _buildQtyInput() {
    return Row(
      spacing: AppSpacing.xs,
      children: [
        _stepButton(
          AppIcons.minusSmallRR,
          _qty > 1 ? () => _set(_qty - 1) : null,
        ),
        Expanded(
          child: TextFieldUI(
            hintText: '0',
            value: _qty == 0 ? '' : '$_qty',
            keyBoardType: TextInputType.number,
            autoFocus: !_inCart,
            onChanged: _onTyped,
          ),
        ),
        _stepButton(AppIcons.plusSmallRR, () => _set(_qty + 1)),
      ],
    );
  }

  Widget _stepButton(AppIcon icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    final radius = BorderRadius.circular(AppRadius.small);
    return Material(
      color: AppColors.primary.withValues(alpha: enabled ? 0.1 : 0.04),
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: icon(
              color: enabled
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.3),
              size: AppFontSize.lg,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(Product product) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.gray)),
      ),
      padding: const EdgeInsets.all(AppSpacing.base),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextUI(
                  'Total',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.sm,
                    color: AppColors.black54,
                  ),
                ),
                TextUI(
                  Helpers.formatMad(product.resellerPrice * _qty),
                  style: CustomTextStyle(
                    fontSize: AppFontSize.lg,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ButtonUI(
              text: _inCart ? 'Mettre à jour le panier' : 'Ajouter au panier',
              valid: _qty >= 1,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
