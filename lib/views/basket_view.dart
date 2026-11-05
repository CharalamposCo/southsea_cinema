import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  final BasketRepository _basketRepository = BasketRepository();

  void _removeOne(BasketItem item) {
    setState(() {
      _basketRepository.removeTickets(item.movie.id, 1);
    });
  }

  void _addOne(BasketItem item) {
    setState(() {
      _basketRepository.addTickets(item.movie, 1);
    });
  }

  void _removeAll(BasketItem item) {
    setState(() {
      _basketRepository.removeTickets(
        item.movie.id,
        item.quantity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _basketRepository.getItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Basket'),
      ),
      drawer: const NavDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: items.isEmpty
            ? const Center(
                child: Text(
                  'Your basket is empty',
                  style: TextStyle(
                    color: cinemaFontWhite,
                    fontSize: 18,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Card(
                          color: const Color(0xFF242033),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.movie.title,
                                  style: const TextStyle(
                                    color: cinemaFontWhite,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Ticket price: ${item.movie.formattedPrice}',
                                  style: const TextStyle(
                                    color: cinemaFontWhite,
                                  ),
                                ),
                                Text(
                                  'Quantity: ${item.quantity}',
                                  style: const TextStyle(
                                    color: cinemaFontWhite,
                                  ),
                                ),
                                Text(
                                  'Subtotal: £${item.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: cinemaFontWhite,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _removeOne(item),
                                      icon: const Icon(
                                        Icons.remove,
                                        color: cinemaFontWhite,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _addOne(item),
                                      icon: const Icon(
                                        Icons.add,
                                        color: cinemaFontWhite,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          _removeAll(item),
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Total: £${_basketRepository.getTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: cinemaFontWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Checkout',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Checkout coming soon!',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}