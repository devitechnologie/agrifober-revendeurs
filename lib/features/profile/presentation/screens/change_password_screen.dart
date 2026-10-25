import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/profile/presentation/providers/index.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> submit() async {
    final valid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!valid) return;

    FocusScope.of(context).unfocus();
    final values = _formKey.currentState!.value;

    final failure = await ref
        .read(changePasswordProvider.notifier)
        .changePassword(
          currentPassword: values['currentPassword'] as String,
          newPassword: values['password'] as String,
        );

    if (!mounted) return;
    if (failure != null) {
      NotificationService.showError(
        context,
        ErrorHelper.getErrorMessage(failure),
      );
      return;
    }

    NotificationService.showSuccess(
      context,
      'Mot de passe modifié. Vos autres appareils ont été déconnectés.',
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: MainAppBar(title: 'Modifier mot de passe'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.base,
                  children: [
                    _buildCurrentPasswordField(),
                    _buildPasswordField(),
                    _buildConfirmationField(),
                  ],
                ),
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildCurrentPasswordField() {
    return LabeledFieldUI(
      label: 'Mot de passe actuel',
      child: AppFormFieldBuilder<String>(
        name: 'currentPassword',
        validator: FormBuilderValidators.required(
          errorText: 'Veuillez entrer votre mot de passe actuel',
        ),
        builder: (value, errorText, on) => _passwordField(value, errorText, on),
      ),
    );
  }

  Widget _buildPasswordField() {
    return LabeledFieldUI(
      label: 'Nouveau mot de passe',
      child: AppFormFieldBuilder<String>(
        name: 'password',
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
            errorText: 'Veuillez entrer un nouveau mot de passe',
          ),
          // Same minimum as the server (and the admin password form).
          FormBuilderValidators.minLength(
            6,
            errorText: 'Le mot de passe doit contenir au moins 6 caractères',
          ),
          (value) {
            final current =
                _formKey.currentState?.fields['currentPassword']?.value;
            return value == current
                ? 'Le nouveau mot de passe doit être différent de l\'actuel'
                : null;
          },
        ]),
        builder: (value, errorText, on) => _passwordField(value, errorText, on),
      ),
    );
  }

  Widget _buildConfirmationField() {
    return LabeledFieldUI(
      label: 'Confirmer le mot de passe',
      child: AppFormFieldBuilder<String>(
        name: 'passwordConfirmation',
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
            errorText: 'Veuillez confirmer votre mot de passe',
          ),
          (value) {
            final password = _formKey.currentState?.fields['password']?.value;
            return value == password
                ? null
                : 'Les mots de passe ne correspondent pas';
          },
        ]),
        builder: (value, errorText, on) => _passwordField(value, errorText, on),
      ),
    );
  }

  Widget _passwordField(
    String? value,
    String? errorText,
    FieldCallbacks<String> on,
  ) {
    return TextFieldUI(
      hintText: '•••••••••',
      isPassword: true,
      errorText: errorText,
      value: value,
      onChanged: on.changed,
      onFocus: on.focus,
      onBlur: on.blur,
    );
  }

  Widget _buildFooter() {
    final state = ref.watch(changePasswordProvider);

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.gray)),
        ),
        padding: const EdgeInsets.all(AppSpacing.base),
        child: ButtonUI(
          text: 'Sauvegarder',
          isLoading: state.isLoading,
          onPressed: () {
            submit();
          },
        ),
      ),
    );
  }
}
