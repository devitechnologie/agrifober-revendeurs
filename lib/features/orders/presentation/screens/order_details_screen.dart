import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/index.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(orderDetailsProvider(uid));
    final loaded = details.value;

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: const MainAppBar(title: 'Commande'),
      body: details.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: AppColors.primary,
          ),
        ),
        error: (error, _) => ErrorStateUI(
          error: error,
          onRetry: () => ref.invalidate(orderDetailsProvider(uid)),
        ),
        data: (details) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.refresh(orderDetailsProvider(uid).future),
          child: _buildContent(details),
        ),
      ),
      bottomNavigationBar: loaded == null
          ? null
          : _buildActions(context, ref, loaded),
    );
  }

  Widget _buildContent(OrderDetails details) {
    final order = details.order;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.base),
      children: [
        _OrderHeader(order: order, linesCount: details.lines.length),
        if (order.status == OrderStatus.refused) ...[
          const SizedBox(height: AppSpacing.sm),
          _NoteRow(
            icon: AppIcons.crossCircleRR,
            label: 'Motif du refus',
            text: order.refusalReason.isEmpty
                ? 'Commande refusée par Agrifober.'
                : order.refusalReason,
            danger: true,
          ),
        ],
        if (order.note.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          _NoteRow(
            icon: AppIcons.commentSR,
            label: 'Votre note',
            text: order.note,
          ),
        ],
        const SizedBox(height: AppSpacing.base),
        _ProductsCard(lines: details.lines, total: order.total),
        const SizedBox(height: AppSpacing.base),
        _Timeline(history: details.history),
      ],
    );
  }

  /// Fixed bottom bar: reorder always, cancel while still pending.
  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    OrderDetails details,
  ) {
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
            if (details.order.canBeCancelled) ...[
              SizedBox(
                width: 120,
                child: ButtonUI(
                  onPressed: () => _confirmCancel(context, ref),
                  text: 'Annuler',
                  variant: ButtonVariant.outlined,
                  setTextColor: AppColors.danger,
                  textSize: AppFontSize.base,
                  minHeight: 48,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: ButtonUI(
                onPressed: () => _reorder(context, ref, details),
                text: 'Commander à nouveau',
                icon: AppIcons.cartRR,
                textSize: AppFontSize.base,
                minHeight: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Refills the cart with this commande's products at today's prices.
  Future<void> _reorder(
    BuildContext context,
    WidgetRef ref,
    OrderDetails details,
  ) async {
    final int skipped;
    try {
      skipped = await ref.read(cartProvider.notifier).reorder(details.lines);
    } catch (error) {
      if (!context.mounted) return;
      NotificationService.showError(
        context,
        ErrorHelper.getErrorMessage(error),
      );
      return;
    }
    if (!context.mounted) return;

    if (skipped == details.lines.length) {
      NotificationService.showWarning(
        context,
        'Ces produits ne sont plus disponibles à la commande.',
      );
      return;
    }
    if (skipped > 0) {
      NotificationService.showWarning(
        context,
        '${Helpers.plural(skipped, 'produit')} ${skipped > 1 ? 'ne sont' : 'n\'est'} plus disponible${skipped > 1 ? 's' : ''}.',
      );
    }
    context.push(Routes.cart.route);
  }

  void _confirmCancel(BuildContext context, WidgetRef ref) {
    final isLoading = ValueNotifier(false);
    DialogService.showConfirmDialog(
      context: context,
      title: 'Annuler la commande ?',
      content: 'Agrifober ne traitera pas cette commande.',
      confirmText: 'Annuler la commande',
      cancelText: 'Garder la commande',
      isLoadingNotifier: isLoading,
      onConfirm: ({required onClose}) async {
        isLoading.value = true;
        final failure = await ref
            .read(cancelOrderProvider.notifier)
            .cancel(uid);
        isLoading.value = false;
        onClose();
        if (!context.mounted) return;
        if (failure == null) {
          NotificationService.showSuccess(context, 'Commande annulée.');
        } else {
          NotificationService.showError(context, failure.message);
        }
      },
    );
  }
}

/// Light green header (same style as the Accueil account card): date, status,
/// total, and a white panel with the key facts.
class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.order, required this.linesCount});

  final Order order;
  final int linesCount;

  @override
  Widget build(BuildContext context) {
    final local = order.createdAt.toLocal();
    final time =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

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
                Row(
                  children: [
                    Expanded(
                      child: TextUI(
                        'Commande du ${Helpers.formatDate(local)}',
                        style: CustomTextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.black54,
                        ),
                      ),
                    ),
                    StatusBadgeUI(
                      label: order.status.label,
                      variant: order.status.badge,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: TextUI(
                    Helpers.formatMad(order.total),
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
                  Expanded(child: _fact('Heure', time)),
                  _divider(),
                  Expanded(child: _fact('Produits', '$linesCount')),
                  _divider(),
                  Expanded(
                    flex: 2,
                    child: _fact(
                      'Bon de livraison',
                      order.hasDeliveryNote ? 'Émis' : 'Pas encore',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Part paid with the score crédit.
          if (order.creditAmount > 0) ...[
            const SizedBox(height: AppSpacing.xs),
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
                      child: _fact(
                        'À crédit',
                        Helpers.formatMad(order.creditAmount),
                        color: AppColors.primary,
                      ),
                    ),
                    _divider(),
                    Expanded(
                      child: _fact(
                        'À la livraison',
                        Helpers.formatMad(order.payableAtDelivery),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _divider() => const VerticalDivider(
    width: 1,
    thickness: 1,
    indent: AppSpacing.sm,
    endIndent: AppSpacing.sm,
    color: AppColors.gray,
  );

  static Widget _fact(
    String label,
    String value, {
    Color color = AppColors.black,
  }) {
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
          TextUI(
            value,
            maxLines: 1,
            style: CustomTextStyle(
              fontSize: AppFontSize.base,
              fontWeight: AppFontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Flat white row with a tinted icon: the revendeur's note or the refusal
/// reason.
class _NoteRow extends StatelessWidget {
  const _NoteRow({
    required this.icon,
    required this.label,
    required this.text,
    this.danger = false,
  });

  final AppIcon icon;
  final String label;
  final String text;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.tiny),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon(color: color, size: AppFontSize.base),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUI(
                  label,
                  style: CustomTextStyle(
                    fontSize: AppFontSize.xs,
                    fontWeight: AppFontWeight.medium,
                    color: danger ? AppColors.danger : AppColors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                TextUI(
                  text,
                  style: CustomTextStyle(
                    fontSize: AppFontSize.sm,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// White card: one row per product (quantity bubble, name, unit price, line
/// total) and the commande total at the bottom.
class _ProductsCard extends StatelessWidget {
  const _ProductsCard({required this.lines, required this.total});

  final List<DocumentLine> lines;
  final double total;

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
            child: TextUI(
              'Produits',
              style: CustomTextStyle(
                fontSize: AppFontSize.base,
                fontWeight: AppFontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 36),
                    height: 36,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Center(
                      child: TextUI(
                        '${_qty(line.qty)}×',
                        style: CustomTextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: AppFontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextUI(
                          line.designation,
                          style: CustomTextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: AppFontWeight.medium,
                            color: AppColors.black,
                          ),
                        ),
                        TextUI(
                          '${Helpers.formatMad(line.unitPrice)} l\'unité',
                          style: CustomTextStyle(
                            fontSize: AppFontSize.xs,
                            color: AppColors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  TextUI(
                    Helpers.formatMad(line.total),
                    style: CustomTextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: AppFontWeight.medium,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: Divider(height: AppSpacing.lg, color: AppColors.gray),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.base,
              0,
              AppSpacing.base,
              AppSpacing.base,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextUI(
                    'Total',
                    style: CustomTextStyle(
                      fontSize: AppFontSize.base,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                TextUI(
                  Helpers.formatMad(total),
                  style: CustomTextStyle(
                    fontSize: AppFontSize.lg,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _qty(double qty) =>
      qty == qty.truncateToDouble() ? qty.toStringAsFixed(0) : '$qty';
}

/// "Suivi": status changes as a vertical timeline, latest in bold.
class _Timeline extends StatelessWidget {
  const _Timeline({required this.history});

  final List<OrderStatusChange> history;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUI(
            'Suivi',
            style: CustomTextStyle(
              fontSize: AppFontSize.base,
              fontWeight: AppFontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (index, change) in history.indexed)
            _step(change, isLast: index == history.length - 1),
        ],
      ),
    );
  }

  Widget _step(OrderStatusChange change, {required bool isLast}) {
    final color = isLast ? _dotColor(change.status) : AppColors.gray600;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 3),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: AppColors.gray)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.base),
              child: Row(
                children: [
                  Expanded(
                    child: TextUI(
                      change.status.label,
                      style: CustomTextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: isLast
                            ? AppFontWeight.bold
                            : AppFontWeight.regular,
                        color: isLast ? AppColors.black : AppColors.black54,
                      ),
                    ),
                  ),
                  TextUI(
                    Helpers.formatDateTime(change.at),
                    style: CustomTextStyle(
                      fontSize: AppFontSize.xs,
                      color: AppColors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _dotColor(OrderStatus status) => switch (status) {
    OrderStatus.refused => AppColors.danger,
    OrderStatus.cancelled => AppColors.black54,
    OrderStatus.pending => AppColors.warning,
    _ => AppColors.primary,
  };
}
