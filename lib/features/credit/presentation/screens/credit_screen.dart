import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/credit/domain/domain.dart';
import 'package:agrifober_resellers/features/credit/presentation/providers/index.dart';

/// "Crédit" tab: what the revendeur still owes, the credit lines behind it
/// and the règlements already made — the "Crédit" block of the web page.
class CreditScreen extends ConsumerWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statement = ref.watch(creditStatementProvider);

    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBarHeader(title: 'Crédit'),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => ref.refresh(creditStatementProvider.future),
                child: statement.when(
                  skipLoadingOnRefresh: true,
                  loading: () => Skeletonizer(
                    effect: const ShimmerEffect(baseColor: AppColors.accent),
                    child: _buildContent(
                      context,
                      CreditStatementMock.skeleton(),
                    ),
                  ),
                  error: (error, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      ErrorStateUI(
                        error: error,
                        onRetry: () => ref.invalidate(creditStatementProvider),
                      ),
                    ],
                  ),
                  data: (statement) => _buildContent(context, statement),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CreditStatement statement) {
    final totalCredited = statement.items.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final totalPaid = statement.payments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      // Starts right under the AppBarHeader, like the other tabs.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        0,
        AppSpacing.base,
        AppSpacing.base,
      ),
      children: [
        _OutstandingCard(
          amount: statement.outstanding,
          totalCredited: totalCredited,
          totalPaid: totalPaid,
        ),
        const SizedBox(height: AppSpacing.base),
        _CreditScoreCard(score: statement.creditScore),
        const SizedBox(height: AppSpacing.base),
        _ListCard(
          title: 'Crédits',
          count: statement.items.length,
          empty: EmptyStateUI(
            icon: AppIcons.creditCardRR,
            title: 'Aucun crédit',
            description: 'Les achats et bons à crédit apparaîtront ici.',
          ),
          children: [
            for (final item in statement.items) _CreditItemTile(item: item),
          ],
        ),
        const SizedBox(height: AppSpacing.base),
        _ListCard(
          title: 'Règlements',
          count: statement.payments.length,
          empty: EmptyStateUI(
            icon: AppIcons.receiptRR,
            title: 'Aucun règlement',
            description: 'Vos paiements à Agrifober apparaîtront ici.',
          ),
          children: [
            for (final payment in statement.payments)
              DocumentTileUI(
                icon: AppIcons.creditCardRR,
                title: 'Règlement du ${Helpers.formatDate(payment.date)}',
                subtitle: payment.channel.isEmpty
                    ? 'Règlement'
                    : payment.channel,
                amount: Helpers.formatMad(payment.amount),
              ),
          ],
        ),
      ],
    );
  }
}

/// Same look as the Accueil account card: soft green tint, the amount owed,
/// and a white panel with what was credited and paid back in total.
class _OutstandingCard extends StatelessWidget {
  const _OutstandingCard({
    required this.amount,
    required this.totalCredited,
    required this.totalPaid,
  });

  final double amount;
  final double totalCredited;
  final double totalPaid;

