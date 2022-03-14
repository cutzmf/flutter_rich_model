import '../../authorization/feature.dart';
import 'guest_deps.dart';
import 'known_deps.dart';

abstract class UserDepsVisitor<T> extends UserVisitor<T> {
  @override
  T visitGuestUser(GuestDeps guestUser);

  @override
  T visitKnownUser(KnownDeps knownUser);
}
