import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

  @override 
  State<MovieListing> createState() => _MovieListingState();
   }
   
 class _MovieListingState extends State<MovieListing> {
   int _ticketQuantity = 1;
 

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
                    fontSize: 32,
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Dracula is a classic 1931 horror film about Count Dracula, '
                    'a mysterious vampire who moves to England and terrorises '
                    'those around him.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),

            DropdownMenu<int>(
               initialSelection: 1,
               onSelected: (int? value) {
               if (value != null) {
                 setState(() {
                   _ticketQuantity = value;
                });
              }
            },
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 1, label: '1'),
              DropdownMenuEntry(value: 2, label: '2'),
              DropdownMenuEntry(value: 3, label: '3'),
              DropdownMenuEntry(value: 4, label: '4'),
              DropdownMenuEntry(value: 5, label: '5'),
            ],
            )
          ],
        ),
      ),
    );
  }
}