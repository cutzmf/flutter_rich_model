import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'model.dart';

class BallKickScreen extends StatelessWidget {
  const BallKickScreen(this.reloadableModel, {Key? key}) : super(key: key);

  final ReloadableModel<AsyncBallViewModel> reloadableModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$runtimeType'),
      ),
      body: RefreshIndicator(
        onRefresh: () => reloadableModel.reload().onError(SnackBarError(context)),
        child: CustomScrollView(
          slivers: [
            SliverFillViewport(
              delegate: SliverChildBuilderDelegate(
                (context, _) {
                  return ValueListenableBuilder<Future<AsyncBallViewModel>>(
                    valueListenable: reloadableModel,
                    builder: (context, futureBall, _) {
                      return FutureBuilder<AsyncBallViewModel>(
                        future: futureBall,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final ball = snapshot.requireData;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: StreamBuilder(
                                    stream: ball.stream,
                                    builder: (context, _) {
                                      return Text('${ball.kickedCounter}');
                                    },
                                  ),
                                ),
                                _KickButton(ball),
                              ],
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return TextButton(
                                onPressed: reloadableModel.reload,
                                child: const Text('Ooops! Retry'),
                              );
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KickButton extends StatelessWidget {
  const _KickButton(this.ball, {Key? key}) : super(key: key);

  final AsyncBallViewModel ball;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ball.stream.handleError(SnackBarError(context)),
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: ball.isKicking ? null : ball.kick,
              child: const Text('Kick ball'),
            ),
            SizedBox(
              height: 4,
              child: ball.isKicking ? const LinearProgressIndicator() : null,
            ),
          ],
        );
      },
    );
  }
}
