/// The immutable result produced when a [FormFlow] form is submitted.
library;

/// Holds the collected values of a submitted form keyed by field id.
class FormResult {
  /// The raw map of `fieldId -> value` collected from the form.
  ///
  /// Values can be of various types depending on the field:
  /// `String` for text/email/phone/number/date/image, `bool` for a single
  /// checkbox, `List<String>` for grouped checkboxes, etc.
  final Map<String, dynamic> values;

  /// Creates a result wrapping the given [values] map.
  const FormResult(this.values);

  /// Returns the value associated with [fieldId], or `null` if absent.
  dynamic getValue(String fieldId) => values[fieldId];

  /// Whether a non-null value exists for [fieldId].
  bool hasValue(String fieldId) =>
      values.containsKey(fieldId) && values[fieldId] != null;

  /// Returns an unmodifiable copy of the underlying value map.
  Map<String, dynamic> toMap() => Map<String, dynamic>.from(values);

  @override
  String toString() => 'FormResult($values)';
}
