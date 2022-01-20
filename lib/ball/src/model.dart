import 'dart:async';

import 'package:async/async.dart';

import '../../domain/ball.dart';

abstract class AsyncBall implements Ball {
  @override
  Future<void> kick();
}

class AsyncBallState implements AsyncBall {
  final AsyncBall _asyncBall;
  final _c = StreamController<AsyncBall>.broadcast();

  AsyncBallState(this._asyncBall);

  bool get isKicking => _isKicking;
  bool _isKicking = false;

  @override
  Future<void> kick() async {
    try {
      _c.add(this.._isKicking = true);
      await _asyncBall.kick();
    } finally {
      _c.add(this.._isKicking = false);
    }
  }

  @override
  Stream<void> get stream => StreamGroup.mergeBroadcast({_c.stream, _asyncBall.stream});

  @override
  int get kickedCounter => _asyncBall.kickedCounter;
}
