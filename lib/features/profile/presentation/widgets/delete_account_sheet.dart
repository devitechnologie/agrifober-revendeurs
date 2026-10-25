import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/profile/presentation/providers/index.dart';

/// Opens the account deletion sheet (same flow as bookify-client). The
/// password is asked for again rather than trusted from the session.
Future<void> showDeleteAccountSheet(BuildContext context) {
  final formKey = GlobalKey<DeleteAccountFormState>();

  return showAdaptiveModalSheet<void>(
    context: context,
    builder: (ctx, modalRef) => ModalSheetWrapper(
      modalRef: modalRef,
      title: 'Supprimer mon compte',
      padding: const EdgeInsets.only(top: AppSpacing.base),
      footer: _SheetFooter(formKey: formKey, sheetContext: ctx),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.base,
          0,
          AppSpacing.base,
          AppSpacing.base,
        ),
        child: DeleteAccountForm(key: formKey),
      ),
    ),
  );
}

class DeleteAccountForm extends ConsumerStatefulWidget {
  const DeleteAccountForm({super.key});

  @override
  DeleteAccountFormState createState() => DeleteAccountFormState();
}

class DeleteAccountFormState extends ConsumerState<DeleteAccountForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> submit(BuildContext sheetContext) async {
    final valid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!valid) return;

    FocusScope.of(context).unfocus();

    final failure = await ref
        .read(deleteAccountProvider.notifier)
        .deleteAccount(
          password: _formKey.currentState!.value['password'] as String,
        );

    // A failure stays on screen in the banner below; on success the sheet
    // closes and `LogOutEvent` takes the user back to the login screen.
    if (failure != null || !sheetContext.mounted) return;
    Navigator.of(sheetContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(deleteAccountProvider);

    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AlertBannerUI(
            message:
                'Votre accès à l\'application sera supprimé et vous serez déconnecté de tous vos appareils. '
                'Votre historique (achats, bons, crédits, factures) est conservé par Agrifober pour sa comptabilité.',
            type: AlertType.warning,
            spacingBelow: AppSpacing.base,
          ),
          AlertBannerUI(
            message: ErrorHelper.getErrorFromState(state),
            type: AlertType.danger,
            spacingBelow: AppSpacing.sm,
            show: state.hasError,
          ),
          AppFormFieldBuilder<String>(
            name: 'password',
            validator: FormBuilderValidators.required(
              errorText: 'Mot de passe requis',
            ),
            builder: (value, errorText, on) => LabeledFieldUI(
              label: 'Confirmez avec votre mot de passe',
              child: TextFieldUI(
                hintText: '•••••••••',
                isPassword: true,
                errorText: errorText,
                value: value,
                onChanged: on.changed,
                onFocus: on.focus,
                onBlur: on.blur,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFooter extends ConsumerWidget {
  const _SheetFooter({required this.formKey, required this.sheetContext});

  final GlobalKey<DeleteAccountFormState> formKey;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.gray)),
      ),
      padding: const EdgeInsets.all(AppSpacing.base),
      child: SafeArea(
        top: false,
        child: ButtonUI(
          text: 'Supprimer mon compte',
          backgroundColor: AppColors.danger,
          isLoading: ref.watch(deleteAccountProvider).isLoading,
          onPressed: () => formKey.currentState?.submit(sheetContext),
        ),
      ),
    );
  }
}
