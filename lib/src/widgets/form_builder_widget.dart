/// The public [FormFlow] widget that renders a [FormSchema] as a live form.
library;

import 'package:flutter/material.dart';

import '../models/form_result.dart';
import '../models/form_schema.dart';
import '../theme/form_theme.dart';
import '../validators/field_validator.dart';
import 'fields/form_checkbox_field.dart';
import 'fields/form_date_field.dart';
import 'fields/form_dropdown_field.dart';
import 'fields/form_image_field.dart';
import 'fields/form_radio_field.dart';
import 'fields/form_section_header.dart';
import 'fields/form_text_field.dart';

/// A JSON-driven form widget.
///
/// Pass a [FormSchema] (usually decoded from JSON) and [FormFlow] will render
/// every field, run validation on submit, and hand the collected values back
/// through [onSubmit] as a [FormResult].
class FormFlow extends StatefulWidget {
  /// The schema describing the form to render.
  final FormSchema schema;

  /// Called with the collected [FormResult] when the form is valid and
  /// submitted.
  final void Function(FormResult result) onSubmit;

  /// Called whenever any field value changes, with its id and new value.
  final void Function(String fieldId, dynamic value)? onChanged;

  /// The theme used to style the form. Defaults to [FormTheme].
  final FormTheme theme;

  /// When provided, overrides [FormSchema.locale] for message resolution.
  final String? locale;

  /// The label for the submit button.
  final String submitButtonText;

  /// The label for the reset button. When `null`, no reset button is shown.
  final String? resetButtonText;

  /// Whether the form should be wrapped in a scroll view.
  final bool scrollable;

  /// Optional per-key validation message overrides.
  final Map<String, String>? customMessages;

  /// Optional initial values keyed by field id used to pre-fill the form.
  final Map<String, dynamic>? initialValues;

  /// Creates a [FormFlow] widget.
  const FormFlow({
    super.key,
    required this.schema,
    required this.onSubmit,
    this.onChanged,
    this.theme = const FormTheme(),
    this.locale,
    this.submitButtonText = 'Submit',
    this.resetButtonText,
    this.scrollable = true,
    this.customMessages,
    this.initialValues,
  });

  @override
  State<FormFlow> createState() => _FormFlowState();
}

class _FormFlowState extends State<FormFlow> {
  /// Current value of every field, keyed by field id.
  final Map<String, dynamic> _values = <String, dynamic>{};

  /// Current error message of every field, keyed by field id.
  final Map<String, String?> _errors = <String, String?>{};

