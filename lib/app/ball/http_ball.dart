import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';

import '../../ball/feature.dart';
import '../../domain/ball.dart';

class HttpBall extends Ball implements AsyncBall {
  final HttpClient _httpClient;
  final _controller = StreamController<Ball>.broadcast();

  HttpBall(int kickedCounter, this._httpClient) : super(kickedCounter);

  @override
  Future<void> kick() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      await _httpClient.post('foo.bar', 443, '/ball/kick');
      super.kick();
    } on Object catch (error, stackTrace) {
      _controller.addError(error, stackTrace);
      rethrow;
    }
  }

  @override
  Stream<void> get stream => StreamGroup.mergeBroadcast({super.stream, _controller.stream});
}

class OptimisticHttpBall implements AsyncBallViewModel {
  final AsyncBallViewModel _asyncBall;

  OptimisticHttpBall(this._asyncBall);

  Ball? _ball;

  @override
  Future<void> kick() async {
    try {
      _ball = Ball(_asyncBall.kickedCounter)..kick();
      await _asyncBall.kick();
    } finally {
      _ball = null;
    }
  }

  @override
  int get kickedCounter {
    final ball = _ball;
    return ball != null ? ball.kickedCounter : _asyncBall.kickedCounter;
  }

  @override
  Stream<void> get stream => _asyncBall.stream;

  @override
  bool get isKicking => _asyncBall.isKicking;
}
