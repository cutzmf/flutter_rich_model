import 'package:flutter/foundation.dart';

typedef FutureFactory<T> = Future<T> Function();

abstract class LoadableModel<T> implements ValueListenable<Future<T>> {
  FutureFactory get futureFactory;

  Future<void> load();
}

abstract class ReloadableModel<T> implements LoadableModel<T> {
  Future<void> reload();
}

class LoadableModelNotifier<T> extends ValueNotifier<Future<T>> implements LoadableModel<T> {
  LoadableModelNotifier(this.futureFactory) : super(futureFactory());

  @override
  final FutureFactory<T> futureFactory;

  @override
  Future<void> load() async {
    await value;
  }
}

class ReloadableModelNotifier<T> extends LoadableModelNotifier<T> implements ReloadableModel<T> {
  ReloadableModelNotifier(FutureFactory<T> futureFactory) : super(futureFactory);

  @override
  Future<void> reload() async {
    try {
      // you can't reload if already loading or reloading
      value.ignore();
      await value;
    } finally {
      // next prevents empty UI state (keeps data that already loaded)
      value = futureFactory();
      await value;
    }
  }
}
