/// A single-select radio button group field for [FormFlow].
library;

import 'package:flutter/material.dart';

import '../../models/form_schema.dart';
import '../../theme/form_theme.dart';

/// Renders a column of [RadioListTile]s from [field.options].
class FormRadioField extends StatefulWidget {
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

  /// Creates a radio group field widget.
  const FormRadioField({
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
  State<FormRadioField> createState() => _FormRadioFieldState();
}

class _FormRadioFieldState extends State<FormRadioField> {
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
    final Color activeColor =
        widget.theme.primaryColor ?? Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            widget.field.label,
            style: fieldTheme?.labelStyle ??
                Theme.of(context).textTheme.titleSmall,
          ),
        ),
        RadioGroup<String>(
          groupValue: _selected,
          onChanged: (String? value) {
            setState(() => _selected = value);
            widget.onChanged(value);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...options.map(
                (String option) => RadioListTile<String>(
                  key: ValueKey<String>(
                      'form_flow_radio_${widget.field.id}_$option'),
                  title: Text(option),
                  value: option,
                  activeColor: activeColor,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              widget.errorText!,
              style: fieldTheme?.errorStyle ??
                  TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12.0,
                  ),
            ),
          ),
      ],
    );
  }
}
