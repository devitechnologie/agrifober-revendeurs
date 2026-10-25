import 'package:equatable/equatable.dart';

class Pagination<T> extends Equatable {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const Pagination({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  @override
  List<Object> get props => [data, currentPage, lastPage, perPage];

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
}
