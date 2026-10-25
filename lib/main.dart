import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local import
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';

void main() {
  runApp(
    ProviderScope(retry: RetryHelper.defaultRetry, child: const MainApp()),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Agrifober Revendeurs',
      theme: theme,
      // Code is in English, everything the revendeur reads is in French.
      locale: const Locale('fr', 'MA'),
      supportedLocales: const [Locale('fr', 'MA'), Locale('fr')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: GoRouterSetup.createRouter(ref),
    );
  }
}
