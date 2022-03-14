import '../../authorization/feature.dart';

class LoginPasswordCredentials implements Credentials {
  Login _login = Login._('');

  Password _password = Password._('');

  Login get login => _login;

  Password get password => _password;

  void inputLogin(String value) => _login = Login._(value);

  void inputPassword(String value) => _password = Password._(value);
}

class Login {
  final bool isValid;
  final String value;

  Login._(this.value) : isValid = value.length > 2;
}

class Password {
  final bool isValid;
  final String value;

  Password._(this.value) : isValid = _validate(value);

  static bool _validate(String value) {
    return (value.length >= 4);
  }
}
