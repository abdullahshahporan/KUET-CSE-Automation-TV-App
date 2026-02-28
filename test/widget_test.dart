import 'package:flutter_test/flutter_test.dart';
import 'package:kuet_cse_tv/main.dart';

void main() {
  testWidgets('TV app renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const KUETTvApp());
    expect(find.text('Department of Computer Science & Engineering'), findsOneWidget);
  });
}
