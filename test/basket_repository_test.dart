import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';

void main() {
  late BasketRepository basketRepository;

  const dracula = Movie(
    id: 'dracula-1931',
    title: 'DRACULA (1931)',
    description: 'Classic horror film',
    rating: 'PG',
    imagePath: 'assets/images/dracula.jpg',
    screeningTime: '18:00',
    price: 8.50,
  );

  const fastAndFurious = Movie(
    id: 'fast-and-furious-6',
    title: 'FAST & FURIOUS 6',
    description: 'Action film',
    rating: '12',
    imagePath: 'assets/images/fast6.jpg',
    screeningTime: '20:00',
    price: 10.00,
  );

  setUp(() {
    basketRepository = BasketRepository();
  });

  test('Add tickets to basket', () {
    basketRepository.addTickets(dracula, 2);

    expect(basketRepository.getItems().length, 1);
    expect(basketRepository.getItems().first.quantity, 2);
  });

  test('Add tickets to an existing basket item', () {
    basketRepository.addTickets(dracula, 2);
    basketRepository.addTickets(dracula, 1);

    expect(basketRepository.getItems().first.quantity, 3);
  });

  test('Remove tickets from basket', () {
    basketRepository.addTickets(dracula, 3);
    basketRepository.removeTickets(dracula.id, 1);

    expect(basketRepository.getItems().first.quantity, 2);
  });

  test('Remove basket item when all tickets are removed', () {
    basketRepository.addTickets(dracula, 2);
    basketRepository.removeTickets(dracula.id, 2);

    expect(basketRepository.getItems(), isEmpty);
  });

  test('Clear basket', () {
    basketRepository.addTickets(dracula, 2);
    basketRepository.addTickets(fastAndFurious, 1);

    basketRepository.clearBasket();

    expect(basketRepository.getItems(), isEmpty);
    expect(basketRepository.getTotal(), 0);
  });

  test('Calculate basket total', () {
    basketRepository.addTickets(dracula, 2);
    basketRepository.addTickets(fastAndFurious, 1);

    expect(basketRepository.getTotal(), 27.00);
  });
}