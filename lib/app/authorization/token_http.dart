import 'dart:io';

import '../../authorization/src/token.dart';

class TokenHttp implements Token {
  final HttpClient _httpClient;

  TokenHttp(this._httpClient);

  @override
  Future<void> refresh() async {}

  @override
  String get value => throw UnimplementedError();

  @override
  String get refreshOneTimeAccess => throw UnimplementedError();
}
