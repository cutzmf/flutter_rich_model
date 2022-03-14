import 'credentials.dart';
import 'known_user.dart';
import 'user.dart';

abstract class GuestUser implements User {
  Credentials get credentials;

  Future<KnownUser> login();

  @override
  T accept<T>(UserVisitor<T> visitor) => visitor.visitGuestUser(this);
}
