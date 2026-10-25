import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/widgets/common/state_message_ui.dart';

/// A page-by-page list driven by an `AsyncValue<Pagination<T>>`: skeleton
/// rows while loading, an empty state, an error state with "Réessayer",
/// pull-to-refresh, and the next page requested near the end of the scroll.
class PaginatedListUI<T> extends StatelessWidget {
  const PaginatedListUI({
    super.key,
    required this.state,
    required this.itemBuilder,
    required this.skeletons,
    required this.empty,
    required this.onRefresh,
    required this.onLoadMore,
    this.header,
    this.padding = EdgeInsets.zero,
  });

  final AsyncValue<Pagination<T>> state;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final List<T> skeletons;
  final Widget empty;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  /// Scrolls with the list (e.g. a summary card above the rows).
  final Widget? header;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: state.when(
        skipLoadingOnRefresh: true,
        loading: () => Skeletonizer(
          effect: const ShimmerEffect(baseColor: AppColors.accent),
          child: _list(context, skeletons, hasMore: false),
        ),
        error: (error, _) =>
            _scrollable(ErrorStateUI(error: error, onRetry: () => onRefresh())),
        data: (page) => page.data.isEmpty
            ? _scrollable(empty)
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.extentAfter < 300) onLoadMore();
                  return false;
                },
                child: _list(context, page.data, hasMore: page.hasNextPage),
              ),
      ),
    );
  }

  Widget _list(BuildContext context, List<T> items, {required bool hasMore}) {
    final extra = (header != null ? 1 : 0) + (hasMore ? 1 : 0);
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      itemCount: items.length + extra,
      itemBuilder: (context, index) {
        if (header != null) {
          if (index == 0) return header!;
          index -= 1;
        }
        if (index >= items.length) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.base),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }
        return itemBuilder(context, items[index]);
      },
    );
  }

  /// Keeps pull-to-refresh working on the empty and error states.
  Widget _scrollable(Widget child) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      children: [?header, child],
    );
  }
}
