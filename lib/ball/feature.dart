import 'src/model.dart';

export 'src/model.dart';
export 'src/screen.dart';

abstract class BallRepo {
  Future<AsyncBallState> get();
}
