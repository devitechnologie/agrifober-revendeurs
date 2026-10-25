import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/credit/domain/domain.dart';

part 'credit_statement_provider.g.dart';

@riverpod
Future<CreditStatement> creditStatement(Ref ref) async {
  ref.watch(authProvider.select((auth) => auth.value?.uid));
  final result = await ref.read(getCreditStatementUseCaseProvider)();
  return result.when(success: (data) => data, failure: (error) => throw error);
}
