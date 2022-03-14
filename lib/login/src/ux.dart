import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../authorization/feature.dart';
import 'login_password_credentials.dart';

class CredentialsUxDecorator implements LoginPasswordCredentials {
  final LoginPasswordCredentials _decorated;

  CredentialsUxDecorator(this._decorated);

  late final listenableLogin = ValueNotifier(login);
  late final listenablePassword = ValueNotifier(password);

  @override
  void inputLogin(String value) {
    _decorated.inputLogin(value);
    listenableLogin.value = login;
  }

  @override
  void inputPassword(String value) {
    _decorated.inputPassword(value);
    listenablePassword.value = password;
  }

  @override
  Login get login => _decorated.login;

  @override
  Password get password => _decorated.password;
}

class GuestUserUxDecorator implements GuestUser {
  final GuestUser _decorated;

  GuestUserUxDecorator(this._decorated);

  @override
  T accept<T>(covariant UserVisitor<T> visitor) => _decorated.accept(visitor);

  @override
  Credentials get credentials => _decorated.credentials;

  final isLoginExecutingListenable = ValueNotifier<bool>(false);

  @override
  Future<KnownUser> login() async {
    try {
      isLoginExecutingListenable.value = true;
      return await _decorated.login();
    } finally {
      isLoginExecutingListenable.value = false;
    }
  }
}
