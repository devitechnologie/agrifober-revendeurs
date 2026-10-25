import 'dart:io';

import 'package:agrifober_resellers/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// local imports

class PopScopeWrapper extends StatefulWidget {
  final Widget child;
  final bool preventClose;

  const PopScopeWrapper({
    super.key,
    required this.child,
    this.preventClose = false,
  });

  @override
  State<PopScopeWrapper> createState() => _PopScopeWrapperState();
}

class _PopScopeWrapperState extends State<PopScopeWrapper> {
  Future<void> _onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (didPop) return;

    if (widget.preventClose) return;

    final shouldExit = await Helpers.handleDoubleTapExit();

    if (!shouldExit) {
      NotificationService.showInfo(
        context,
        "Appuyez de nouveau pour quitter l'application",
      );
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: widget.child,
    );
  }
}
