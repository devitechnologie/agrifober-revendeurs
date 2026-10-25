import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/account/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/cart_provider.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/orders_provider.dart';

part 'order_actions_provider.g.dart';

@riverpod
class PlaceOrderNotifier extends _$PlaceOrderNotifier {
  @override
  AsyncValue<OrderDetails?> build() => const AsyncValue.data(null);

  /// Sends the cart, [creditAmount] of it on credit. Returns the created
  /// commande, or null on failure (the failure is in [state]).
  Future<OrderDetails?> placeOrder({
    String note = '',
    double creditAmount = 0,
  }) async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return null;

    state = const AsyncValue.loading();
    final result = await ref.read(placeOrderUseCaseProvider)(
      lines: cart.toRequestLines(),
      note: note,
      creditAmount: creditAmount,
    );

    return result.when<OrderDetails?>(
      success: (order) {
        ref.read(cartProvider.notifier).clear();
        ref.invalidate(ordersProvider);
        ref.invalidate(accountSummaryProvider);
        if (ref.mounted) state = AsyncValue.data(order);
        return order;
      },
      failure: (error) {
        if (ref.mounted) state = AsyncValue.error(error, StackTrace.current);
        return null;
      },
    );
  }
}

@riverpod
class CancelOrderNotifier extends _$CancelOrderNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Returns the failure when the server refused (e.g. already confirmed),
  /// null on success.
  Future<Failure?> cancel(String uid) async {
    state = const AsyncValue.loading();
    final result = await ref.read(cancelOrderUseCaseProvider)(uid);

    // Either way the commande changed on the server (cancelled, or confirmed
    // in the meantime): reload what the screens show.
    ref.invalidate(orderDetailsProvider(uid));
    ref.invalidate(ordersProvider);
    ref.invalidate(accountSummaryProvider);

    return result.when<Failure?>(
      success: (_) {
        if (ref.mounted) state = const AsyncValue.data(null);
        return null;
      },
      failure: (error) {
        if (ref.mounted) state = AsyncValue.error(error, StackTrace.current);
        return error;
      },
    );
  }
}
