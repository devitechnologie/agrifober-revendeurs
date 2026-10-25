import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/features/auth/domain/domain.dart';
import 'package:agrifober_resellers/features/auth/presentation/providers/index.dart';

/// Phone number + password. The two steps are kept as separate builders so
/// the planned OTP sign-in can swap the password for a code step.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  int _dialCode = defaultPhoneDialCode;

  bool submit() {
    final valid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!valid) return false;

    FocusScope.of(context).unfocus();

    final values = _formKey.currentState!.value;
    final phone = (values['phone'] as String).replaceAll(RegExp(r'\s'), '');
    final password = values['password'] as String;

    ref.read(sessionExpiredProvider.notifier).set(false);
    ref
        .read(loginProvider.notifier)
        .login(
          PhoneNumber(countryCode: '+$_dialCode', number: phone),
          password,
        );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final sessionExpired = ref.watch(sessionExpiredProvider);

    return AutofillGroup(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AlertBannerUI(
              message: 'Votre session a expiré. Veuillez vous reconnecter.',
              type: AlertType.warning,
              spacingBelow: AppSpacing.sm,
              show: sessionExpired && !loginState.hasError,
            ),
            AlertBannerUI(
              message: ErrorHelper.getErrorFromState(loginState),
              type: AlertType.danger,
              spacingBelow: AppSpacing.sm,
              show: loginState.hasError,
            ),
            _buildPhoneStep(),
            SizedBox(height: AppSpacing.base),
            _buildPasswordStep(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelUI('Numéro de téléphone'),
        SizedBox(height: AppSpacing.xs),
        AppFormFieldBuilder<String>(
          name: 'phone',
          validator: (value) {
            final raw = (value ?? '').replaceAll(RegExp(r'\s'), '');
            if (raw.isEmpty) return 'Veuillez entrer votre numéro de téléphone';
            final national = raw.startsWith('0') ? raw.substring(1) : raw;
            final isValid = CountryUtils.validatePhoneNumber(
              national,
              '+$_dialCode',
            );
            return isValid ? null : 'Numéro de téléphone invalide';
          },
          builder: (value, errorText, on) {
            return PhoneFieldUI(
              hintText: 'Par ex : 612345678',
              value: value?.toString() ?? '',
              errorText: errorText,
              onChanged: ({dialCode, required value}) {
                on.changed(value);
                ref.read(loginProvider.notifier).resetError();
                setState(() {
                  _dialCode = dialCode ?? defaultPhoneDialCode;
                });
              },
              onFocus: on.focus,
              onBlur: on.blur,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelUI('Mot de passe'),
        SizedBox(height: AppSpacing.xs),
        AppFormFieldBuilder<String>(
          name: 'password',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
              errorText: 'Veuillez entrer votre mot de passe',
            ),
          ]),
          builder: (value, errorText, on) {
            return TextFieldUI(
              hintText: '•••••••••',
              isPassword: true,
              errorText: errorText,
              autofillHints: [AutofillHints.password],
              onChanged: (value) {
                on.changed(value);
                ref.read(loginProvider.notifier).resetError();
                setState(() {});
              },
              onFocus: on.focus,
              onBlur: on.blur,
              value: value,
            );
          },
        ),
      ],
    );
  }
}
