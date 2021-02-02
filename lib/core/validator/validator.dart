
class Validator {
  static String validateMobile(String val) {
//    if (val.length != 11) {
//      return "invalid_mobile_number";
//    }
  if(val.length!=11)
    return "Invalid mobile number!";
    if (!_isNumeric(val))
      return "Please input only digits.";
    else
      return null;
  }

  static String validatePassword(String val) {
    if (val.isEmpty)
      return "Password can't be empty!";
    else if (val.length < 6) {
      return "Minimum password size id 6";
    } else
      return null;
  }

  static String validateConfirmPassword(String val1, String val2) {
    if (val1 != val2)
      return "Password didn't match";
    else
      return null;
  }

  static bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  static String validateUsername(String value) {
    if (value.isEmpty)
      return "Required Field";
    else
      return null;
  }

  static String validateText(String value) {
    if (value.isEmpty)
      return "Required Field";
    else
      return null;
  }

  static String validateDropDown(value) {
    if (value == null)
      return "Required Field";
    else
      return null;
  }

  static String validateEmail(String val) {
    bool emailValid =
        RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(val);
    if (emailValid)
      return null;
    else
      return "Invalid Email Address";
  }

  static String validateNumber(String value) {
    if (value.isEmpty)
      return "Invalid Email Address";
    else
      return null;
  }

  static String isEmpty(var value) {
    if (value == null) {
      return "Invalid Email Address";
    } else
      return null;
  }
}
