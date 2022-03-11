import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../domain/volleyball.dart';

class VolleyballListScreen extends StatelessWidget {
  const VolleyballListScreen(this.collection, {Key? key}) : super(key: key);

  final PagedCollection<VolleyBall> collection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$runtimeType'),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: collection.length,
          builder: (context, collectionLength) {
            print(collectionLength);
            return StatefulBuilder(
              builder: (context, setState) {
                return ListView.separated(
                  itemCount: collectionLength.data ?? 44,
                  separatorBuilder: (_, i) => const Divider(color: Colors.black),
                  itemBuilder: (_, i) {
                    return SizedBox(
                      height: 70,
                      child: Center(
                        child: FutureBuilder<VolleyBall>(
                          future: collection[i],
                          builder: (context, snapshot) {
                            if (snapshot.hasData) return Text('${snapshot.requireData}');

                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasError) {
                              return ElevatedButton(
                                onPressed: () => collection[i].whenComplete(() => setState(() {})),
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
