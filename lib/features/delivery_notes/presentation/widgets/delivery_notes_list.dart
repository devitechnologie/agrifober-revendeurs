import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/domain.dart';
import 'package:agrifober_resellers/features/delivery_notes/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/delivery_notes/presentation/widgets/delivery_note_tile.dart';

class DeliveryNotesList extends ConsumerWidget {
  const DeliveryNotesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginatedListUI<DeliveryNote>(
      state: ref.watch(deliveryNotesProvider),
      skeletons: DeliveryNoteMock.skeletons(),
      itemBuilder: (context, note) => DeliveryNoteTile(deliveryNote: note),
      empty: EmptyStateUI(
        icon: AppIcons.truckRR,
        title: 'Aucun bon',
        description: 'Aucun bon de livraison pour le moment.',
      ),
      onRefresh: () => ref.refresh(deliveryNotesProvider.future),
      onLoadMore: () => ref.read(deliveryNotesProvider.notifier).loadMore(),
    );
  }
}
