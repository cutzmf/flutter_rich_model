import 'dart:io';

import '../../authorization/feature.dart';
import '../../ball/feature.dart';
import '../../common/common.dart';
import '../ball/ball_dummy_repo.dart';
import 'deps_visitor.dart';
import 'guest_deps.dart';

class KnownDeps implements KnownUser {
  final GuestDeps guestDeps;
  final HttpClient httpClient;
  final KnownUser _decorated;
  final BallRepo ballRepo;
  late final reloadableBallModel = ReloadableModelNotifier<AsyncBallViewModel>(ballRepo.get);

  KnownDeps._(
    this._decorated, {
    required this.guestDeps,
    required this.httpClient,
    required this.ballRepo,
  });

  factory KnownDeps(KnownUser knownUser, GuestDeps guestDeps) {
    final httpClient = HttpClient();

    return KnownDeps._(
      knownUser,
      guestDeps: guestDeps,
      httpClient: httpClient,
      ballRepo: BallDummyRepo(),
    );
  }

  @override
  Token get token => _decorated.token;

  @override
  Future<void> logout() {
    guestDeps.userNotifier.value = guestDeps;

    return _decorated.logout();
  }

  @override
  T accept<T>(UserDepsVisitor<T> visitor) => visitor.visitKnownUser(this);
}
