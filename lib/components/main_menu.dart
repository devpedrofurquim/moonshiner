import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for custom fonts

import 'package:moonshiner_game/moonshiner.dart';

class MainMenu extends StatelessWidget {
  // Reference to parent game.
  final Moonshiner game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);
    const buttonColor =
        Color.fromRGBO(30, 144, 255, 1.0); // Custom button color

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              height: 350,
              width: 300,
              decoration: BoxDecoration(
                color: blackTextColor
                    .withOpacity(0.8), // Semi-transparent background
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                border: Border.all(
                    color: whiteTextColor, width: 2), // Border styling
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Moonshiner Quest',
                    style: GoogleFonts.pirataOne(
                      // Custom font
                      textStyle: const TextStyle(
                        color: whiteTextColor,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        game.overlays.remove('MainMenu');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Play',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: whiteTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '''Collect as many stars as you can and avoid enemies!''',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: whiteTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
