import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

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
        child: const Column(
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

          ],
        ),
      ),
    );
  }
}