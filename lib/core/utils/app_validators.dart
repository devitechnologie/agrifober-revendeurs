class AppValidators {
  /// Validates that the provided [object] is not null.
  /// Throws an [AssertionError] with a descriptive message if the validation fails.
  static T requireNonNull<T>(T? object, String message) {
    assert(object != null, message);
    return object!;
  }

  /// Add more global validations as needed
  static String requireNonEmpty(String? value, String message) {
    assert(value != null && value.isNotEmpty, message);
    return value!;
  }

  static List<T> requireNonEmptyList<T>(List<T>? list, String message) {
    assert(list != null && list.isNotEmpty, message);
    return list!;
  }
}