  /// The resolved locale used for validation messages.
  late String _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.locale ?? widget.schema.locale;
    if (widget.initialValues != null) {
      _values.addAll(widget.initialValues!);
    }
  }

  /// Whether the given field type produces a collectable value.
  bool _isInputType(String type) => type != 'section_header';

  /// Runs validation over every input field, updates [_errors] and returns
  /// whether the entire form is valid.
  bool _validate() {
    final Map<String, String?> next = <String, String?>{};
    bool isValid = true;

    for (final FormFieldSchema field in widget.schema.fields) {
      if (!_isInputType(field.type)) {
        continue;
      }
      final String? error = FieldValidator.validate(
        field,
        _values[field.id],
        _locale,
        customMessages: widget.customMessages,
      );
      next[field.id] = error;
      if (error != null) {
        isValid = false;
      }
    }

    setState(() {
      _errors
        ..clear()
        ..addAll(next);
    });
    return isValid;
  }

  /// Updates a field value, clears its error and notifies listeners.
  void _onFieldChanged(String fieldId, dynamic value) {
    setState(() {
      _values[fieldId] = value;
      _errors[fieldId] = null;
    });
    widget.onChanged?.call(fieldId, value);
  }

  /// Validates and, when valid, emits the [FormResult] through [onSubmit].
  void _onSubmit() {
    if (_validate()) {
      widget.onSubmit(FormResult(Map<String, dynamic>.from(_values)));
    }
  }

  /// Clears all values and errors, resetting the form.
  void _onReset() {
    setState(() {
      _values.clear();
      _errors.clear();
    });
  }

  /// Builds the widget for a single field based on its type.
  Widget _buildField(FormFieldSchema field) {
    final String? error = _errors[field.id];
    final dynamic initial = _values[field.id];

    switch (field.type) {
      case 'text':
      case 'email':
      case 'phone':
      case 'number':
        return FormTextField(
          field: field,
          initialValue: initial is String ? initial : null,
          errorText: error,
          theme: widget.theme,
          locale: _locale,
          customMessages: widget.customMessages,
          onChanged: (String value) => _onFieldChanged(field.id, value),
        );
      case 'dropdown':
        return FormDropdownField(
          field: field,
          initialValue: initial is String ? initial : null,
          errorText: error,
          theme: widget.theme,
          locale: _locale,
          customMessages: widget.customMessages,
          onChanged: (String? value) => _onFieldChanged(field.id, value),
        );
      case 'radio':
        return FormRadioField(
          field: field,
          initialValue: initial is String ? initial : null,
          errorText: error,
          theme: widget.theme,
          locale: _locale,
          customMessages: widget.customMessages,
          onChanged: (String? value) => _onFieldChanged(field.id, value),
        );
      case 'checkbox':
        return FormCheckboxField(
          field: field,
          initialValue: initial,
          errorText: error,
          theme: widget.theme,
          locale: _locale,
          customMessages: widget.customMessages,
          onChanged: (dynamic value) => _onFieldChanged(field.id, value),
        );
      case 'date':
        return FormDateField(
          field: field,
          initialValue: initial is String ? initial : null,
          errorText: error,
          theme: widget.theme,
          locale: _locale,
          customMessages: widget.customMessages,
          onChanged: (String value) => _onFieldChanged(field.id, value),
        );
      case 'image':
        return FormImageField(
          field: field,
          imagePath: initial is String ? initial : null,
          errorText: error,
          theme: widget.theme,
          locale: _locale,
          customMessages: widget.customMessages,
          onChanged: (String? value) => _onFieldChanged(field.id, value),
        );
      case 'section_header':
        return FormSectionHeader(field: field, theme: widget.theme);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < widget.schema.fields.length; i++) {
      final FormFieldSchema field = widget.schema.fields[i];
      if (i > 0) {
        final double spacing = field.type == 'section_header'
            ? widget.theme.sectionSpacing
            : widget.theme.fieldSpacing;
        children.add(SizedBox(height: spacing));
      }
      children.add(_buildField(field));
    }

    // Action buttons.
    children.add(SizedBox(height: widget.theme.sectionSpacing));
    children.add(_buildActions(context));

    final Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    final Widget body = Container(
      color: widget.theme.backgroundColor,
      padding: const EdgeInsets.all(16.0),
      child: column,
    );

    if (widget.scrollable) {
      return SingleChildScrollView(child: body);
    }
    return body;
  }

  Widget _buildActions(BuildContext context) {
    final Color primary =
        widget.theme.primaryColor ?? Theme.of(context).primaryColor;

    final Widget submitButton = ElevatedButton(
      style: widget.theme.submitButtonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.theme.borderRadius),
            ),
          ),
      onPressed: _onSubmit,
      child: Text(widget.submitButtonText),
    );

    if (widget.resetButtonText == null) {
      return submitButton;
    }

    final Widget resetButton = OutlinedButton(
      style: widget.theme.resetButtonStyle ??
          OutlinedButton.styleFrom(
            foregroundColor: primary,
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            side: BorderSide(color: primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.theme.borderRadius),
            ),
          ),
      onPressed: _onReset,
      child: Text(widget.resetButtonText!),
    );

    return Row(
      children: <Widget>[
        Expanded(child: resetButton),
        const SizedBox(width: 12.0),
        Expanded(child: submitButton),
      ],
    );
  }
}
