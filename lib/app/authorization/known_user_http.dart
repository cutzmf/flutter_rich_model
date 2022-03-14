import 'dart:io';

import '../../authorization/feature.dart';

class KnownUserHttp extends KnownUser {
  final HttpClient _httpClient;

  @override
  final Token token;

  KnownUserHttp(this._httpClient, this.token);

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
