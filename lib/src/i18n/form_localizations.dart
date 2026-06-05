/// Localized validation and UI messages for the form_flow package.
library;

/// Provides localized messages for form validation across supported locales.
///
/// Supported locales: `en` (English), `hi` (Hindi), `ar` (Arabic).
///
/// Messages can be overridden per-key via the `customMessages` argument, and
/// numeric parameters (such as the minimum length) are injected through
/// `params` using `{key}` placeholders.
class FormLocalizations {
  FormLocalizations._();

  /// The default locale used when a requested locale is not available.
  static const String fallbackLocale = 'en';

  /// Built-in messages indexed by `locale -> key -> template`.
  static const Map<String, Map<String, String>> _messages =
      <String, Map<String, String>>{
    'en': <String, String>{
      'required': 'This field is required',
      'fieldRequired': 'This field is required',
      'minLength': 'Must be at least {min} characters',
      'maxLength': 'Must be at most {max} characters',
      'invalidEmail': 'Please enter a valid email address',
      'invalidPhone': 'Please enter a valid phone number',
      'invalidPattern': 'The value does not match the required format',
    },
    'hi': <String, String>{
      'required': 'यह फ़ील्ड आवश्यक है',
      'fieldRequired': 'यह फ़ील्ड आवश्यक है',
      'minLength': 'कम से कम {min} अक्षर होने चाहिए',
      'maxLength': 'अधिकतम {max} अक्षर होने चाहिए',
      'invalidEmail': 'कृपया एक मान्य ईमेल पता दर्ज करें',
      'invalidPhone': 'कृपया एक मान्य फ़ोन नंबर दर्ज करें',
      'invalidPattern': 'मान आवश्यक प्रारूप से मेल नहीं खाता',
    },
    'ar': <String, String>{
      'required': 'هذا الحقل مطلوب',
      'fieldRequired': 'هذا الحقل مطلوب',
      'minLength': 'يجب أن يكون {min} أحرف على الأقل',
      'maxLength': 'يجب ألا يزيد عن {max} حرفًا',
      'invalidEmail': 'الرجاء إدخال عنوان بريد إلكتروني صالح',
      'invalidPhone': 'الرجاء إدخال رقم هاتف صالح',
      'invalidPattern': 'القيمة لا تطابق التنسيق المطلوب',
    },
  };

  /// Resolves a localized message for [key] in the given [locale].
  ///
  /// - If [customMessages] contains [key], that value is used (after parameter
  ///   substitution) regardless of locale.
  /// - If [locale] is not supported, falls back to [fallbackLocale].
  /// - If the [key] is unknown for the resolved locale, the [key] itself is
  ///   returned so the caller always receives a non-null string.
  /// - Any `{name}` placeholders are replaced with the matching entry from
  ///   [params].
  static String getMessage(
    String key,
    String locale, {
    Map<String, String>? customMessages,
    Map<String, dynamic>? params,
  }) {
    String template;

    if (customMessages != null && customMessages.containsKey(key)) {
      template = customMessages[key]!;
    } else {
      final Map<String, String> table =
          _messages[locale] ?? _messages[fallbackLocale]!;
      template = table[key] ?? _messages[fallbackLocale]![key] ?? key;
    }

    if (params != null) {
      params.forEach((String name, dynamic value) {
        template = template.replaceAll('{$name}', '$value');
      });
    }

    return template;
  }
}
