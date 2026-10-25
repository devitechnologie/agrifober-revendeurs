import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/features/account/account.dart';
import 'package:agrifober_resellers/features/auth/auth.dart';
import 'package:agrifober_resellers/features/catalog/catalog.dart';
import 'package:agrifober_resellers/features/credit/credit.dart';
import 'package:agrifober_resellers/features/delivery_notes/delivery_notes.dart';
import 'package:agrifober_resellers/features/documents/documents.dart';
import 'package:agrifober_resellers/features/invoices/invoices.dart';
import 'package:agrifober_resellers/features/orders/orders.dart';
import 'package:agrifober_resellers/features/profile/profile.dart';
import 'package:agrifober_resellers/features/sales/sales.dart';

part 'providers.g.dart';

// External dependencies

// keepAlive: one Dio, so one _AuthInterceptor queue. Auto-disposed, each
// fetch could build its own client and refresh in parallel with the same
// single-use refresh token.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return ApiClient.createDio();
}

// API Services & Local Services

@riverpod
AuthApiService authApiService(Ref ref) {
  return AuthApiService(ref.watch(dioProvider));
}

@riverpod
AuthLocalService authLocalService(Ref ref) {
  return AuthLocalService();
}

@riverpod
ProfileApiService profileApiService(Ref ref) {
  return ProfileApiService(ref.watch(dioProvider));
}

@riverpod
AccountApiService accountApiService(Ref ref) {
  return AccountApiService(ref.watch(dioProvider));
}

@riverpod
SalesApiService salesApiService(Ref ref) {
  return SalesApiService(ref.watch(dioProvider));
}

@riverpod
DeliveryNotesApiService deliveryNotesApiService(Ref ref) {
  return DeliveryNotesApiService(ref.watch(dioProvider));
}

@riverpod
InvoicesApiService invoicesApiService(Ref ref) {
  return InvoicesApiService(ref.watch(dioProvider));
}

@riverpod
DocumentsApiService documentsApiService(Ref ref) {
  return DocumentsApiService(ref.watch(dioProvider));
}

@riverpod
CreditApiService creditApiService(Ref ref) {
  return CreditApiService(ref.watch(dioProvider));
}

@riverpod
CatalogApiService catalogApiService(Ref ref) {
  return CatalogApiService(ref.watch(dioProvider));
}

@riverpod
OrdersApiService ordersApiService(Ref ref) {
  return OrdersApiService(ref.watch(dioProvider));
}

// Repositories

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(apiService: ref.watch(authApiServiceProvider));
}

@riverpod
UserSessionRepository userSessionRepository(Ref ref) {
  return UserSessionRepositoryImpl(
    localDataSource: ref.watch(authLocalServiceProvider),
  );
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(
    apiService: ref.watch(profileApiServiceProvider),
  );
}

@riverpod
AccountRepository accountRepository(Ref ref) {
  return AccountRepositoryImpl(
    apiService: ref.watch(accountApiServiceProvider),
  );
}

@riverpod
SalesRepository salesRepository(Ref ref) {
  return SalesRepositoryImpl(apiService: ref.watch(salesApiServiceProvider));
}

@riverpod
DeliveryNotesRepository deliveryNotesRepository(Ref ref) {
  return DeliveryNotesRepositoryImpl(
    apiService: ref.watch(deliveryNotesApiServiceProvider),
  );
}

@riverpod
InvoicesRepository invoicesRepository(Ref ref) {
  return InvoicesRepositoryImpl(
    apiService: ref.watch(invoicesApiServiceProvider),
  );
}

@riverpod
DocumentsRepository documentsRepository(Ref ref) {
  return DocumentsRepositoryImpl(
    apiService: ref.watch(documentsApiServiceProvider),
  );
}

@riverpod
CreditRepository creditRepository(Ref ref) {
  return CreditRepositoryImpl(apiService: ref.watch(creditApiServiceProvider));
}

@riverpod
CatalogRepository catalogRepository(Ref ref) {
  return CatalogRepositoryImpl(
    apiService: ref.watch(catalogApiServiceProvider),
  );
}

@riverpod
OrdersRepository ordersRepository(Ref ref) {
  return OrdersRepositoryImpl(apiService: ref.watch(ordersApiServiceProvider));
}

// Use Cases

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
GetProfileUseCase getProfileUseCase(Ref ref) {
  return GetProfileUseCase(ref.watch(profileRepositoryProvider));
}

@riverpod
ChangePasswordUseCase changePasswordUseCase(Ref ref) {
  return ChangePasswordUseCase(ref.watch(profileRepositoryProvider));
}

@riverpod
DeleteAccountUseCase deleteAccountUseCase(Ref ref) {
  return DeleteAccountUseCase(ref.watch(profileRepositoryProvider));
}

@riverpod
GetAccountSummaryUseCase getAccountSummaryUseCase(Ref ref) {
  return GetAccountSummaryUseCase(ref.watch(accountRepositoryProvider));
}

@riverpod
GetSalesUseCase getSalesUseCase(Ref ref) {
  return GetSalesUseCase(ref.watch(salesRepositoryProvider));
}

@riverpod
GetSaleUseCase getSaleUseCase(Ref ref) {
  return GetSaleUseCase(ref.watch(salesRepositoryProvider));
}

@riverpod
GetDeliveryNotesUseCase getDeliveryNotesUseCase(Ref ref) {
  return GetDeliveryNotesUseCase(ref.watch(deliveryNotesRepositoryProvider));
}

@riverpod
GetDeliveryNoteUseCase getDeliveryNoteUseCase(Ref ref) {
  return GetDeliveryNoteUseCase(ref.watch(deliveryNotesRepositoryProvider));
}

@riverpod
GetInvoicesUseCase getInvoicesUseCase(Ref ref) {
  return GetInvoicesUseCase(ref.watch(invoicesRepositoryProvider));
}

@riverpod
DownloadDocumentUseCase downloadDocumentUseCase(Ref ref) {
  return DownloadDocumentUseCase(ref.watch(documentsRepositoryProvider));
}

@riverpod
GetCreditStatementUseCase getCreditStatementUseCase(Ref ref) {
  return GetCreditStatementUseCase(ref.watch(creditRepositoryProvider));
}

@riverpod
GetCatalogUseCase getCatalogUseCase(Ref ref) {
  return GetCatalogUseCase(ref.watch(catalogRepositoryProvider));
}

@riverpod
GetOrdersUseCase getOrdersUseCase(Ref ref) {
  return GetOrdersUseCase(ref.watch(ordersRepositoryProvider));
}

@riverpod
GetOrderUseCase getOrderUseCase(Ref ref) {
  return GetOrderUseCase(ref.watch(ordersRepositoryProvider));
}

@riverpod
PlaceOrderUseCase placeOrderUseCase(Ref ref) {
  return PlaceOrderUseCase(ref.watch(ordersRepositoryProvider));
}

@riverpod
CancelOrderUseCase cancelOrderUseCase(Ref ref) {
  return CancelOrderUseCase(ref.watch(ordersRepositoryProvider));
}
