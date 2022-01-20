import 'dart:async';

import 'observable.dart';

class Ball implements Observable {
  final _controller = StreamController<Ball>.broadcast();
  int _kickedCounter;

  Ball(this._kickedCounter);

  int get kickedCounter => _kickedCounter;

  void kick() {
    _kickedCounter += 1;
    _controller.add(this);
  }

  @override
  Stream<void> get stream => _controller.stream;
}
