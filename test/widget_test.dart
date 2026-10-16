import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

void main() {
  testWidgets('Basic app loading test', (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    // Check the welcome message.
    expect(find.text('Welcome to Southsea Cinema'), findsOneWidget);

    // Check the movie cards.
    expect(find.text('DRACULA (1931)'), findsOneWidget);
    expect(find.text('FAST & FURIOUS 6'), findsOneWidget);

    // Check the booking buttons.
    expect(find.text('Book tickets'), findsNWidgets(2));
  });

  testWidgets('Booking button opens the movie listing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    // Tap the first film's booking button.
    await tester.tap(find.text('Book tickets').first);
    await tester.pumpAndSettle();

    // Check that the listing page is displayed.
    expect(find.byType(MovieListing), findsOneWidget);

    // Check that the selected film's details are displayed.
    expect(find.textContaining('DRACULA (1931)'), findsOneWidget);
    expect(find.textContaining('18:00'), findsOneWidget);
  });

  testWidgets('Add to order displays confirmation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    // Open the first film's listing page.
    await tester.tap(find.text('Book tickets').first);
    await tester.pumpAndSettle();

    // Tap Add to order.
    await tester.ensureVisible(find.text('Add to order'));
    await tester.tap(find.text('Add to order'));
    await tester.pump();
    await tester.pumpAndSettle();

    // Check the confirmation message.
    expect(
      find.text('0 ticket(s) added to order'),
      findsOneWidget,
    );
  });
}
