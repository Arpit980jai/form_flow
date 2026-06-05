/// Theme objects used to deeply customize the look of a [FormFlow] form.
library;

import 'package:flutter/material.dart';

/// Styling overrides applied to individual input fields.
class FormFieldTheme {
  /// Base [InputDecoration] applied to text-style fields. Individual fields
  /// merge their label / hint / error on top of this decoration.
  final InputDecoration? inputDecoration;

  /// Text style used for field labels.
  final TextStyle? labelStyle;

  /// Text style used for inline error messages.
  final TextStyle? errorStyle;

  /// Text style used for placeholder / hint text.
  final TextStyle? hintStyle;

  /// Creates a field-level theme.
  const FormFieldTheme({
    this.inputDecoration,
    this.labelStyle,
    this.errorStyle,
    this.hintStyle,
  });
}

/// Top-level theme controlling colors, spacing and styles for a form.
class FormTheme {
  /// Primary accent color used for buttons, selection controls and focus.
  final Color? primaryColor;

  /// Background color of the form container.
  final Color? backgroundColor;

  /// Corner radius applied to inputs, buttons and image containers.
  final double borderRadius;

  /// Vertical spacing inserted between consecutive fields.
  final double fieldSpacing;

  /// Vertical spacing inserted around section headers.
  final double sectionSpacing;

  /// Text style for the bold title of a `section_header` field.
  final TextStyle? sectionHeaderStyle;

  /// Text style for the subtitle of a `section_header` field.
  final TextStyle? sectionSubtitleStyle;

  /// Style applied to the submit button.
  final ButtonStyle? submitButtonStyle;

  /// Style applied to the reset button.
  final ButtonStyle? resetButtonStyle;

  /// Field-level styling overrides.
  final FormFieldTheme? fieldTheme;

  /// Creates a form theme.
  const FormTheme({
    this.primaryColor,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.fieldSpacing = 16.0,
    this.sectionSpacing = 24.0,
    this.sectionHeaderStyle,
    this.sectionSubtitleStyle,
    this.submitButtonStyle,
    this.resetButtonStyle,
    this.fieldTheme,
  });
}
