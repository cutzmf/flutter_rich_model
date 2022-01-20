import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    final c = StreamController<int>.broadcast();

    await tester.pumpWidget(
      StreamBuilder(
        stream: c.stream,
        builder: (_, snap1) {
          print('snap1: $snap1');

          if (snap1.connectionState == ConnectionState.active) {
            return StreamBuilder(
              stream: c.stream,
              builder: (_, snap2) {
                print('snap2: $snap2');
                return const SizedBox.shrink();
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );

    c.add(42);
    await tester.pump(Duration.zero);

    c.add(43);
    await tester.pump(Duration.zero);
  });
}
