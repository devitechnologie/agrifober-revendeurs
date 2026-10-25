import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/account/domain/domain.dart';

part 'account_summary_provider.g.dart';

@riverpod
Future<AccountSummary> accountSummary(Ref ref) async {
  // Belongs to whoever is signed in.
  ref.watch(authProvider.select((auth) => auth.value?.uid));
  final result = await ref.read(getAccountSummaryUseCaseProvider)();
  return result.when(success: (data) => data, failure: (error) => throw error);
}
