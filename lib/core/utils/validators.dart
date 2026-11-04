abstract final class Validators {
  static String? email(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalized)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String value) {
    if (value.length < 8) return 'Use at least 8 characters';
    return null;
  }
}
