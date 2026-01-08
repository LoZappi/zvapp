import 'package:flutter_test/flutter_test.dart';

import 'package:zv_transport_app/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ZVApp());
    expect(find.textContaining('Z&V'), findsWidgets);
  });
}
