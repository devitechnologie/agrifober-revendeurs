import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/delivery_notes/delivery_notes.dart';
import 'package:agrifober_resellers/features/invoices/invoices.dart';
import 'package:agrifober_resellers/features/orders/orders.dart';
import 'package:agrifober_resellers/features/sales/sales.dart';

/// "Historique" tab: commandes, achats, bons de livraison and factures behind
/// one toggle. `/history?tab=…` (see [Routes.historyTab]) opens a segment.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.initialTab});

  final HistoryTab? initialTab;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const _labels = {
    HistoryTab.orders: 'Commandes',
    HistoryTab.sales: 'Achats',
    HistoryTab.deliveryNotes: 'Bons',
    HistoryTab.invoices: 'Factures',
  };

  late int _selected = (widget.initialTab ?? HistoryTab.orders).index;

  // The branch is kept alive, so a later link to another segment arrives as a
  // widget update rather than a fresh state.
  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final tab = widget.initialTab;
    if (tab != null && tab != oldWidget.initialTab) {
      setState(() => _selected = tab.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBarHeader(title: 'Historique'),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                0,
                AppSpacing.base,
                AppSpacing.sm,
              ),
              child: SegmentedToggleUI(
                items: [for (final tab in HistoryTab.values) _labels[tab]!],
                selectedIndex: _selected,
                onChanged: (index) => setState(() => _selected = index),
              ),
            ),
            // IndexedStack keeps each list's scroll position and loaded pages.
            Expanded(
              child: IndexedStack(
                index: _selected,
                children: const [
                  OrdersList(),
                  SalesList(),
                  DeliveryNotesList(),
                  InvoicesList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
