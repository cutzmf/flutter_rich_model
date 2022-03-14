import 'guest_user.dart';
import 'known_user.dart';

abstract class User {
  T accept<T>(covariant UserVisitor<T> visitor);
}

abstract class UserVisitor<T> {
  T visitGuestUser(covariant GuestUser guestUser);

  T visitKnownUser(covariant KnownUser knownUser);
}
