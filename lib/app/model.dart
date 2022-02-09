import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';

import '../ball/feature.dart';
import '../domain/ball.dart';

class BallDummyRepo implements BallRepo {
  final _httpClient = HttpClient();

  int _count = 0;

  @override
  Future<AsyncBallViewModel> get() async {
    _count++;
    await Future.delayed(const Duration(seconds: 3));
    // if (_count.isOdd) throw Exception('$runtimeType dummy error');
    return _OptimisticHttpBall(AsyncBallViewModel(_HttpBall(_count, _httpClient)));
  }
}

class _OptimisticHttpBall implements AsyncBallViewModel {
  final AsyncBallViewModel _asyncBall;

  _OptimisticHttpBall(this._asyncBall);

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

class _HttpBall extends Ball implements AsyncBall {
  final HttpClient _httpClient;
  final _controller = StreamController<Ball>.broadcast();

  _HttpBall(int kickedCounter, this._httpClient) : super(kickedCounter);

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
