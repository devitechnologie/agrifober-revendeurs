import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/invoices/domain/entities/index.dart';

abstract class InvoicesRepository {
  Future<DataState<Pagination<Invoice>>> getInvoices({
    int page = 1,
    int perPage = 20,
  });
}
