import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';

void main() {
  late BasketRepository basketRepository;
  late Database testDatabase;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    basketRepository = BasketRepository();
    basketRepository.clearBasket();

    testDatabase = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
    );

    await CinemaDatabase.instance.createTables(testDatabase, 1);
    CinemaDatabase.instance.setDatabase(testDatabase);
  });

  tearDown(() async {
    basketRepository.clearBasket();
    await CinemaDatabase.instance.close();
  });

  testWidgets(
    'Remove the middle film and keep the other two',
    (WidgetTester tester) async {
      const Movie firstMovie = Movie(
        id: 'film-one',
        title: 'Film One',
        description: 'First test film',
        rating: 'PG',
        imagePath: 'assets/images/dracula.jpg',
        screeningTime: '18:00',
        price: 8.50,
      );

      const Movie middleMovie = Movie(
        id: 'film-two',
        title: 'Film Two',
        description: 'Second test film',
        rating: '12',
        imagePath: 'assets/images/fast6.jpg',
        screeningTime: '19:00',
        price: 10.00,
      );

      const Movie lastMovie = Movie(
        id: 'film-three',
        title: 'Film Three',
        description: 'Third test film',
        rating: 'PG',
        imagePath: 'assets/images/dracula.jpg',
        screeningTime: '20:00',
        price: 9.00,
      );

      // Add three different films to the basket.
      basketRepository.addTickets(firstMovie, 1);
      basketRepository.addTickets(middleMovie, 1);
      basketRepository.addTickets(lastMovie, 1);

      // Open the basket page.
      await tester.pumpWidget(
        const MaterialApp(
          home: BasketView(),
        ),
      );

      await tester.pumpAndSettle();

      // Check that all three films are displayed.
      expect(find.text('Film One'), findsOneWidget);
      expect(find.text('Film Two'), findsOneWidget);
      expect(find.text('Film Three'), findsOneWidget);

      // Find the Remove button belonging to the middle film.
      final Finder middleRemoveButton = find.byKey(
        const ValueKey('remove_film-two'),
      );

      expect(middleRemoveButton, findsOneWidget);

      // Remove only the middle film.
      await tester.tap(middleRemoveButton);
      await tester.pumpAndSettle();

      // Check that the first and last films remain.
      expect(find.text('Film One'), findsOneWidget);
      expect(find.text('Film Three'), findsOneWidget);

      // Check that the middle film has been removed.
      expect(find.text('Film Two'), findsNothing);
    },
  );
}
