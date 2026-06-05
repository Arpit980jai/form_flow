# form_flow_builder

[![pub package](https://img.shields.io/badge/pub-v0.0.2-blue.svg)](https://pub.dev/packages/form_flow_builder)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

A powerful JSON-driven form builder for Flutter with built-in validation, multi-language support, and deep theme customization.

Define your form once as JSON and `form_flow_builder` renders it, validates it, and hands you back the collected values — ideal for **CRM, Survey, HR, and Inspection** apps where forms change often and should not require a redeploy.

<p align="center">
  <img src="https://github.com/Arpit980jai/form_flow/blob/main/assets/FormBuilder.png?raw=true" alt="form_flow demo" width="100%" />
</p>

## ✨ Features

- 🧩 **JSON-driven** — describe an entire form as data, render it at runtime
- ✅ **Built-in validation** — required, min/max length, regex pattern, email & phone formats
- 🌍 **Multi-language** — English, Hindi and Arabic out of the box, plus custom messages
- 🎨 **Deep theming** — colors, spacing, borders, text styles and button styles via `FormTheme`
- 🖼️ **Image uploads** — camera + gallery picking powered by `image_picker`
- 📅 **Date picker** — formatted, read-only date fields
- 🔀 **Rich field set** — text, email, phone, number, dropdown, radio, checkbox (single & group), date, image and section headers
- 🧪 **Pre-fill support** — hydrate forms with initial values
- 🪶 **Lightweight** — only depends on `image_picker` and `intl`

## 🧱 Supported Field Types

| Type             | Description                                              | Value type          |
| ---------------- | -------------------------------------------------------- | ------------------- |
| `text`           | Single or multi-line text (`multiline: true/false`)      | `String`            |
| `email`          | Text input with email format validation                  | `String`            |
| `phone`          | Text input with phone format validation                  | `String`            |
| `number`         | Numeric input                                            | `String`            |
| `dropdown`       | Single-select from `options`                             | `String`            |
| `radio`          | Radio button group from `options`                        | `String`            |
| `checkbox`       | Single checkbox, OR a group when `options` is provided   | `bool` / `List<String>` |
| `date`           | Date picker, formatted as `dd MMM yyyy`                  | `String`            |
| `image`          | Image upload via camera or gallery                       | `String` (file path) |
| `section_header` | Non-input visual divider with title and optional subtitle | _none_             |

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  form_flow_builder: ^0.0.2
```

Then run:

```bash
flutter pub get
```

### Android setup

The `image` field uses `image_picker`. Add the following permissions to `android/app/src/main/AndroidManifest.xml` inside the `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

### iOS setup

Add the following keys to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture photos for forms.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to attach images to forms.</string>
```

## 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:form_flow_builder/form_flow_builder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final schema = FormSchema.fromJson(const {
      'formId': 'employee_onboarding',
      'title': 'Employee Onboarding',
      'locale': 'en',
      'fields': [
        {
          'id': 'full_name',
          'type': 'text',
          'label': 'Full Name',
          'placeholder': 'Enter your full name',
          'required': true,
          'validation': {'minLength': 2, 'maxLength': 100},
        },
        {
          'id': 'email',
          'type': 'email',
          'label': 'Work Email',
          'required': true,
        },
        {
          'id': 'department',
          'type': 'dropdown',
          'label': 'Department',
          'required': true,
          'options': ['Engineering', 'HR', 'Finance', 'Operations'],
        },
        {
          'id': 'agree_terms',
          'type': 'checkbox',
          'label': 'I agree to the terms and conditions',
          'required': true,
        },
      ],
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(schema.title)),
        body: FormFlow(
          schema: schema,
          submitButtonText: 'Submit',
          resetButtonText: 'Reset',
          onSubmit: (FormResult result) {
            debugPrint('Submitted: ${result.toMap()}');
          },
          onChanged: (String id, dynamic value) {
            debugPrint('$id changed to $value');
          },
        ),
      ),
    );
  }
}
```

## 📖 API Reference — `FormFlow`

| Parameter          | Type                                      | Required | Default          | Description                                                        |
| ------------------ | ----------------------------------------- | -------- | ---------------- | ------------------------------------------------------------------ |
| `schema`           | `FormSchema`                              | ✅ Yes   | —                | The form definition to render.                                     |
| `onSubmit`         | `void Function(FormResult result)`        | ✅ Yes   | —                | Called with collected values when the form is valid and submitted. |
| `onChanged`        | `void Function(String fieldId, dynamic)?` | No       | `null`           | Called whenever any field value changes.                           |
| `theme`            | `FormTheme`                               | No       | `const FormTheme()` | Visual customization of fields, spacing and buttons.            |
| `locale`           | `String?`                                 | No       | `null`           | Overrides `schema.locale` for validation messages.                 |
| `submitButtonText` | `String`                                  | No       | `'Submit'`       | Label for the submit button.                                       |
| `resetButtonText`  | `String?`                                 | No       | `null`           | Label for the reset button. When `null`, no reset button is shown. |
| `scrollable`       | `bool`                                    | No       | `true`           | Wraps the form in a `SingleChildScrollView`.                       |
| `customMessages`   | `Map<String, String>?`                    | No       | `null`           | Per-key validation message overrides.                              |
| `initialValues`    | `Map<String, dynamic>?`                   | No       | `null`           | Pre-fills field values by field id.                                |

## 🗂️ JSON Schema Reference

Every possible property is shown and annotated below:

```jsonc
{
  "formId": "employee_onboarding",   // Unique form identifier (String, required)
  "title": "Employee Onboarding",    // Form title (String, required)
  "locale": "en",                    // Default locale: en | hi | ar (String, optional)
  "fields": [                        // Ordered list of fields (required)
    {
      "id": "full_name",             // Unique field id (String, required)
      "type": "text",                // Field type (String, required)
      "label": "Full Name",          // Display label (String, required)
      "placeholder": "Enter name",   // Hint text; subtitle for section_header (String, optional)
      "required": true,              // Whether the field is mandatory (bool, optional, default false)
      "multiline": false,            // For text fields only (bool, optional, default false)
      "options": null,               // Choices for dropdown/radio/checkbox group (List<String>, optional)
      "validation": {                // Validation rules for text-like fields (optional)
        "minLength": 2,              // Minimum characters (int, optional)
        "maxLength": 100,            // Maximum characters (int, optional)
        "pattern": null              // Regex the value must match (String, optional)
      }
    }
  ]
}
```

## 🎨 Theme Customization

```dart
FormFlow(
  schema: schema,
  onSubmit: (result) {},
  theme: const FormTheme(
    primaryColor: Colors.indigo,
    backgroundColor: Colors.white,
    borderRadius: 12.0,
    fieldSpacing: 20.0,
    sectionSpacing: 28.0,
    sectionHeaderStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    sectionSubtitleStyle: TextStyle(
      fontSize: 13,
      color: Colors.grey,
    ),
    fieldTheme: FormFieldTheme(
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
      errorStyle: TextStyle(color: Colors.red),
      hintStyle: TextStyle(color: Colors.grey),
    ),
  ),
);
```

## 🌍 Multi-language Support

Set the locale either in the JSON (`"locale": "hi"`) or via the widget, which takes precedence:

```dart
FormFlow(
  schema: schema,
  onSubmit: (result) {},
  locale: 'ar', // en | hi | ar — overrides schema.locale
);
```

Override individual messages with `customMessages`. Use `{min}` / `{max}` placeholders for length rules:

```dart
FormFlow(
  schema: schema,
  onSubmit: (result) {},
  customMessages: const {
    'required': 'You must fill this in',
    'invalidEmail': 'That email looks wrong',
    'minLength': 'Please enter at least {min} characters',
  },
);
```

Supported message keys: `required`, `fieldRequired`, `minLength`, `maxLength`, `invalidEmail`, `invalidPhone`, `invalidPattern`.

## 🧪 Initial Values

Pre-fill the form by passing a map keyed by field id:

```dart
FormFlow(
  schema: schema,
  onSubmit: (result) {},
  initialValues: const {
    'full_name': 'Jane Doe',
    'department': 'Engineering',
    'agree_terms': true,
    'skills': ['Flutter', 'Python'],   // checkbox group
    'join_date': '01 Jan 2026',         // dd MMM yyyy
  },
);
```

## 🤝 Contributing

Contributions are welcome! To get started:

1. Fork the repository and create a feature branch.
2. Run `flutter pub get` and `flutter test` to make sure everything passes.
3. Follow the existing code style and add tests for new behavior.
4. Open a pull request describing your change.

Please file bugs and feature requests via the issue tracker.

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
