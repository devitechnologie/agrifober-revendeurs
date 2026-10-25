import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/index.dart';

class ModalRef {
  ModalRef({required this.modalView, required this.isDismissible});

  final bool modalView;
  final bool isDismissible;
}

Future<T?> showAdaptiveModalSheet<T>({
  required BuildContext context,
  required ModalSheetWrapper Function(BuildContext, ModalRef) builder,
  bool isScrollControlled = true,
  bool isDismissible = true,
  Color? barrierColor,
  bool modalView = false,
  bool enableDrag = true,
}) {
  if (modalView) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return builder(
          context,
          ModalRef(modalView: modalView, isDismissible: isDismissible),
        );
      },
    );
  } else {
    return showModalBottomSheet<T>(
      context: context,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      barrierColor: barrierColor,
      useRootNavigator: true,
      builder: (context) {
        return builder(
          context,
          ModalRef(modalView: modalView, isDismissible: isDismissible),
        );
      },
    );
  }
}

class ModalSheetWrapper extends StatelessWidget {
  const ModalSheetWrapper({
    super.key,
    required this.child,
    this.height,
    this.fullScreenSheet = false, // this applies only for sheets
    this.title,
    this.useKeyboardPadding = true,
    this.actions,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.base),
    required this.modalRef,
    this.footer,
    this.radius = AppRadius.tiny,
  });

  final Widget child;
  final double? height;
  final bool fullScreenSheet;
  final String? title;
  final bool useKeyboardPadding;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;
  final ModalRef modalRef;
  final Widget? footer;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final modalView = modalRef.modalView;
    if (modalView) {
      return _buildWebModal(context);
    } else {
      return _buildMobileSheet(context);
    }
  }

  Widget _buildWebModal(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.lg),
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minWidth: 400,
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: height == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null)
                        SheetHeader(
                          title: title!,
                          actions: actions,
                          modalRef: modalRef,
                        ),
                      Flexible(child: SingleChildScrollView(child: child)),
                      ?footer,
                    ],
                  )
                : Column(
                    children: [
                      if (title != null)
                        SheetHeader(
                          title: title!,
                          actions: actions,
                          modalRef: modalRef,
                        ),
                      Expanded(child: SingleChildScrollView(child: child)),
                      ?footer,
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileSheet(BuildContext context) {
    return Container(
      padding: useKeyboardPadding
          ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
          : null,
      constraints: BoxConstraints(
        maxHeight: fullScreenSheet
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * 0.9, // Limit max height
      ),
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
        ),
        width: double.infinity,
        child: height == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    SheetHeader(
                      title: title!,
                      actions: actions,
                      modalRef: modalRef,
                    ),
                  Flexible(child: SingleChildScrollView(child: child)),
                  ?footer,
                ],
              )
            : Column(
                children: [
                  if (title != null)
                    SheetHeader(
                      title: title!,
                      actions: actions,
                      modalRef: modalRef,
                    ),
                  Expanded(child: SingleChildScrollView(child: child)),
                  ?footer,
                ],
              ),
      ),
    );
  }
}

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    super.key,
    required this.title,
    this.actions,
    required this.modalRef,
  });

  final String title;
  final List<Widget>? actions;
  final ModalRef modalRef;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  (actions != null && actions!.isNotEmpty)
                      ? Row(children: actions!)
                      : const SizedBox.shrink(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppFontSize.lg,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              modalRef.isDismissible
                  ? IconButtonUI(
                      icon: AppIcons.closeRR,
                      iconSize: AppFontSize.xxl - 2,
                      padding: const EdgeInsets.all(AppSpacing.xxs),
                      color: AppColors.black,
                      backgroundColor: AppColors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
      ],
    );
  }
}
