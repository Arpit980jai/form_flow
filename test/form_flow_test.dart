import 'package:flutter_test/flutter_test.dart';

import 'package:form_flow/form_flow.dart';

void main() {
  group('FormSchema', () {
    final Map<String, dynamic> json = <String, dynamic>{
      'formId': 'employee_onboarding',
      'title': 'Employee Onboarding',
      'locale': 'en',
      'fields': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'full_name',
          'type': 'text',
          'label': 'Full Name',
          'placeholder': 'Enter your full name',
          'required': true,
          'multiline': false,
          'validation': <String, dynamic>{
            'minLength': 2,
            'maxLength': 100,
            'pattern': null,
          },
        },
        <String, dynamic>{
          'id': 'department',
          'type': 'dropdown',
          'label': 'Department',
          'required': true,
          'options': <String>['Engineering', 'HR', 'Finance', 'Operations'],
        },
      ],
    };

    test('fromJson parses formId, title, locale correctly', () {
      final FormSchema schema = FormSchema.fromJson(json);
      expect(schema.formId, 'employee_onboarding');
      expect(schema.title, 'Employee Onboarding');
      expect(schema.locale, 'en');
    });

    test('fromJson parses fields list with correct count', () {
      final FormSchema schema = FormSchema.fromJson(json);
      expect(schema.fields.length, 2);
    });

    test('fromJson parses field type correctly', () {
      final FormSchema schema = FormSchema.fromJson(json);
      expect(schema.fields.first.type, 'text');
      expect(schema.fields.last.type, 'dropdown');
    });

    test('fromJson parses options list for dropdown', () {
      final FormSchema schema = FormSchema.fromJson(json);
      expect(schema.fields.last.options,
          <String>['Engineering', 'HR', 'Finance', 'Operations']);
    });

    test('fromJson parses validation minLength and maxLength', () {
      final FormSchema schema = FormSchema.fromJson(json);
      final FormFieldValidation? v = schema.fields.first.validation;
      expect(v, isNotNull);
      expect(v!.minLength, 2);
      expect(v.maxLength, 100);
    });

    test('toJson round-trips correctly', () {
      final FormSchema schema = FormSchema.fromJson(json);
      final FormSchema reparsed = FormSchema.fromJson(schema.toJson());
      expect(reparsed.formId, schema.formId);
      expect(reparsed.title, schema.title);
      expect(reparsed.locale, schema.locale);
      expect(reparsed.fields.length, schema.fields.length);
      expect(reparsed.fields.first.id, schema.fields.first.id);
      expect(reparsed.fields.first.validation!.minLength,
          schema.fields.first.validation!.minLength);
      expect(reparsed.fields.last.options, schema.fields.last.options);
    });
  });

  group('FieldValidator', () {
    const FormFieldSchema requiredText = FormFieldSchema(
      id: 'name',
      type: 'text',
      label: 'Name',
      required: true,
    );

    const FormFieldSchema requiredCheckbox = FormFieldSchema(
      id: 'agree',
      type: 'checkbox',
      label: 'Agree',
      required: true,
    );

    const FormFieldSchema lengthText = FormFieldSchema(
      id: 'bio',
      type: 'text',
      label: 'Bio',
      validation: FormFieldValidation(minLength: 3, maxLength: 5),
    );

    const FormFieldSchema emailField = FormFieldSchema(
      id: 'email',
      type: 'email',
      label: 'Email',
      required: true,
    );

    const FormFieldSchema phoneField = FormFieldSchema(
      id: 'phone',
      type: 'phone',
      label: 'Phone',
      required: true,
    );

    const FormFieldSchema patternField = FormFieldSchema(
      id: 'code',
      type: 'text',
      label: 'Code',
      validation: FormFieldValidation(pattern: r'^[A-Z]{3}$'),
    );

    const FormFieldSchema optionalText = FormFieldSchema(
      id: 'note',
      type: 'text',
      label: 'Note',
    );

    test('required text field empty returns error', () {
      expect(FieldValidator.validate(requiredText, '', 'en'), isNotNull);
    });

    test('required text field with value returns null', () {
      expect(FieldValidator.validate(requiredText, 'Alice', 'en'), isNull);
    });

    test('required checkbox false returns error', () {
      expect(FieldValidator.validate(requiredCheckbox, false, 'en'), isNotNull);
    });

    test('required checkbox true returns null', () {
      expect(FieldValidator.validate(requiredCheckbox, true, 'en'), isNull);
    });

    test('minLength below minimum returns error', () {
      expect(FieldValidator.validate(lengthText, 'ab', 'en'), isNotNull);
    });

    test('minLength at minimum returns null', () {
      expect(FieldValidator.validate(lengthText, 'abc', 'en'), isNull);
    });

    test('maxLength above maximum returns error', () {
      expect(FieldValidator.validate(lengthText, 'abcdef', 'en'), isNotNull);
    });

    test('maxLength at maximum returns null', () {
      expect(FieldValidator.validate(lengthText, 'abcde', 'en'), isNull);
    });

    test('invalid email returns error', () {
      expect(FieldValidator.validate(emailField, 'not-an-email', 'en'),
          isNotNull);
    });

    test('valid email returns null', () {
      expect(FieldValidator.validate(emailField, 'user@example.com', 'en'),
          isNull);
    });

    test('invalid phone returns error', () {
      expect(FieldValidator.validate(phoneField, '12-ab', 'en'), isNotNull);
    });

    test('valid phone returns null', () {
      expect(FieldValidator.validate(phoneField, '+12345678', 'en'), isNull);
    });

    test('pattern mismatch returns error', () {
      expect(FieldValidator.validate(patternField, 'abc', 'en'), isNotNull);
    });

    test('pattern match returns null', () {
      expect(FieldValidator.validate(patternField, 'ABC', 'en'), isNull);
    });

    test('non-required empty field returns null', () {
      expect(FieldValidator.validate(optionalText, '', 'en'), isNull);
    });
  });

  group('FormLocalizations', () {
    test('English required message is not empty', () {
      expect(FormLocalizations.getMessage('required', 'en'), isNotEmpty);
    });

    test('Hindi required message is not empty', () {
      expect(FormLocalizations.getMessage('required', 'hi'), isNotEmpty);
    });

    test('Arabic required message is not empty', () {
      expect(FormLocalizations.getMessage('required', 'ar'), isNotEmpty);
    });

    test('Unknown locale falls back to English', () {
      expect(
        FormLocalizations.getMessage('required', 'zz'),
        FormLocalizations.getMessage('required', 'en'),
      );
    });

    test('customMessages overrides default message', () {
      final String message = FormLocalizations.getMessage(
        'required',
        'en',
        customMessages: <String, String>{'required': 'Custom required!'},
      );
      expect(message, 'Custom required!');
    });

    test('minLength message contains the number', () {
      final String message = FormLocalizations.getMessage(
        'minLength',
        'en',
        params: <String, dynamic>{'min': 5},
      );
      expect(message.contains('5'), isTrue);
    });
  });

  group('FormResult', () {
    const FormResult result = FormResult(<String, dynamic>{
      'name': 'Alice',
      'age': 30,
    });

    test('getValue returns correct value for existing key', () {
      expect(result.getValue('name'), 'Alice');
    });

    test('getValue returns null for missing key', () {
      expect(result.getValue('missing'), isNull);
    });

    test('hasValue returns true for existing key', () {
      expect(result.hasValue('name'), isTrue);
    });

    test('toMap returns all values', () {
      expect(result.toMap(), <String, dynamic>{'name': 'Alice', 'age': 30});
    });
  });
}
