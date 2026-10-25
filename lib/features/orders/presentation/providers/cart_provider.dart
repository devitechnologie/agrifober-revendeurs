import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';
import 'package:agrifober_resellers/features/catalog/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';

part 'cart_provider.g.dart';

class CartItem extends Equatable {
  final Product product;
  final int qty;

  const CartItem({required this.product, required this.qty});

  /// Indicative only: the server prices the order from the catalogue.
  double get total => product.resellerPrice * qty;

  @override
  List<Object?> get props => [product, qty];
}

/// The commande being prepared, keyed by product uid. Lives across the
/// catalogue and cart screens; reset when the signed-in revendeur changes and
/// after the commande is placed.
@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  static const maxQty = 100000;

  @override
  Map<String, CartItem> build() {
    ref.watch(authProvider.select((auth) => auth.value?.uid));
    return const {};
  }

  int qtyOf(String productUid) => state[productUid]?.qty ?? 0;

  void setQty(Product product, int qty) {
    final next = Map<String, CartItem>.of(state);
    if (qty <= 0) {
      next.remove(product.uid);
    } else {
      next[product.uid] = CartItem(product: product, qty: qty.clamp(1, maxQty));
    }
    state = next;
  }

  void increment(Product product) => setQty(product, qtyOf(product.uid) + 1);

  void decrement(Product product) => setQty(product, qtyOf(product.uid) - 1);

  void clear() => state = const {};

  /// "Commander à nouveau": adds a past commande's lines to the cart (on top
  /// of what is already there), at today's catalogue price. Returns how many
  /// lines were skipped because the product can no longer be ordered.
  Future<int> reorder(List<DocumentLine> lines) async {
    final catalog = await ref.read(catalogProvider.future);
    final products = {for (final p in catalog.products) p.uid: p};

    var skipped = 0;
    final next = Map<String, CartItem>.of(state);
    for (final line in lines) {
      final product = products[line.productUid];
      final qty = line.qty.round();
      if (product == null || qty <= 0) {
        skipped += 1;
        continue;
      }
      final current = next[product.uid]?.qty ?? 0;
      next[product.uid] = CartItem(
        product: product,
        qty: (current + qty).clamp(1, maxQty),
      );
    }
    state = next;
    return skipped;
  }
}

extension CartX on Map<String, CartItem> {
  int get itemsCount => values.fold(0, (sum, item) => sum + item.qty);

  double get total => values.fold(0, (sum, item) => sum + item.total);

  /// What the revendeur would earn selling everything at the recommended
  /// retail prices (products without one count for nothing).
  double get estimatedMargin => values.fold(
    0,
    (sum, item) => sum + (item.product.unitMargin ?? 0) * item.qty,
  );

  List<OrderRequestLine> toRequestLines() => values
      .map(
        (item) => OrderRequestLine(productUid: item.product.uid, qty: item.qty),
      )
      .toList();
}
