import 'package:equatable/equatable.dart';

/// The documents a revendeur can download as PDF.
enum DocumentKind { sale, deliveryNote, invoice }

/// A PDF saved on the device, ready to be opened or shared.
class DocumentFile extends Equatable {
  final String path;
  final String fileName;

  const DocumentFile({required this.path, required this.fileName});

  @override
  List<Object?> get props => [path, fileName];
}
