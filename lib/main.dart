import 'dart:collection';

import 'package:flutter/material.dart';

import 'app/model.dart';
import 'ball/feature.dart';
import 'common/common.dart';
import 'domain/volleyball.dart';
import 'volleyball/src/screen.dart';

void main() {
  final repo = BallDummyRepo();
  final reloadableBallModel = ReloadableModelNotifier<AsyncBallViewModel>(repo.get);
  final collection = PagedCollection<VolleyBall>(firstPage: VolleyBallPage(0));

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScaffoldMessenger(
        child: VolleyballListScreen(collection),
      ),
    ),
  );
}

class VolleyBallPage extends CollectionPage<VolleyBall> {
  final int pageIndex;

  VolleyBallPage(this.pageIndex) : super(10);

  late bool isDummyError = pageIndex.isOdd;

  Future<UnmodifiableListView<VolleyBall>> _dummy() async {
    await Future.delayed(const Duration(seconds: 4));

    print('### $pageIndex $isDummyError');
    if (isDummyError) {
      isDummyError = false; // recover on next
      throw Exception('Ooops!');
    }

    return UnmodifiableListView(List.generate(size, (index) => VolleyBall(pageIndex * 10 + index + 1)));
  }

  late Future<UnmodifiableListView<VolleyBall>> _lazyFutureItems = _dummy();

  @override
  Future<UnmodifiableListView<VolleyBall>> get futureItems async {
    try {
      await _lazyFutureItems;
    } on Object {
      _lazyFutureItems = _dummy();
    }
    return _lazyFutureItems;
  }

  @override
  CollectionPage<VolleyBall> getNext() {
    return VolleyBallPage(pageIndex + 1);
  }

  @override
  Stream<int> get itemsCount async* {
    await _lazyFutureItems;
    yield 4;
  }
}