  @override
  Widget build(BuildContext context) {
    final owes = amount > 0;

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
                        'Crédit en cours',
                        style: CustomTextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.black54,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.circle),
                      ),
                      child: TextUI(
                        owes ? 'À régler' : 'Tout est réglé',
                        style: CustomTextStyle(
                          fontSize: AppFontSize.xs,
                          fontWeight: AppFontWeight.bold,
                          color: owes ? AppColors.danger : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: TextUI(
                    Helpers.formatMad(amount),
                    style: CustomTextStyle(
                      fontSize: AppFontSize.xl3,
                      fontWeight: AppFontWeight.bold,
                      color: owes ? AppColors.danger : AppColors.primary,
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
                  Expanded(child: _figure('Total crédité', totalCredited)),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: AppSpacing.sm,
                    endIndent: AppSpacing.sm,
                    color: AppColors.gray,
                  ),
                  Expanded(child: _figure('Total réglé', totalPaid)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _figure(String label, double value) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUI(
            label,
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
              Helpers.formatMad(value),
              style: CustomTextStyle(
                fontSize: AppFontSize.base,
                fontWeight: AppFontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Score crédit": what the revendeur can still put on credit on his next
/// commande, how much of his score is used, and how the score grows.
class _CreditScoreCard extends StatelessWidget {
  const _CreditScoreCard({required this.score});

  final CreditScore score;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextUI(
                  'Score crédit',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.base,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              TextUI(
                Helpers.formatMad(score.score),
                style: CustomTextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextUI(
            'Crédit disponible',
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
              Helpers.formatMad(score.available),
              style: CustomTextStyle(
                fontSize: AppFontSize.xxl,
                fontWeight: AppFontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.circle),
            child: LinearProgressIndicator(
              value: score.usedRatio,
              minHeight: 8,
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextUI(
                'Utilisé : ${Helpers.formatMad(score.used)}',
                style: CustomTextStyle(
                  fontSize: AppFontSize.xs,
                  color: AppColors.black54,
                ),
              ),
              if (score.pending > 0)
                TextUI(
                  'dont ${Helpers.formatMad(score.pending)} en commande',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.xs,
                    color: AppColors.black54,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: TextUI(
              'Chaque achat augmente votre score de 100 % de son montant. '
              'Utilisez votre crédit disponible au moment de commander, '
              'depuis le panier.',
              style: CustomTextStyle(
                fontSize: AppFontSize.xs,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Flat white card: bold title + count, then the rows (or an
/// empty state).
class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.title,
    required this.count,
    required this.empty,
    required this.children,
  });

  final String title;
  final int count;
  final Widget empty;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.base);

    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: radius),
      child: ClipRRect(
        borderRadius: radius,
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
                  TextUI(
                    title,
                    style: CustomTextStyle(
                      fontSize: AppFontSize.base,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(AppRadius.circle),
                    ),
                    child: TextUI(
                      '$count',
                      style: CustomTextStyle(
                        fontSize: AppFontSize.xs,
                        fontWeight: AppFontWeight.medium,
                        color: AppColors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (children.isEmpty) Center(child: empty) else ...children,
          ],
        ),
      ),
    );
  }
}

class _CreditItemTile extends StatelessWidget {
  const _CreditItemTile({required this.item});

  final CreditItem item;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      item.type.label,
      if (item.designation.isNotEmpty) item.designation,
    ].join(' · ');

    String? footnote;
    if (item.dueDate != null) {
      footnote = 'Échéance : ${Helpers.formatDate(item.dueDate!)}';
    } else if (item.type == CreditItemType.sale) {
      footnote = 'Sans échéance';
    }
    if (item.documentName.isNotEmpty) {
      footnote = [?footnote, 'Pièce jointe : ${item.documentName}'].join(' · ');
    }

    return DocumentTileUI(
      icon: switch (item.type) {
        CreditItemType.sale => AppIcons.receiptRR,
        CreditItemType.deliveryNote => AppIcons.truckRR,
        CreditItemType.manual => AppIcons.walletRR,
      },
      title: Helpers.formatDate(item.date),
      subtitle: subtitle,
      amount: Helpers.formatMad(item.remaining),
      badge: item.isOverdue
          ? const StatusBadgeUI(
              label: 'Échu',
              variant: StatusBadgeVariant.danger,
            )
          : null,
      footnote: footnote,
      footnoteColor: item.isOverdue ? AppColors.danger : AppColors.black54,
      onTap: _onTap(context),
    );
  }

  VoidCallback? _onTap(BuildContext context) {
    switch (item.type) {
      case CreditItemType.sale:
        return () => context.push(Routes.saleDetails.route(uid: item.uid));
      case CreditItemType.deliveryNote:
        return () =>
            context.push(Routes.deliveryNoteDetails.route(uid: item.uid));
      case CreditItemType.manual:
        if (item.documentUrl.isEmpty) return null;
        return () => UrlService.launchExternalUrlString(item.documentUrl);
    }
  }
}
