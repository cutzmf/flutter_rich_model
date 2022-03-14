import 'dart:io';

import '../../authorization/feature.dart';
import 'known_user_http.dart';
import 'token_http.dart';

class GuestUserHttp extends GuestUser {
  final HttpClient _httpClient;

  GuestUserHttp(this._httpClient, this.credentials);

  @override
  Future<KnownUser> login() async {
    await Future.delayed(const Duration(seconds: 2));
    // fire api exchange Cred to Token
    final token = TokenHttp(_httpClient);

    return KnownUserHttp(_httpClient, token);
  }

  @override
  final Credentials credentials;
}
