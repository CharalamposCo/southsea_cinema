import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/views/settings_view.dart';
import 'package:flutter/services.dart';

void main() {
  setUp(() {
  rootBundle.clear();
  });
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

    testWidgets('PrimaryButton displays label and responds to taps',
      (WidgetTester tester) async {
    bool buttonPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Test Button',
            onPressed: () {
              buttonPressed = true;
            },
          ),
        ),
      ),
    );

    // Check that the button label appears.
    expect(find.text('Test Button'), findsOneWidget);

    // Tap the button.
    await tester.tap(find.text('Test Button'));
    await tester.pump();

    // Check that the callback runs.
    expect(buttonPressed, isTrue);
  });

    testWidgets('Settings page displays all profile fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );

    expect(find.text('My Settings'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Patron Number'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Receive news by email'), findsOneWidget);
    expect(find.text('SAVE SETTINGS'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
  });

  testWidgets('Address can be cleared',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(
      tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      ).controller!.text,
      '',
    );
  });

  testWidgets('Email preferences can be switched off',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );

    expect(tester.widget<Switch>(find.byType(Switch)).value, true);

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(tester.widget<Switch>(find.byType(Switch)).value, false);
  });

  testWidgets('Invalid email address shows validation error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );

    await tester.enterText(
      find.byType(TextFormField).at(1),
      'invalid-email',
    );

    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    expect(
      find.text('Please enter a valid email address'),
      findsOneWidget,
    );
  });

  testWidgets('Valid settings display success message',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );

    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    expect(
      find.text('Settings saved successfully'),
      findsOneWidget,
    );
  });

}
