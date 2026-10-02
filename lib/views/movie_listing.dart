import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

  @override 
  State<MovieListing> createState() => _MovieListingState();
   }
   
 class _MovieListingState extends State<MovieListing> {
   int _ticketQuantity = 0;
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'DRACULA (1931) (PG)',
                  style: TextStyle(
                    color: cinemaFontWhite,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Southsea Cinema Room ',
                    style: TextStyle(
                      color: cinemaFontWhite,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            const Text(
              'Thursday 22 Oct 2026, 18:00 - ends at 19:14',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 60),

            const Text(
              'Please note that Discounts / Membership Benefits will be applied once you have selected your tickets',
              style: TextStyle(
                fontSize: 16,
                color: cinemaFontWhite,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Select Quantities (Up to 5 in total)',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Tickets',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 16,
              ),
            ),

            SizedBox(height: 100),

            DropdownMenu<int>(
               initialSelection: 0,
               label: const Text('Adult (£7.50)'),
               onSelected: (int? value) {
               if (value != null) {
                 setState(() {
                   _ticketQuantity = value;
                });
              }
            },
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 0, label: '0'),
              DropdownMenuEntry(value: 1, label: '1'),
              DropdownMenuEntry(value: 2, label: '2'),
              DropdownMenuEntry(value: 3, label: '3'),
              DropdownMenuEntry(value: 4, label: '4'),
              DropdownMenuEntry(value: 5, label: '5'),
             ]),

             const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Text(
                      '$_ticketQuantity ticket(s) added to order',
                   ),
                 ),
               );
             },
              child: const Text('Add to order'),
            ),
            
            
          ],
        ),
      ),
    );
  }
}