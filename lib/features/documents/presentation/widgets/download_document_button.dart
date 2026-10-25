import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/documents/domain/domain.dart';

/// "Télécharger le PDF": downloads the document, then opens the system share
/// sheet so the revendeur can open, save or send it.
class DownloadDocumentButton extends ConsumerStatefulWidget {
  const DownloadDocumentButton({
    super.key,
    required this.kind,
    required this.uid,
  });

  final DocumentKind kind;
  final String uid;

  @override
  ConsumerState<DownloadDocumentButton> createState() =>
      _DownloadDocumentButtonState();
}

class _DownloadDocumentButtonState
    extends ConsumerState<DownloadDocumentButton> {
  bool _isLoading = false;

  Future<void> _download() async {
    setState(() => _isLoading = true);
    final result = await ref.read(downloadDocumentUseCaseProvider)(
      widget.kind,
      widget.uid,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    await result.when(
      success: (file) async {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path, mimeType: 'application/pdf')],
            subject: file.fileName,
          ),
        );
      },
      failure: (error) async {
        NotificationService.showError(context, error.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonUI(
      onPressed: _download,
      isLoading: _isLoading,
      text: 'Télécharger le PDF',
      variant: ButtonVariant.outlined,
      icon: AppIcons.downloadRR,
      textSize: AppFontSize.base,
    );
  }
}
