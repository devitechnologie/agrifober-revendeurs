import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// local imports
import 'package:agrifober_resellers/shared/widgets/ui/index.dart';

typedef FormFieldBuilder<T> =
    Widget Function(T? value, String? errorText, FieldCallbacks<T> on);

class FieldCallbacks<T> {
  final void Function(T) changed;
  final void Function()? focus;
  final void Function()? blur;

  FieldCallbacks({required this.changed, this.focus, this.blur});
}

class AppFormFieldBuilder<T> extends StatelessWidget {
  const AppFormFieldBuilder({
    super.key,
    required this.name,
    this.validator,
    this.hintText,
    this.builder,
    this.initialValue,
    this.keyBoardType,
    this.autofillHints,
  });
  final String name;
  final FormFieldValidator<T>? validator;
  final String? hintText;
  final FormFieldBuilder<T>? builder;
  final T? initialValue;
  final TextInputType? keyBoardType;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      name: name,
      validator: validator,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      builder: (field) {
        final callbacks = FieldCallbacks<T>(
          changed: (value) {
            field.didChange(value);
          },
          focus: () {},
          blur: () {
            field.didChange(field.value);
          },
        );

        if (builder != null) {
          return builder!(field.value, field.errorText, callbacks);
        } else if (hintText != null) {
          return TextFieldUI(
            hintText: hintText!,
            errorText: field.errorText,
            onChanged: callbacks.changed as void Function(String)?,
            onFocus: callbacks.focus,
            onBlur: callbacks.blur,
            value: field.value as String?,
            keyBoardType: keyBoardType,
            autofillHints: autofillHints,
          );
        } else {
          throw ArgumentError('Either builder or hintText must be provided');
        }
      },
    );
  }
}
