import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../authorization/feature.dart';
import '../../login/feature.dart';
import '../authorization/deps_visitor.dart';
import 'guest_user_http.dart';
import 'known_deps.dart';

class GuestDeps implements GuestUser {
  final HttpClient httpClient;
  late final userNotifier = ValueNotifier<User>(this);

  @override
  LoginPasswordCredentials credentials = LoginPasswordCredentials();

  GuestDeps._({
    required this.httpClient,
  });

  factory GuestDeps() {
    final httpClient = HttpClient();

    return GuestDeps._(
      httpClient: httpClient,
    );
  }

  @override
  Future<KnownUser> login() async {
    final knownUser = await GuestUserHttp(httpClient, credentials).login();

    final knownScope = KnownDeps(knownUser, this);

    userNotifier.value = knownScope;

    return knownScope;
  }

  @override
  T accept<T>(UserDepsVisitor<T> visitor) => visitor.visitGuestUser(this);
}
