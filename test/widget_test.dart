import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_circle/main.dart';

void main() {
  testWidgets('Splash screen shows app name', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: EventCircleApp(),
      ),
    );

    // Verify that splash screen content is shown
    expect(find.text('EventCircle'), findsOneWidget);
  });
}
