import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'BottomNavBar.dart';
import 'background_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
   }
  class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  Stack(
        children: [
          Background(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    // onTap: () {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) {
                    //         return BottomNavBar(device: widget.device);
                    //       }));
                    // },
                    child: Icon(Icons.arrow_back)),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome',
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                // Expanded(child: buildView()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
