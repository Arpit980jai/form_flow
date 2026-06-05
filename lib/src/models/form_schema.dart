/// Data models describing a [FormSchema], its fields and validation rules.
///
/// These models are pure Dart objects with `fromJson` / `toJson` support so
/// that a form can be defined entirely in JSON and rendered at runtime.
library;

/// Validation constraints that can be attached to a [FormFieldSchema].
///
/// All properties are optional (nullable). A `null` value means the
/// corresponding rule is not applied.
class FormFieldValidation {
  /// The minimum number of characters allowed for text-based fields.
  final int? minLength;

  /// The maximum number of characters allowed for text-based fields.
  final int? maxLength;

  /// A regular expression pattern the value must match for text-based fields.
  ///
  /// Stored as a raw string so it can travel through JSON. When `null` no
  /// pattern validation is performed.
  final String? pattern;

  /// Creates a set of validation constraints.
  const FormFieldValidation({
    this.minLength,
    this.maxLength,
    this.pattern,
  });

  /// Builds a [FormFieldValidation] from a decoded JSON [map].
  factory FormFieldValidation.fromJson(Map<String, dynamic> map) {
    return FormFieldValidation(
      minLength: (map['minLength'] as num?)?.toInt(),
      maxLength: (map['maxLength'] as num?)?.toInt(),
      pattern: map['pattern'] as String?,
    );
  }

  /// Serializes this validation block back into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'minLength': minLength,
      'maxLength': maxLength,
      'pattern': pattern,
    };
  }
}

/// Describes a single field within a [FormSchema].
class FormFieldSchema {
  /// Unique identifier for the field. Used as the key in form results.
  final String id;

  /// The field type, e.g. `text`, `email`, `dropdown`, `section_header`.
  final String type;

  /// Human readable label rendered above (or beside) the field.
  final String label;

  /// Optional placeholder / hint text. For `section_header` this is treated
  /// as the subtitle.
  final String? placeholder;

  /// Whether the field must be filled in for the form to be valid.
  final bool required;

  /// Whether a `text` field should accept multiple lines of input.
  final bool multiline;

  /// The list of selectable options for `dropdown`, `radio` and grouped
  /// `checkbox` fields. `null` for fields that do not use options.
  final List<String>? options;

  /// Optional validation constraints applied to this field.
  final FormFieldValidation? validation;

  /// Creates a field schema.
  const FormFieldSchema({
    required this.id,
    required this.type,
    required this.label,
    this.placeholder,
    this.required = false,
    this.multiline = false,
    this.options,
    this.validation,
  });

  /// Builds a [FormFieldSchema] from a decoded JSON [map].
  factory FormFieldSchema.fromJson(Map<String, dynamic> map) {
    final dynamic rawOptions = map['options'];
    return FormFieldSchema(
      id: map['id'] as String,
      type: map['type'] as String,
      label: map['label'] as String,
      placeholder: map['placeholder'] as String?,
      required: map['required'] as bool? ?? false,
      multiline: map['multiline'] as bool? ?? false,
      options: rawOptions is List
          ? rawOptions.map((dynamic e) => e.toString()).toList()
          : null,
      validation: map['validation'] is Map<String, dynamic>
          ? FormFieldValidation.fromJson(
              map['validation'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Serializes this field back into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'label': label,
      'placeholder': placeholder,
      'required': required,
      'multiline': multiline,
      'options': options,
      'validation': validation?.toJson(),
    };
  }
}

/// Top-level schema describing an entire form.
class FormSchema {
  /// Unique identifier for the form.
  final String formId;

  /// The form title, typically rendered at the top of the form.
  final String title;

  /// The default locale code (e.g. `en`, `hi`, `ar`) used for messages.
  final String locale;

  /// The ordered list of fields that make up the form.
  final List<FormFieldSchema> fields;

  /// Creates a form schema.
  const FormSchema({
    required this.formId,
    required this.title,
    this.locale = 'en',
    this.fields = const <FormFieldSchema>[],
  });

  /// Builds a [FormSchema] from a decoded JSON [map].
  factory FormSchema.fromJson(Map<String, dynamic> map) {
    final dynamic rawFields = map['fields'];
    return FormSchema(
      formId: map['formId'] as String,
      title: map['title'] as String,
      locale: map['locale'] as String? ?? 'en',
      fields: rawFields is List
          ? rawFields
              .map((dynamic e) =>
                  FormFieldSchema.fromJson(e as Map<String, dynamic>))
              .toList()
          : const <FormFieldSchema>[],
    );
  }

  /// Serializes this form back into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'formId': formId,
      'title': title,
      'locale': locale,
      'fields': fields.map((FormFieldSchema f) => f.toJson()).toList(),
    };
  }
}
