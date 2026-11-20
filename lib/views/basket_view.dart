import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  Map<int, List<Map<String, Object?>>> _bookingItems = {};
  final BasketRepository _basketRepository = BasketRepository();

  List<Booking> _bookings = [];
  bool _loadingBookings = true;
  String _bookingError = '';
  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

Future<void> _loadBookings() async {
  try {
    final database = CinemaDatabase.instance;

    final List<Booking> bookings = await database.getAllBookings();

    // Load the individual items belonging to each booking.
    final Map<int, List<Map<String, Object?>>> bookingItems = {};

    for (final booking in bookings) {
      if (booking.id != null) {
        bookingItems[booking.id!] =
            await database.getBookingItems(booking.id!);
      }
    }

    if (!mounted) return;

    setState(() {
      _bookings = bookings;
      _bookingItems = bookingItems;
      _loadingBookings = false;
      _bookingError = '';
    });
  } catch (error) {
    if (!mounted) return;

    setState(() {
      _loadingBookings = false;
      _bookingError = 'Could not load bookings: $error';
    });
  }
}

  String _buildSummary(List<BasketItem> items) {
    final List<String> parts = [];

    for (final BasketItem item in items) {
      parts.add('${item.quantity} x ${item.movie.title}');
    }

    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');

    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _checkout() async {
    final List<BasketItem> items = _basketRepository.getItems();

    if (items.isEmpty) return;

    final String summary = _buildSummary(items);
    final double total = _basketRepository.getTotal();
    final String date = _formatDate(DateTime.now());

    try {
      final CinemaDatabase database = CinemaDatabase.instance;

      final int bookingNumber = await database.getNextBookingNumber();

      final Booking booking = Booking(
        bookingNumber: bookingNumber,
        summary: summary,
        total: total,
        date: date,
      );

      await database.insertBookingWithItems(booking, items);

      _basketRepository.clearBasket();

      if (!mounted) return;

      setState(() {
        _confirmationMessage = 'Booking #$bookingNumber saved';
      });

      await _loadBookings();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking #$bookingNumber saved successfully!'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _confirmationMessage = 'Could not save booking: $error';
      });
    }
  }

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

Widget _buildBookingCard(Booking booking) {
  final List<Map<String, Object?>> items =
      booking.id == null ? [] : (_bookingItems[booking.id!] ?? []);

  return Card(
    color: const Color(0xFF242033),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking #${booking.bookingNumber}',
            style: const TextStyle(
              color: cinemaFontWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          if (items.isEmpty)
            Text(
              booking.summary,
              style: const TextStyle(color: cinemaFontWhite),
            )
          else
            for (final item in items) ...[
              Text(
                item['movie_title'].toString(),
                style: const TextStyle(
                  color: cinemaFontWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Screening: ${item['screening_time']}',
                style: const TextStyle(color: cinemaFontWhite),
              ),
              Text(
                'Quantity: ${item['quantity']}',
                style: const TextStyle(color: cinemaFontWhite),
              ),
              Text(
                'Ticket price: £${(item['unit_price'] as num).toStringAsFixed(2)}',
                style: const TextStyle(color: cinemaFontWhite),
              ),
              Text(
                'Subtotal: £${(item['line_total'] as num).toStringAsFixed(2)}',
                style: const TextStyle(color: cinemaFontWhite),
              ),
              const Divider(color: Colors.white24),
            ],

          Text(
            'Total: £${booking.total.toStringAsFixed(2)}',
            style: const TextStyle(color: cinemaFontWhite),
          ),
          Text(
            'Date: ${booking.date}',
            style: const TextStyle(color: cinemaFontWhite),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final List<BasketItem> items = _basketRepository.getItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Basket'),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Basket',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Text(
                'Your basket is empty',
                style: TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 18,
                ),
              )
            else ...[
              for (final BasketItem item in items)
                Card(
                  color: const Color(0xFF242033),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: const TextStyle(color: cinemaFontWhite),
                        ),
                        Text(
                          'Quantity: ${item.quantity}',
                          style: const TextStyle(color: cinemaFontWhite),
                        ),
                        Text(
                          'Subtotal: £${item.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(color: cinemaFontWhite),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _removeOne(item),
                              icon: const Icon(
                                Icons.remove,
                                color: cinemaFontWhite,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _addOne(item),
                              icon: const Icon(
                                Icons.add,
                                color: cinemaFontWhite,
                              ),
                            ),
                            TextButton(
                              key: ValueKey('remove_${item.movie.id}'),
                              onPressed: () => _removeAll(item),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                onPressed: _checkout,
              ),
            ],
            if (_confirmationMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _confirmationMessage,
                style: const TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 16,
                ),
              ),
            ],
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Past Bookings',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_loadingBookings)
              const Center(child: CircularProgressIndicator())
            else if (_bookingError.isNotEmpty)
              Text(
                _bookingError,
                style: const TextStyle(color: cinemaFontWhite),
              )
            else if (_bookings.isEmpty)
              const Text(
                'No previous bookings',
                style: TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 16,
                ),
              )
            else
              for (final Booking booking in _bookings)
                _buildBookingCard(booking),
          ],
        ),
      ),
    );
  }
}
