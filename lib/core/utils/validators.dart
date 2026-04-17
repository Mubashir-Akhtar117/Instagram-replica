class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6 || value.length > 8) {
      return "Password must be 6–8 characters";
    }

    final hasUppercase = RegExp(r'[A-Z]');
    final hasNumber = RegExp(r'[0-9]');
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (!hasUppercase.hasMatch(value)) {
      return "Include at least 1 uppercase letter";
    }

    if (!hasNumber.hasMatch(value)) {
      return "Include at least 1 number";
    }

    if (!hasSpecialChar.hasMatch(value)) {
      return "Include at least 1 special character";
    }
    return null;
  }
}
