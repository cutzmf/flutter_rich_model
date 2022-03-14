abstract class Token {
  String get value;

  String get refreshOneTimeAccess;

  Future<void> refresh();
}
