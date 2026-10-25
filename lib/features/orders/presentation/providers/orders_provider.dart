import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';

part 'orders_provider.g.dart';

/// The revendeur's commandes, one page at a time.
@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  bool _isLoadingMore = false;

  @override
  Future<Pagination<Order>> build() async {
    ref.watch(authProvider.select((auth) => auth.value?.uid));
    _isLoadingMore = false;
    return _fetch(page: 1);
  }

  Future<Pagination<Order>> _fetch({required int page}) async {
    final result = await ref.read(getOrdersUseCaseProvider)(page: page);
    return result.when(
      success: (data) => data,
      failure: (error) => throw error,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage || _isLoadingMore) return;

    _isLoadingMore = true;
    try {
      final next = await _fetch(page: current.currentPage + 1);
      state = AsyncValue.data(
        Pagination(
          data: [...current.data, ...next.data],
          currentPage: next.currentPage,
          lastPage: next.lastPage,
          perPage: next.perPage,
        ),
      );
    } catch (_) {
      // Rows already on screen stay; scrolling to the end again retries.
    } finally {
      _isLoadingMore = false;
    }
  }
}

@riverpod
Future<OrderDetails> orderDetails(Ref ref, String uid) async {
  final result = await ref.read(getOrderUseCaseProvider)(uid);
  return result.when(success: (data) => data, failure: (error) => throw error);
}
