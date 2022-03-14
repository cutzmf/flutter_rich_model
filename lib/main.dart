import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/authorization/deps_visitor.dart';
import 'app/authorization/guest_deps.dart';
import 'app/authorization/known_deps.dart';
import 'authorization/src/user.dart';
import 'ball/feature.dart';
import 'login/src/login_screen.dart';

void main() {
  final guestDeps = GuestDeps();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScaffoldMessenger(
        child: LoginScreenOrHomeScreen(guestDeps.userNotifier),
      ),
    ),
  );
}

class LoginScreenOrHomeScreen extends StatelessWidget implements UserDepsVisitor<Widget> {
  final ValueListenable<User> userListenable;

  const LoginScreenOrHomeScreen(this.userListenable, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User>(
      valueListenable: userListenable,
      builder: (context, user, _) => user.accept(this),
    );
  }

  @override
  Widget visitGuestUser(covariant GuestDeps guestUser) {
    return LoginScreen(guestUser: guestUser, credentials: guestUser.credentials);
  }

  @override
  Widget visitKnownUser(covariant KnownDeps knownUser) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: knownUser.logout, child: Text('logout')),
        ],
      ),
      body: BallKickScreen(knownUser.reloadableBallModel),
    );
  }
}
