import 'movie.dart';

class BasketItem {
  final Movie movie;
  int quantity;

  BasketItem({
    required this.movie,
    required this.quantity,
  });

  double get totalPrice => movie.price * quantity;
}
