/// A single-select dropdown field for [FormFlow].
library;

import 'package:flutter/material.dart';

import '../../models/form_schema.dart';
import '../../theme/form_theme.dart';

/// Renders a [DropdownButtonFormField] populated from [field.options].
class FormDropdownField extends StatefulWidget {
  /// The schema describing this field.
  final FormFieldSchema field;

  /// The initially selected option, if any.
  final String? initialValue;

  /// Called when the selection changes.
  final ValueChanged<String?> onChanged;

  /// The current error message, or `null` when valid.
  final String? errorText;

  /// The active form theme used for styling.
  final FormTheme theme;

  /// The resolved locale code.
  final String locale;

  /// Optional message overrides forwarded from [FormFlow].
  final Map<String, String>? customMessages;

  /// Creates a dropdown field widget.
  const FormDropdownField({
    super.key,
    required this.field,
    required this.onChanged,
    required this.theme,
    required this.locale,
    this.initialValue,
    this.errorText,
    this.customMessages,
  });

  @override
  State<FormDropdownField> createState() => _FormDropdownFieldState();
}

class _FormDropdownFieldState extends State<FormDropdownField> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final FormFieldTheme? fieldTheme = widget.theme.fieldTheme;
    final List<String> options = widget.field.options ?? const <String>[];

    final InputDecoration baseDecoration =
        fieldTheme?.inputDecoration ?? const InputDecoration();

    final InputDecoration decoration = baseDecoration.copyWith(
      labelText: widget.field.label,
      hintText: widget.field.placeholder,
      hintStyle: fieldTheme?.hintStyle,
      errorText: widget.errorText,
      errorStyle: fieldTheme?.errorStyle,
      border: baseDecoration.border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.theme.borderRadius),
          ),
    );

    return DropdownButtonFormField<String>(
      key: ValueKey<String>('form_flow_dropdown_${widget.field.id}'),
      initialValue:
          options.contains(_selected) ? _selected : null,
      isExpanded: true,
      decoration: decoration,
      hint: widget.field.placeholder != null
          ? Text(widget.field.placeholder!)
          : null,
      items: options
          .map(
            (String option) => DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            ),
          )
          .toList(),
      onChanged: (String? value) {
        setState(() => _selected = value);
        widget.onChanged(value);
      },
    );
  }
}
