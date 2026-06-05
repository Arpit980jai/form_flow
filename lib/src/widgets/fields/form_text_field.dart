/// A text-style input field (text / email / phone / number) for [FormFlow].
library;

import 'package:flutter/material.dart';

import '../../models/form_schema.dart';
import '../../theme/form_theme.dart';

/// Renders a [TextFormField] for `text`, `email`, `phone` and `number` fields.
///
/// The keyboard type and input behavior adapt to [field.type]. Errors are
/// displayed inline beneath the input via the [errorText] property.
class FormTextField extends StatelessWidget {
  /// The schema describing this field.
  final FormFieldSchema field;

  /// The initial value displayed in the input.
  final String? initialValue;

  /// Called whenever the user edits the text.
  final ValueChanged<String> onChanged;

  /// The current error message, or `null` when the field is valid.
  final String? errorText;

  /// The active form theme used for styling.
  final FormTheme theme;

  /// The resolved locale code (currently used for consistency with siblings).
  final String locale;

  /// Optional message overrides forwarded from [FormFlow].
  final Map<String, String>? customMessages;

  /// Creates a text field widget.
  const FormTextField({
    super.key,
    required this.field,
    required this.onChanged,
    required this.theme,
    required this.locale,
    this.initialValue,
    this.errorText,
    this.customMessages,
  });

  /// Resolves the keyboard type based on the field type and multiline flag.
  TextInputType _keyboardType() {
    switch (field.type) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'number':
        return const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        );
      case 'text':
      default:
        return field.multiline ? TextInputType.multiline : TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final FormFieldTheme? fieldTheme = theme.fieldTheme;
    final bool multiline = field.type == 'text' && field.multiline;

    final InputDecoration baseDecoration =
        fieldTheme?.inputDecoration ?? const InputDecoration();

    final InputDecoration decoration = baseDecoration.copyWith(
      labelText: field.label,
      hintText: field.placeholder,
      hintStyle: fieldTheme?.hintStyle,
      errorText: errorText,
      errorStyle: fieldTheme?.errorStyle,
      border: baseDecoration.border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.borderRadius),
          ),
      enabledBorder: baseDecoration.enabledBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.borderRadius),
          ),
      focusedBorder: baseDecoration.focusedBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.borderRadius),
            borderSide: BorderSide(
              color: theme.primaryColor ?? Theme.of(context).primaryColor,
              width: 2.0,
            ),
          ),
    );

    return TextFormField(
      key: ValueKey<String>('form_flow_text_${field.id}'),
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: _keyboardType(),
      textInputAction:
          multiline ? TextInputAction.newline : TextInputAction.next,
      minLines: multiline ? 3 : 1,
      maxLines: multiline ? null : 1,
      style: fieldTheme?.labelStyle,
      cursorColor: theme.primaryColor,
      decoration: decoration,
    );
  }
}
