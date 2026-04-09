import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:proyek2_pembeli/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {

    await tester.pumpWidget(MyApp());

    // cek widget dasar saja
    expect(find.byType(MaterialApp), findsOneWidget);

  });
}