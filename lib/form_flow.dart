/// form_flow
///
/// A powerful JSON-driven form builder for Flutter with built-in validation,
/// multi-language support, and deep theme customization.
///
/// Import this single file to access every public API of the package:
///
/// ```dart
/// import 'package:form_flow/form_flow.dart';
/// ```
library form_flow;

// Models
export 'src/models/form_schema.dart';
export 'src/models/form_result.dart';

// Internationalization
export 'src/i18n/form_localizations.dart';

// Theme
export 'src/theme/form_theme.dart';

// Validation
export 'src/validators/field_validator.dart';

// Field widgets
export 'src/widgets/fields/form_text_field.dart';
export 'src/widgets/fields/form_dropdown_field.dart';
export 'src/widgets/fields/form_radio_field.dart';
export 'src/widgets/fields/form_checkbox_field.dart';
export 'src/widgets/fields/form_date_field.dart';
export 'src/widgets/fields/form_image_field.dart';
export 'src/widgets/fields/form_section_header.dart';

// Main widget
export 'src/widgets/form_builder_widget.dart';
