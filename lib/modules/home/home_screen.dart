import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/account/account.dart';
import 'package:agrifober_resellers/features/catalog/catalog.dart';
import 'package:agrifober_resellers/features/delivery_notes/delivery_notes.dart';
import 'package:agrifober_resellers/features/orders/orders.dart';
import 'package:agrifober_resellers/features/sales/sales.dart';

/// "Accueil": the revendeur's key figures (the web page's "Statistiques"),
/// a shortcut to the catalogue with a strip of products, and the latest
/// activity.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Height of the floating [CartBar] plus a little air.
  static const _cartBarClearance = 96.0;

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(salesProvider);
    ref.invalidate(deliveryNotesProvider);
    ref.invalidate(ordersProvider);
    ref.invalidate(catalogProvider);
    ref.invalidate(accountSummaryProvider);
    await ref.read(accountSummaryProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final cartIsEmpty = ref.watch(cartProvider.select((c) => c.isEmpty));

    return Scaffold(
      // Same floating cart bar as the Catalogue: the page scrolls behind it.
      extendBody: true,
      backgroundColor: AppColors.accent,
      // bottom: false — with extendBody the bottom inset includes the cart
      // bar; the list reserves its own room for it instead.
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => _refresh(ref),
          // Horizontal padding is per section so the products strip can
          // scroll edge to edge.
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: AppSpacing.base,
              bottom: cartIsEmpty ? AppSpacing.base : _cartBarClearance,
            ),
            children: [
              _padded(_buildGreeting(user.fullName)),
              const SizedBox(height: AppSpacing.base),
              _padded(const _SummarySection()),
              const SizedBox(height: AppSpacing.base),
              _padded(const _OrderCallToAction()),
              const SizedBox(height: AppSpacing.base),
              const _ProductsStrip(),
              _padded(const _PendingOrders()),
              _padded(const _RecentDocuments()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CartBar(),
    );
  }

  static Widget _padded(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
    child: child,
  );

  Widget _buildGreeting(String fullName) {
    final firstName = fullName.trim().split(RegExp(r'\s+')).first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextUI(
          'Bonjour $firstName',
          style: CustomTextStyle(
            fontSize: AppFontSize.xxl,
            fontWeight: AppFontWeight.bold,
            color: AppColors.black,
          ),
        ),
        TextUI(
          'Votre espace revendeur Agrifober',
          style: CustomTextStyle(
            fontSize: AppFontSize.sm,
            color: AppColors.black54,
          ),
        ),
      ],
    );
  }
}

class _SummarySection extends ConsumerWidget {
  const _SummarySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(accountSummaryProvider);

    return summary.when(
      skipLoadingOnRefresh: true,
      loading: () => Skeletonizer(
        effect: const ShimmerEffect(baseColor: AppColors.accent),
        child: _buildCards(context, AccountSummaryMock.skeleton()),
      ),
      error: (error, _) => SectionCardUI(
        child: ErrorStateUI(
          error: error,
          onRetry: () => ref.invalidate(accountSummaryProvider),
        ),
      ),
      data: (summary) => _buildCards(context, summary),
    );
  }

  Widget _buildCards(BuildContext context, AccountSummary summary) {
    return Column(
      spacing: AppSpacing.sm,
      children: [
        _CreditHeroCard(
          amount: summary.outstandingCredit,
          onTap: () => context.go(Routes.credit.route),
          footer: _StatStrip(
            items: [
              _StatItem(
                label: 'Chiffre d\'affaires',
                value: Helpers.formatMad(summary.revenue),
                flex: 2,
              ),
              _StatItem(
                label: 'Achats',
                value: '${summary.salesCount}',
                onTap: () => context.go(Routes.historyTab(HistoryTab.sales)),
              ),
              _StatItem(
                label: 'Bons',
                value: '${summary.deliveryNotesCount}',
                onTap: () =>
                    context.go(Routes.historyTab(HistoryTab.deliveryNotes)),
              ),
            ],
          ),
        ),
        // Score crédit: what can go on credit in the next commande.
        if (summary.creditScore.score > 0)
          _StatRow(
            icon: AppIcons.walletRR,
            label: 'Crédit disponible',
            value: Helpers.formatMad(summary.creditScore.available),
            valueColor: AppColors.primary,
            onTap: () => context.go(Routes.credit.route),
          ),
        if (summary.unpaidInvoicesTotal > 0)
          _StatRow(
            icon: AppIcons.documentRR,
            label: 'Factures à régler',
            value: Helpers.formatMad(summary.unpaidInvoicesTotal),
            valueColor: AppColors.danger,
            onTap: () => context.go(Routes.historyTab(HistoryTab.invoices)),
          ),
      ],
    );
  }
}

