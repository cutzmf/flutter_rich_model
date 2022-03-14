import 'dart:io';

import '../../ball/feature.dart';
import 'http_ball.dart';

class BallDummyRepo implements BallRepo {
  final _httpClient = HttpClient();

  int _count = 0;

  @override
  Future<AsyncBallViewModel> get() async {
    _count++;
    await Future.delayed(const Duration(seconds: 3));
    // if (_count.isOdd) throw Exception('$runtimeType dummy error');
    return OptimisticHttpBall(AsyncBallViewModel(HttpBall(_count, _httpClient)));
  }
}
