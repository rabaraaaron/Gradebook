class ValidatorService {

  /// validateEmail
  /// Validates email with regex
  ///
  /// @param String value : value from the text input
  /// @return String : error message if invalid, null if valid
  ///
  String validateEmail(String value) {
    // Check if empty
    if (value.isEmpty) {
      // The form is empty
      return "Enter an email address";
    }
    
    // Regex Check
    var regex = "^[a-zA-Z0-9.!#\%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$";
    RegExp regExp = new RegExp(regex);
    if (regExp.hasMatch(value)) {
      return null;
    }
    else {
      return "Email is not valid.";
    }
  }

  /// validatePassword
  /// Validates password length for sign in page
  ///
  /// @param String value : value from the text input
  /// @return String : error message if invalid, null if valid
  ///
  String validatePassword(String value) {
    // Check if empty
    if (value.isEmpty) {
      return "Enter a password.";
    }
    if (value.length < 6) {
      return "Passwords must be more than 6 characters long.";
    }
    if (value.length > 25) {
      return "Passwords must be less than 25 characters long.";
    }
    return null;
  }

  /// validateName
  /// Validates password length for sign in page
  ///
  /// @param String value : value from the text input
  /// @return String : error message if invalid, null if valid
  ///
  String validateName(String value) {
    // Check if empty
    if (value.isEmpty) {
      // The form is empty
      return "Enter your name.";
    }

    // Regex Check
    var regex = "^[a-zA-Z\\s]*\$";
    RegExp regExp = new RegExp(regex);
    if (regExp.hasMatch(value)) {
      return null;
    }
    else {
      return "Enter a valid name.";
    }
  }

}