/// The account at a glance, on the same soft green tint as "Passer une
/// commande": "Crédit en cours" (tap → Crédit tab) with the other figures in
/// a white panel at the bottom ([footer]).
class _CreditHeroCard extends StatelessWidget {
  const _CreditHeroCard({
    required this.amount,
    required this.onTap,
    required this.footer,
  });

  final double amount;
  final VoidCallback onTap;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final owes = amount > 0;
    final radius = BorderRadius.circular(AppRadius.base);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: radius,
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: _buildCredit(owes),
            ),
          ),
          footer,
        ],
      ),
    );
  }

  Widget _buildCredit(bool owes) {
    return Padding(
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
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: [
              TextUI(
                'Voir le détail',
                style: CustomTextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              AppIcons.arrowSmallRightIconRR(
                color: AppColors.primary,
                size: AppFontSize.base,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Light, tappable invitation to order — the brand colour stays for the
/// icon and arrow so it doesn't compete with the Crédit card above.
class _OrderCallToAction extends ConsumerWidget {
  const _OrderCallToAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsCount = ref.watch(catalogProvider).value?.products.length;
    final radius = BorderRadius.circular(AppRadius.base);

    return Material(
      color: AppColors.primary.withValues(alpha: 0.08),
      borderRadius: radius,
      child: InkWell(
        onTap: () => context.go(Routes.catalog.route),
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppIcons.cartRR(
                    color: AppColors.primary,
                    size: AppFontSize.lg,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUI(
                      'Passer une commande',
                      style: CustomTextStyle(
                        fontSize: AppFontSize.base,
                        fontWeight: AppFontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    TextUI(
                      productsCount == null
                          ? 'Catalogue au prix revendeur'
                          : '${Helpers.plural(productsCount, 'produit')} au prix revendeur',
                      style: CustomTextStyle(
                        fontSize: AppFontSize.xs,
                        color: AppColors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              AppIcons.arrowSmallRightIconRR(
                color: AppColors.primary,
                size: AppFontSize.xl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.label,
    required this.value,
    this.flex = 1,
    this.onTap,
  });

  final String label;
  final String value;
  final int flex;
  final VoidCallback? onTap;
}

/// White panel, figures side by side separated by hairlines — reads like a
/// statement rather than a dashboard of icon tiles.
class _StatStrip extends StatelessWidget {
  const _StatStrip({required this.items});

  final List<_StatItem> items;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.tiny);

    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: radius),
      child: ClipRRect(
        borderRadius: radius,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, item) in items.indexed) ...[
                if (index > 0)
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: AppSpacing.sm,
                    endIndent: AppSpacing.sm,
                    color: AppColors.gray,
                  ),
                Expanded(flex: item.flex, child: _buildItem(item)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(_StatItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextUI(
                item.label,
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
                  item.value,
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
      ),
    );
  }
}

/// Full-width secondary figure: icon, label, value, chevron.
class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.black,
    required this.onTap,
  });

  final AppIcon icon;
  final String label;
  final String value;
  final Color valueColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.tiny);

    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: radius),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: valueColor == AppColors.danger
                        ? AppColors.danger.withValues(alpha: 0.1)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Center(
                    child: icon(
                      color: valueColor == AppColors.danger
                          ? AppColors.danger
                          : AppColors.primary,
                      size: AppFontSize.base,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextUI(
                    label,
                    style: CustomTextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: AppFontWeight.medium,
                      color: AppColors.black,
                    ),
                  ),
                ),
                TextUI(
                  value,
                  style: CustomTextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: AppFontWeight.bold,
                    color: valueColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                AppIcons.angleSmallRightIconRR(
                  color: AppColors.black54,
                  size: AppFontSize.lg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Commandes still waiting for Agrifober, if any.
class _PendingOrders extends ConsumerWidget {
  const _PendingOrders();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending =
        ref
            .watch(ordersProvider)
            .value
            ?.data
            .where(
              (o) =>
                  o.status == OrderStatus.pending ||
                  o.status == OrderStatus.confirmed,
            )
            .take(3)
            .toList() ??
        const <Order>[];
    if (pending.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: _HomeSection(
        title: 'Commandes en cours',
        trailing: _SeeAll(
          onTap: () => context.go(Routes.historyTab(HistoryTab.orders)),
        ),
        children: [for (final order in pending) OrderTile(order: order)],
      ),
    );
  }
}

/// Latest ventes and bons de livraison, newest first.
class _RecentDocuments extends ConsumerWidget {
  const _RecentDocuments();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sales = ref.watch(salesProvider);
    final notes = ref.watch(deliveryNotesProvider);

    if (sales.isLoading || notes.isLoading) {
      return Skeletonizer(
        effect: const ShimmerEffect(baseColor: AppColors.accent),
        child: _card(context, [
          for (final sale in SaleMock.skeletons(count: 3)) SaleTile(sale: sale),
        ]),
      );
    }

    final entries = <(DateTime, Widget)>[
      for (final sale in sales.value?.data.take(4) ?? const <Sale>[])
        (sale.date, SaleTile(sale: sale)),
      for (final note in notes.value?.data.take(4) ?? const <DeliveryNote>[])
        (note.date, DeliveryNoteTile(deliveryNote: note)),
    ]..sort((a, b) => b.$1.compareTo(a.$1));

    return _card(
      context,
      entries.isEmpty
          ? [
              EmptyStateUI(
                icon: AppIcons.receiptRR,
                title: 'Aucune activité',
                description:
                    'Vos achats et bons de livraison apparaîtront ici.',
              ),
            ]
          : [for (final entry in entries.take(4)) entry.$2],
    );
  }

  Widget _card(BuildContext context, List<Widget> children) {
    return _HomeSection(
      title: 'Activité récente',
      trailing: _SeeAll(
        onTap: () => context.go(Routes.historyTab(HistoryTab.sales)),
      ),
      children: children,
    );
  }
}

/// Home list section: flat white card, bold title + "Voir
/// tout", rows directly underneath.
class _HomeSection extends StatelessWidget {
  const _HomeSection({
    required this.title,
    required this.trailing,
    required this.children,
  });

  final String title;
  final Widget trailing;
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
                  trailing,
                ],
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SeeAll extends StatelessWidget {
  const _SeeAll({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextUI(
        'Voir tout',
        style: CustomTextStyle(
          fontSize: AppFontSize.sm,
          fontWeight: AppFontWeight.medium,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// "Nos produits": the first catalogue products with quick add, so the
/// revendeur can order without leaving the home screen.
class _ProductsStrip extends ConsumerWidget {
  const _ProductsStrip();

  static const _count = 10;
  static const _cardWidth = 150.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);

    return catalog.when(
      skipLoadingOnRefresh: true,
      loading: () => Skeletonizer(
        effect: const ShimmerEffect(baseColor: AppColors.accent),
        child: _buildStrip(context, ref, CatalogMock.skeleton().products),
      ),
      // The catalogue tab shows the error; the home screen simply omits it.
      error: (_, _) => const SizedBox.shrink(),
      data: (catalog) => catalog.products.isEmpty
          ? const SizedBox.shrink()
          : _buildStrip(context, ref, catalog.products.take(_count).toList()),
    );
  }

  Widget _buildStrip(
    BuildContext context,
    WidgetRef ref,
    List<Product> products,
  ) {
    final cart = ref.watch(cartProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreen._padded(
            Row(
              children: [
                Expanded(
                  child: TextUI(
                    'Nos produits',
                    style: CustomTextStyle(
                      fontSize: AppFontSize.lg,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                _SeeAll(onTap: () => context.go(Routes.catalog.route)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: ProductGridCard.height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              // First card lines up with the page, the last can scroll to
              // the screen edge.
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductGridCard(
                  product: product,
                  width: _cardWidth,
                  qty: cart[product.uid]?.qty ?? 0,
                  onIncrement: () =>
                      ref.read(cartProvider.notifier).increment(product),
                  onDecrement: () =>
                      ref.read(cartProvider.notifier).decrement(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
