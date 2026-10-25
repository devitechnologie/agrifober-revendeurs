import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/gen/assets.gen.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/auth/presentation/widgets/index.dart';
import 'package:agrifober_resellers/features/auth/presentation/providers/index.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final GlobalKey<State<LoginForm>> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<State<LoginForm>>();
    applySystemUIStyle();
  }

  String? _redirectTarget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirectTarget = GoRouterState.of(context).uri.queryParameters['from'];
  }

  void _onAuthenticated() {
    if (!mounted) return;
    context.go(_redirectTarget ?? Routes.home.route);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.value != null) _onAuthenticated();
    });

    // Pushed from the guest catalogue ("Se connecter"): back returns there.
    // Otherwise login is the root and back asks before leaving the app.
    final pushed = context.canPop();
    final scaffold = Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (pushed)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.sm,
                    top: AppSpacing.xs,
                  ),
                  child: IconButtonUI(
                    backgroundColor: Colors.transparent,
                    onPressed: () => context.pop(),
                    icon: AppIcons.arrowBack,
                    iconSize: AppFontSize.xl + 2,
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      Center(child: Assets.images.brand.logo.image(width: 140)),
                      const SizedBox(height: AppSpacing.lg),
                      _buildHeader(),
                      const SizedBox(height: AppSpacing.lg),
                      LoginForm(key: _formKey),
                      if (!pushed) ...[
                        const SizedBox(height: AppSpacing.base),
                        _buildBrowseLink(),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      const ContactAgrifoberNote(),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
    return pushed ? scaffold : PopScopeWrapper(child: scaffold);
  }

  /// Guest mode: the catalogue without prices. `go`, not `push`: the guest
  /// catalogue becomes the root and its "Se connecter" pushes login back.
  Widget _buildBrowseLink() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ButtonUI(
        onPressed: () => context.go(Routes.browse.route),
        text: 'Voir le catalogue',
        variant: ButtonVariant.outlined,
        icon: AppIcons.boxRR,
        iconSize: AppFontSize.lg,
        textSize: AppFontSize.base,
        minHeight: 50,
      ),
    );
  }

  Widget _buildHeader() {
    return ScreenHeader(
      title: 'Espace revendeurs',
      subtitle: 'Connectez-vous avec votre numéro de téléphone.',
    );
  }

  Widget _buildFooter() {
    final loginState = ref.watch(loginProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.gray)),
      ),
      padding: const EdgeInsets.all(AppSpacing.base),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ButtonUI(
          isLoading: loginState.isLoading,
          onPressed: () {
            (_formKey.currentState as dynamic)?.submit();
          },
          text: 'Se connecter',
        ),
      ),
    );
  }
}
