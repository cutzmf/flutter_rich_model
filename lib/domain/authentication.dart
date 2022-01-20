abstract class Authentication {}

abstract class Guest implements Authentication {
  void authenticate(Login login, Password password);
}

abstract class User implements Authentication {
  void logout();
}

enum LoginErrors { lessThan3, moreThan100 }

class Login {
  Login(this.errors);

  Set<LoginErrors> errors;

  bool get isValid => errors.isEmpty;
}

enum PasswordErrors { lessThan4 }

abstract class Password {
  Password(this.errors);

  Set<PasswordErrors> errors;

  bool get isValid => errors.isEmpty;
}
