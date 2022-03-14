import 'package:flutter/material.dart';

import '../../authorization/feature.dart';
import 'login_password_credentials.dart';
import 'ux.dart';

class LoginScreen extends StatefulWidget {
  final GuestUser guestUser;
  final LoginPasswordCredentials credentials;

  const LoginScreen({
    required this.guestUser,
    required this.credentials,
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final GuestUserUxDecorator guestUser = GuestUserUxDecorator(widget.guestUser);
  late final CredentialsUxDecorator credentials = CredentialsUxDecorator(widget.credentials);

  @override
  Widget build(BuildContext context) {
    Tween();
    return Scaffold(
      appBar: AppBar(title: Text('$runtimeType')),
      body: Column(
        children: [
          _Login(credentials),
          _Password(credentials),
          _LoginButton(credentials, guestUser),
          ValueListenableBuilder<bool>(
            valueListenable: guestUser.isLoginExecutingListenable,
            builder: (context, isLoginExecuting, _) {
              if (isLoginExecuting) return const LinearProgressIndicator();
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _Login extends StatefulWidget {
  final CredentialsUxDecorator credentials;

  const _Login(this.credentials, {Key? key}) : super(key: key);

  @override
  State<_Login> createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  late final controller = TextEditingController(text: widget.credentials.login.value);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Login>(
      valueListenable: widget.credentials.listenableLogin,
      builder: (context, login, _) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'input login',
            errorText: login.isValid ? null : 'error',
          ),
          onChanged: widget.credentials.inputLogin,
        );
      },
    );
  }
}

class _Password extends StatefulWidget {
  final CredentialsUxDecorator credentials;

  const _Password(this.credentials, {Key? key}) : super(key: key);

  @override
  State<_Password> createState() => _PasswordState();
}

class _PasswordState extends State<_Password> {
  late final controller = TextEditingController(text: widget.credentials.password.value);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Password>(
      valueListenable: widget.credentials.listenablePassword,
      builder: (context, password, _) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'input password',
            errorText: password.isValid ? null : 'error',
          ),
          onChanged: widget.credentials.inputPassword,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final CredentialsUxDecorator credentials;
  final GuestUserUxDecorator guestUserUxDecorator;

  const _LoginButton(this.credentials, this.guestUserUxDecorator, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: credentials.listenableLogin,
      builder: (context, _) {
        return AnimatedBuilder(
          animation: credentials.listenablePassword,
          builder: (context, _) {
            return ValueListenableBuilder<bool>(
                valueListenable: guestUserUxDecorator.isLoginExecutingListenable,
                builder: (context, isLogging, _) {
                  return ElevatedButton(
                    onPressed: credentials.login.isValid && credentials.password.isValid && !isLogging
                        ? guestUserUxDecorator.login
                        : null,
                    child: Text('login'),
                  );
                });
          },
        );
      },
    );
  }
}
