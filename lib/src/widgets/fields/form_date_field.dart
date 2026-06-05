/// A date picker field for [FormFlow].
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/form_schema.dart';
import '../../theme/form_theme.dart';

/// Renders a read-only [TextFormField] that opens a [showDatePicker] on tap
/// and stores the chosen date formatted as `dd MMM yyyy`.
class FormDateField extends StatefulWidget {
  /// The schema describing this field.
  final FormFieldSchema field;

  /// The initial value as a `dd MMM yyyy` formatted string, if any.
  final String? initialValue;

  /// Called with the formatted date string when a date is selected.
  final ValueChanged<String> onChanged;

  /// The current error message, or `null` when valid.
  final String? errorText;

  /// The active form theme used for styling.
  final FormTheme theme;

  /// The resolved locale code.
  final String locale;

  /// Optional message overrides forwarded from [FormFlow].
  final Map<String, String>? customMessages;

  /// Creates a date field widget.
  const FormDateField({
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
  State<FormDateField> createState() => _FormDateFieldState();
}

class _FormDateFieldState extends State<FormDateField> {
  /// The display format used for selected dates.
  static final DateFormat _formatter = DateFormat('dd MMM yyyy');

  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _controller.text = widget.initialValue!;
      _selectedDate = _tryParse(widget.initialValue!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime? _tryParse(String value) {
    try {
      return _formatter.parse(value);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime initial = _selectedDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year + 100),
      builder: (BuildContext context, Widget? child) {
        final Color primary =
            widget.theme.primaryColor ?? Theme.of(context).primaryColor;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: primary,
                ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      final String formatted = _formatter.format(picked);
      setState(() {
        _selectedDate = picked;
        _controller.text = formatted;
      });
      widget.onChanged(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final FormFieldTheme? fieldTheme = widget.theme.fieldTheme;

    final InputDecoration baseDecoration =
        fieldTheme?.inputDecoration ?? const InputDecoration();

    final InputDecoration decoration = baseDecoration.copyWith(
      labelText: widget.field.label,
      hintText: widget.field.placeholder,
      hintStyle: fieldTheme?.hintStyle,
      errorText: widget.errorText,
      errorStyle: fieldTheme?.errorStyle,
      suffixIcon: const Icon(Icons.calendar_today),
      border: baseDecoration.border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.theme.borderRadius),
          ),
    );

    return TextFormField(
      key: ValueKey<String>('form_flow_date_${widget.field.id}'),
      controller: _controller,
      readOnly: true,
      style: fieldTheme?.labelStyle,
      decoration: decoration,
      onTap: _pickDate,
    );
  }
}
