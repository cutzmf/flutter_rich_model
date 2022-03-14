import 'token.dart';
import 'user.dart';

abstract class KnownUser implements User {
  Token get token;

  Future<void> logout();

  @override
  T accept<T>(UserVisitor<T> visitor) => visitor.visitKnownUser(this);
}
