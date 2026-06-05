/// The validation engine that turns a [FormFieldSchema] + value into an
/// optional localized error message.
library;

import '../i18n/form_localizations.dart';
import '../models/form_schema.dart';

/// Stateless helper that validates a single field value against its schema.
class FieldValidator {
  FieldValidator._();

  /// Regular expression used to validate email addresses.
  static final RegExp _emailRegExp =
      RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');

  /// Regular expression used to validate phone numbers.
  static final RegExp _phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

  /// Field types that are treated as free-form text for length / pattern
  /// validation purposes.
  static const Set<String> _textLikeTypes = <String>{
    'text',
    'email',
    'phone',
    'number',
  };

  /// Validates [value] for the given [field] using messages in [locale].
  ///
  /// Returns `null` when the value is valid, otherwise a localized error
  /// message string. Optional [customMessages] override the defaults.
  static String? validate(
    FormFieldSchema field,
    dynamic value,
    String locale, {
    Map<String, String>? customMessages,
  }) {
    final bool empty = _isEmpty(value);

    // Required check first.
    if (field.required && empty) {
      return FormLocalizations.getMessage(
        'required',
        locale,
        customMessages: customMessages,
      );
    }

    // Nothing more to validate for an empty, non-required field.
    if (empty) {
      return null;
    }

    // Length / pattern / format checks only apply to text-like fields.
    if (_textLikeTypes.contains(field.type) && value is String) {
      final String text = value;

      final FormFieldValidation? rules = field.validation;
      if (rules != null) {
        if (rules.minLength != null && text.length < rules.minLength!) {
          return FormLocalizations.getMessage(
            'minLength',
            locale,
            customMessages: customMessages,
            params: <String, dynamic>{'min': rules.minLength},
          );
        }
        if (rules.maxLength != null && text.length > rules.maxLength!) {
          return FormLocalizations.getMessage(
            'maxLength',
            locale,
            customMessages: customMessages,
            params: <String, dynamic>{'max': rules.maxLength},
          );
        }
        if (rules.pattern != null && rules.pattern!.isNotEmpty) {
          if (!RegExp(rules.pattern!).hasMatch(text)) {
            return FormLocalizations.getMessage(
              'invalidPattern',
              locale,
              customMessages: customMessages,
            );
          }
        }
      }

      if (field.type == 'email' && !_emailRegExp.hasMatch(text)) {
        return FormLocalizations.getMessage(
          'invalidEmail',
          locale,
          customMessages: customMessages,
        );
      }

      if (field.type == 'phone' && !_phoneRegExp.hasMatch(text)) {
        return FormLocalizations.getMessage(
          'invalidPhone',
          locale,
          customMessages: customMessages,
        );
      }
    }

    return null;
  }

  /// Determines whether [value] should be considered "empty" for the purposes
  /// of the required check. Handles strings, booleans, lists and null.
  static bool _isEmpty(dynamic value) {
    if (value == null) {
      return true;
    }
    if (value is String) {
      return value.trim().isEmpty;
    }
    if (value is bool) {
      return value == false;
    }
    if (value is List) {
      return value.isEmpty;
    }
    if (value is Map) {
      return value.isEmpty;
    }
    return false;
  }
}
