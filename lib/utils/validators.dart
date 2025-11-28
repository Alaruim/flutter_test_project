class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter valid email';
    }
    
    return null;
  }
}