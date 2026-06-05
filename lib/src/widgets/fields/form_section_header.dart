/// A non-input visual section header for [FormFlow].
library;

import 'package:flutter/material.dart';

import '../../models/form_schema.dart';
import '../../theme/form_theme.dart';

/// Renders a bold title (from [field.label]) and an optional subtitle (from
/// [field.placeholder]) followed by a divider line.
class FormSectionHeader extends StatelessWidget {
  /// The schema describing this section header.
  final FormFieldSchema field;

  /// The active form theme used for styling.
  final FormTheme theme;

  /// Creates a section header widget.
  const FormSectionHeader({
    super.key,
    required this.field,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = theme.sectionHeaderStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ) ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    final TextStyle subtitleStyle = theme.sectionSubtitleStyle ??
        Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ) ??
        TextStyle(fontSize: 13, color: Colors.grey.shade600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(field.label, style: titleStyle),
        if (field.placeholder != null && field.placeholder!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(field.placeholder!, style: subtitleStyle),
          ),
        const SizedBox(height: 8.0),
        Divider(
          thickness: 1.0,
          color: theme.primaryColor?.withValues(alpha: 0.4) ??
              Colors.grey.shade300,
        ),
      ],
    );
  }
}
