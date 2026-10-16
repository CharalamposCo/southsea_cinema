import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  testWidgets('Basic app loading test', (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    // Check the welcome message.
    expect(find.text('Welcome to Southsea Cinema'), findsOneWidget);

    // Check that the movie cards are displayed.
    expect(find.text('DRACULA (1931)'), findsOneWidget);
    expect(find.text('FAST & FURIOUS 6'), findsOneWidget);

    // Check that the booking buttons are displayed.
    expect(find.text('Book tickets'), findsNWidgets(2));
  });
}
