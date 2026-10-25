import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/account/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/catalog/presentation/widgets/index.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/index.dart';

/// Review step of a new commande: quantities, an optional note, the part to
/// pay on credit (score crédit), then send.
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String _note = '';

  /// "Payer à crédit" switched on, and the amount typed (raw text).
  bool _useCredit = false;
  String _creditText = '';

  /// Most the revendeur can put on credit: his available credit, never more
  /// than the commande.
  double _creditCap(double available, double total) =>
      available < total ? available : total;

  double _typedCredit() =>
      double.tryParse(_creditText.replaceAll(' ', '').replaceAll(',', '.')) ??
      0;

  /// Amount actually sent: 0 when switched off, else the typed amount kept
  /// within 0…cap (the server checks it again).
  double _creditAmount(double cap) {
    if (!_useCredit || cap <= 0) return 0;
    final typed = _typedCredit();
    if (typed <= 0) return 0;
    return typed > cap ? cap : typed;
  }

  /// `1234.5` → "1234.5", `1000.0` → "1000": what the field shows.
  String _plainAmount(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);

  Future<void> _placeOrder(double creditAmount) async {
    FocusScope.of(context).unfocus();
    final order = await ref
        .read(placeOrderProvider.notifier)
        .placeOrder(note: _note, creditAmount: creditAmount);
    if (!mounted) return;

    if (order == null) {
      final error = ref.read(placeOrderProvider).error;
      NotificationService.showError(
        context,
        error == null
            ? 'Impossible d\'envoyer la commande.'
            : ErrorHelper.getErrorMessage(error),
      );
      return;
    }

    NotificationService.showSuccess(context, 'Commande envoyée à Agrifober.');
    // Leave the catalogue + cart flow and land on the new commande.
    context.go(Routes.historyTab(HistoryTab.orders));
    context.push(Routes.orderDetails.route(uid: order.order.uid));
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final placing = ref.watch(placeOrderProvider).isLoading;
    final summary = ref.watch(accountSummaryProvider);
    final available = summary.value?.creditScore.available ?? 0;
    final cap = _creditCap(available, cart.total);
    final creditAmount = _creditAmount(cap);

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: const MainAppBar(title: 'Panier'),
      body: cart.isEmpty
          ? Center(
              child: EmptyStateUI(
                icon: AppIcons.cartRR,
                title: 'Votre panier est vide',
                description: 'Ajoutez des produits depuis le catalogue.',
                action: ButtonUI(
                  onPressed: () => context.go(Routes.catalog.route),
                  text: 'Voir le catalogue',
                  width: 220,
                  minHeight: 44,
                  textSize: AppFontSize.base,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.base),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                _buildProducts(cart),
                const SizedBox(height: AppSpacing.base),
                _buildNote(),
                const SizedBox(height: AppSpacing.base),
                _buildCredit(
                  loading: summary.isLoading && !summary.hasValue,
                  available: available,
                  cap: cap,
                ),
                const SizedBox(height: AppSpacing.base),
                _buildSummary(cart, creditAmount),
              ],
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : _buildSendBar(cart.total, creditAmount, placing),
    );
  }

  /// White card: one row per product (thumbnail, name, unit price, line
  /// total, stepper) and a link back to the catalogue.
  Widget _buildProducts(Map<String, CartItem> cart) {
    final notifier = ref.read(cartProvider.notifier);

    return _WhiteCard(
      title: 'Produits',
      trailing: TextUI(
        Helpers.plural(cart.itemsCount, 'article'),
        style: CustomTextStyle(
          fontSize: AppFontSize.xs,
          color: AppColors.black54,
        ),
      ),
      children: [
        for (final item in cart.values)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                ProductImage(product: item.product, size: 56),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUI(
                        item.product.name,
                        maxLines: 2,
                        style: CustomTextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.black,
                        ),
                      ),
                      TextUI(
                        '${Helpers.formatMad(item.product.resellerPrice)} l\'unité',
                        style: CustomTextStyle(
                          fontSize: AppFontSize.xs,
                          color: AppColors.black54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      TextUI(
                        Helpers.formatMad(item.total),
                        style: CustomTextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: AppFontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                QuantityStepperUI(
                  value: item.qty,
                  onIncrement: () => notifier.increment(item.product),
                  onDecrement: () => notifier.decrement(item.product),
                ),
              ],
            ),
          ),
        const Divider(height: AppSpacing.base, color: AppColors.gray),
        InkWell(
          onTap: () => context.go(Routes.catalog.route),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.base,
              AppSpacing.xxs,
              AppSpacing.base,
              AppSpacing.base,
            ),
            child: Row(
              children: [
                AppIcons.plusSmallRR(
                  color: AppColors.primary,
                  size: AppFontSize.lg,
                ),
                const SizedBox(width: AppSpacing.xxs),
                TextUI(
                  'Ajouter d\'autres produits',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: AppFontWeight.medium,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNote() {
    return _WhiteCard(
      title: 'Note pour Agrifober',
      trailing: TextUI(
        'Facultatif',
        style: CustomTextStyle(
          fontSize: AppFontSize.xs,
          color: AppColors.black54,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            0,
            AppSpacing.base,
            AppSpacing.base,
          ),
          child: TextFieldUI(
            hintText: 'Ex. livraison souhaitée avant vendredi',
            maxLines: 3,
            maxLength: 1000,
            onChanged: (value) => _note = value,
          ),
        ),
      ],
    );
  }

  /// "Payer à crédit": switch + amount, capped by the score crédit.
  Widget _buildCredit({
    required bool loading,
    required double available,
    required double cap,
  }) {
    final canUse = !loading && cap > 0;
    final over = _useCredit && _typedCredit() > cap;

    return _WhiteCard(
      title: 'Payer à crédit',
      trailing: Opacity(
        opacity: canUse ? 1 : 0.4,
        child: IgnorePointer(
          ignoring: !canUse,
          child: SwitchUI(
            value: _useCredit && canUse,
            activeColor: AppColors.primary,
            onChanged: (on) => setState(() {
              _useCredit = on;
              if (on) _creditText = _plainAmount(cap);
            }),
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            0,
            AppSpacing.base,
            AppSpacing.base,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUI(
                loading
                    ? 'Chargement de votre crédit disponible…'
                    : available > 0
                    ? 'Crédit disponible : ${Helpers.formatMad(available)}'
                    : 'Aucun crédit disponible pour le moment. Chaque achat '
                          'augmente votre score crédit.',
                style: CustomTextStyle(
                  fontSize: AppFontSize.xs,
                  color: available > 0 ? AppColors.primary : AppColors.black54,
                  fontWeight: available > 0
                      ? AppFontWeight.medium
                      : AppFontWeight.regular,
                ),
              ),
              if (_useCredit && canUse) ...[
                const SizedBox(height: AppSpacing.sm),
                TextFieldUI(
                  hintText: 'Montant à crédit',
                  value: _creditText,
                  keyBoardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  errorText: over
                      ? 'Maximum ${Helpers.formatMad(cap)} : ce montant sera envoyé.'
                      : null,
                  onChanged: (value) => setState(() => _creditText = value),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Light green summary, same style as the Accueil account card.
  Widget _buildSummary(Map<String, CartItem> cart, double creditAmount) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.base,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUI(
                  'Total estimé',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: AppFontWeight.medium,
                    color: AppColors.black54,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: TextUI(
                    Helpers.formatMad(cart.total),
                    style: CustomTextStyle(
                      fontSize: AppFontSize.xl3,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.tiny),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _figure(
                      'Articles',
                      '${cart.itemsCount}',
                      AppColors.black,
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: AppSpacing.sm,
                    endIndent: AppSpacing.sm,
                    color: AppColors.gray,
                  ),
                  Expanded(
                    flex: 2,
                    child: _figure(
                      'Votre marge estimée',
                      Helpers.formatMad(cart.estimatedMargin),
                      AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (creditAmount > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.tiny),
              ),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                spacing: AppSpacing.xs,
                children: [
                  _splitRow(
                    'À crédit',
                    Helpers.formatMad(creditAmount),
                    AppColors.primary,
                  ),
                  _splitRow(
                    'À payer à la livraison',
                    Helpers.formatMad(cart.total - creditAmount),
                    AppColors.black,
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.xs,
            ),
            child: TextUI(
              'Prix confirmés par Agrifober à la réception de la commande. '
              'Marge calculée sur les prix publics conseillés.',
              style: CustomTextStyle(
                fontSize: AppFontSize.xs,
                color: AppColors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _splitRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextUI(
          label,
          style: CustomTextStyle(
            fontSize: AppFontSize.sm,
            color: AppColors.black54,
          ),
        ),
        TextUI(
          value,
          style: CustomTextStyle(
            fontSize: AppFontSize.sm,
            fontWeight: AppFontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _figure(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUI(
            label,
            maxLines: 1,
            style: CustomTextStyle(
              fontSize: AppFontSize.xs,
              color: AppColors.black54,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: TextUI(
              value,
              style: CustomTextStyle(
                fontSize: AppFontSize.base,
                fontWeight: AppFontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fixed bar: the total stays visible next to the send button.
  Widget _buildSendBar(double total, double creditAmount, bool placing) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.gray)),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUI(
                    creditAmount > 0 ? 'À la livraison' : 'Total',
                    style: CustomTextStyle(
                      fontSize: AppFontSize.xs,
                      color: AppColors.black54,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: TextUI(
                      Helpers.formatMad(total - creditAmount),
                      style: CustomTextStyle(
                        fontSize: AppFontSize.lg,
                        fontWeight: AppFontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: ButtonUI(
                onPressed: () {
                  if (!placing) _placeOrder(creditAmount);
                },
                isLoading: placing,
                text: 'Envoyer la commande',
                textSize: AppFontSize.base,
                minHeight: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Flat white card with a bold title (and an optional right-hand note).
class _WhiteCard extends StatelessWidget {
  const _WhiteCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.base,
              AppSpacing.base,
              AppSpacing.base,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextUI(
                    title,
                    style: CustomTextStyle(
                      fontSize: AppFontSize.base,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
