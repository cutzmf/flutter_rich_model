import 'package:flutter/material.dart';

import 'app/model.dart';
import 'ball/feature.dart';
import 'common/common.dart';

void main() {
  final repo = BallDummyRepo();
  final reloadableBallModel = ReloadableModelNotifier<AsyncBallViewModel>(repo.get);

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScaffoldMessenger(
        child: BallKickScreen(reloadableBallModel),
      ),
    ),
  );
}
