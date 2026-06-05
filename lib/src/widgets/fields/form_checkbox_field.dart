/// A checkbox field for [FormFlow] — single boolean or a group of options.
library;

import 'package:flutter/material.dart';

import '../../models/form_schema.dart';
import '../../theme/form_theme.dart';

/// Renders either a single [CheckboxListTile] (boolean value) or a group of
/// checkboxes (list of selected option strings) depending on whether
/// [field.options] is provided.
class FormCheckboxField extends StatefulWidget {
  /// The schema describing this field.
  final FormFieldSchema field;

  /// The initial value: a `bool` for a single checkbox, or a `List<String>`
  /// of selected options for a checkbox group.
  final dynamic initialValue;

  /// Called when the value changes. Emits a `bool` for a single checkbox or a
  /// `List<String>` for a group.
  final ValueChanged<dynamic> onChanged;

  /// The current error message, or `null` when valid.
  final String? errorText;

  /// The active form theme used for styling.
  final FormTheme theme;

  /// The resolved locale code.
  final String locale;

  /// Optional message overrides forwarded from [FormFlow].
  final Map<String, String>? customMessages;

  /// Creates a checkbox field widget.
  const FormCheckboxField({
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
  State<FormCheckboxField> createState() => _FormCheckboxFieldState();
}

class _FormCheckboxFieldState extends State<FormCheckboxField> {
  bool _single = false;
  late List<String> _selected;

  bool get _isGroup =>
      widget.field.options != null && widget.field.options!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_isGroup) {
      final dynamic initial = widget.initialValue;
      _selected = initial is List
          ? initial.map((dynamic e) => e.toString()).toList()
          : <String>[];
    } else {
      _selected = <String>[];
      _single = widget.initialValue == true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final FormFieldTheme? fieldTheme = widget.theme.fieldTheme;
    final Color activeColor =
        widget.theme.primaryColor ?? Theme.of(context).primaryColor;

    final Widget content = _isGroup
        ? _buildGroup(context, activeColor, fieldTheme)
        : _buildSingle(context, activeColor, fieldTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        content,
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

  Widget _buildSingle(
    BuildContext context,
    Color activeColor,
    FormFieldTheme? fieldTheme,
  ) {
    return CheckboxListTile(
      key: ValueKey<String>('form_flow_checkbox_${widget.field.id}'),
      title: Text(
        widget.field.label,
        style: fieldTheme?.labelStyle,
      ),
      value: _single,
      activeColor: activeColor,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      onChanged: (bool? value) {
        setState(() => _single = value ?? false);
        widget.onChanged(_single);
      },
    );
  }

  Widget _buildGroup(
    BuildContext context,
    Color activeColor,
    FormFieldTheme? fieldTheme,
  ) {
    final List<String> options = widget.field.options ?? const <String>[];
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
        ...options.map(
          (String option) => CheckboxListTile(
            key: ValueKey<String>(
                'form_flow_checkbox_${widget.field.id}_$option'),
            title: Text(option),
            value: _selected.contains(option),
            activeColor: activeColor,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            onChanged: (bool? checked) {
              setState(() {
                if (checked == true) {
                  if (!_selected.contains(option)) {
                    _selected.add(option);
                  }
                } else {
                  _selected.remove(option);
                }
              });
              widget.onChanged(List<String>.from(_selected));
            },
          ),
        ),
      ],
    );
  }
}
