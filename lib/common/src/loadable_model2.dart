import 'dart:async';

import 'package:flutter/foundation.dart';

typedef FutureFactory<T> = Future<T> Function();
typedef FutureStream<T> = Stream<Future<T>> Function();

class AsyncModel<T> extends ValueNotifier<Future<T?>> implements ValueListenable<Future<T?>> {
  final FutureFactory<T> _factory;

  AsyncModel(this._factory) : super(SynchronousFuture(null));

  Future<void> load() async {
    value = _factory();
    await value;
  }

  Future<void> reload() async {
    try {
      await value;
    } finally {
      value = SynchronousFuture(value).then((value) => _factory());
      await value;
    }
  }
}
