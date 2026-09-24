import 'package:flutter_test/flutter_test.dart';
import 'package:elio/main.dart';

void main() {
  testWidgets('ELIO app smoke test', (WidgetTester tester) async {
    // بناء التطبيق
    await tester.pumpWidget(const ElioApp());

    // التأكد من وجود التطبيق
    expect(find.byType(ElioApp), findsOneWidget);
  });
}