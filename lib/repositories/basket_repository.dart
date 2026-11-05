import '../models/movie.dart';
import '../models/basket_item.dart';

class BasketRepository {
  final List<BasketItem> _items = [];

  List<BasketItem> getItems() {
    return List.unmodifiable(_items);
  }

  double getTotal() {
    double total = 0;

    for (final item in _items) {
      total += item.totalPrice;
    }

    return total;
  }

  void addTickets(Movie movie, int quantity) {
    if (quantity <= 0) return;

    final index = _items.indexWhere(
      (item) => item.movie.id == movie.id,
    );

    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        BasketItem(
          movie: movie,
          quantity: quantity,
        ),
      );
    }
  }

  void removeTickets(String movieId, int quantity) {
    if (quantity <= 0) return;

    final index = _items.indexWhere(
      (item) => item.movie.id == movieId,
    );

    if (index == -1) return;

    _items[index].quantity -= quantity;

    if (_items[index].quantity <= 0) {
      _items.removeAt(index);
    }
  }

  void clearBasket() {
    _items.clear();
  }
}