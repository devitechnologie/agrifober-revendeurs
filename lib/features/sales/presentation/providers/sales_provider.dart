import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/sales/domain/domain.dart';

part 'sales_provider.g.dart';

/// The revendeur's ventes, one page at a time, growing as [loadMore] is called.
@riverpod
class SalesNotifier extends _$SalesNotifier {
  /// Keeps a second page request from starting while one is in flight.
  bool _isLoadingMore = false;

  @override
  Future<Pagination<Sale>> build() async {
    ref.watch(authProvider.select((auth) => auth.value?.uid));
    _isLoadingMore = false;
    return _fetch(page: 1);
  }

  Future<Pagination<Sale>> _fetch({required int page}) async {
    final result = await ref.read(getSalesUseCaseProvider)(page: page);
    return result.when(
      success: (data) => data,
      failure: (error) => throw error,
    );
  }

  /// Appends the next page. No-ops on the last page or while one is loading.
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
      // A failed extra page leaves the rows already on screen alone; scrolling
      // to the end again retries.
    } finally {
      _isLoadingMore = false;
    }
  }
}

@riverpod
Future<SaleDetails> saleDetails(Ref ref, String uid) async {
  final result = await ref.read(getSaleUseCaseProvider)(uid);
  return result.when(success: (data) => data, failure: (error) => throw error);
}
