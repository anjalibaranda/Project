import 'package:flutter_test/flutter_test.dart';
import 'package:demo1/main.dart';

void main() {
  testWidgets('Student Management App splash screen test',
          (WidgetTester tester) async {
        await tester.pumpWidget(const StudentManagementApp());

        expect(find.text('Student Management App'), findsOneWidget);
      });
}