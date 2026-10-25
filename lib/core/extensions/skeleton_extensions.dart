import 'package:agrifober_resellers/core/entities/index.dart';
import 'package:agrifober_resellers/features/account/domain/domain.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';
import 'package:agrifober_resellers/features/credit/domain/domain.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/domain.dart';
import 'package:agrifober_resellers/features/invoices/domain/domain.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';
import 'package:agrifober_resellers/features/sales/domain/domain.dart';

// Placeholder rows behind each screen's `Skeletonizer`: same geometry as the
// real rows, so nothing jumps when the response lands.

final _placeholderDate = DateTime(2026);

extension AccountSummaryMock on AccountSummary {
  static AccountSummary skeleton() => const AccountSummary(
    salesCount: 0,
    deliveryNotesCount: 0,
    revenue: 10000,
    outstandingCredit: 1000,
    unpaidInvoicesTotal: 0,
    pendingOrdersCount: 0,
    creditScore: CreditScore(
      score: 10000,
      outstanding: 1000,
      pending: 0,
      available: 9000,
    ),
  );
}

extension SaleMock on Sale {
  static List<Sale> skeletons({int count = 5}) => List.generate(
    count,
    (i) => Sale(
      uid: '$i',
      date: _placeholderDate,
      type: SaleType.store,
      pointOfSale: 'Point de vente',
      linesCount: 2,
      total: 1000,
      paymentMethod: PaymentMethod.cash,
      amountPaid: 1000,
      remaining: 0,
      dueDate: null,
      isOverdue: false,
    ),
  );
}

extension DeliveryNoteMock on DeliveryNote {
  static List<DeliveryNote> skeletons({int count = 5}) => List.generate(
    count,
    (i) => DeliveryNote(
      uid: '$i',
      date: _placeholderDate,
      pointOfSale: 'Point de vente',
      linesCount: 2,
      total: 1000,
      paymentMethod: PaymentMethod.cash,
      amountPaid: 1000,
      remaining: 0,
    ),
  );
}

extension InvoiceMock on Invoice {
  static List<Invoice> skeletons({int count = 5}) => List.generate(
    count,
    (i) => Invoice(
      uid: '$i',
      date: _placeholderDate,
      dueDate: null,
      status: InvoiceStatus.sent,
      total: 1000,
      amountPaid: 0,
      outstanding: 1000,
      linesCount: 2,
    ),
  );
}

extension OrderMock on Order {
  static List<Order> skeletons({int count = 5}) => List.generate(
    count,
    (i) => Order(
      uid: '$i',
      status: OrderStatus.pending,
      total: 1000,
      note: '',
      refusalReason: '',
      linesCount: 2,
      hasDeliveryNote: false,
      creditAmount: 0,
      createdAt: _placeholderDate,
      updatedAt: _placeholderDate,
    ),
  );
}

extension CreditStatementMock on CreditStatement {
  static CreditStatement skeleton() => CreditStatement(
    outstanding: 1000,
    creditScore: const CreditScore(
      score: 10000,
      outstanding: 1000,
      pending: 0,
      available: 9000,
    ),
    items: List.generate(
      3,
      (i) => CreditItem(
        uid: '$i',
        type: CreditItemType.sale,
        date: _placeholderDate,
        designation: 'Désignation',
        amount: 1000,
        remaining: 1000,
        dueDate: null,
        isOverdue: false,
        documentUrl: '',
        documentName: '',
      ),
    ),
    payments: List.generate(
      2,
      (i) => CreditPayment(
        uid: '$i',
        date: _placeholderDate,
        amount: 500,
        channel: 'Espèces',
      ),
    ),
  );
}

extension CatalogMock on Catalog {
  static Catalog skeleton() => Catalog(
    pricesVisible: true,
    categories: const [ProductCategory(uid: '0', name: 'Catégorie')],
    products: List.generate(
      6,
      (i) => Product(
        uid: '$i',
        name: 'Nom du produit',
        description: '',
        imageUrl: '',
        images: const [],
        categoryUid: '',
        resellerPrice: 100,
        retailPrice: 120,
      ),
    ),
  );
}
