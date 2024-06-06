import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Allwidgets/BottomNavBar.dart';
import 'Allwidgets/initial_background.dart';
import 'Pages/IntroPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MadadGuru',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  String device = "IOS";
  late BuildContext _context;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3000), () => checkLogin());
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          BackgroundMain(),
          AnimatedSplashScreen(
            nextScreen: IntroSliderScreen(device: device),
            splash: Column(
              children: [
                Image.asset(
                  'assets/images/mimage.png',
                  height: 234,
                  width: 276,
                ),
                SizedBox(
                  height: 40,
                ),
                //             AnimatedTextKit(animatedTexts: [
                //               WavyAnimatedText('Destined to help you...',
                // ),
                //
                //             ],),
                Text(
                  "Destined to help you...",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    // color: Colors.black
                    color: const Color(0xFF60075F),
                  ),
                 ),
                ],
               ),
             backgroundColor: Colors.transparent,
            duration: 3000,
            splashIconSize: 350,
            splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransionType.fade,
          ),
          // Destined to help you..
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 200),
              child: Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: const Color(0xFFEC7224),
                ),
                ),

              // AnimatedTextKit(
              //   repeatForever: true,
              //   animatedTexts: [
              //     FlickerAnimatedText(
              //       'Version 1.0.0',
              //       textStyle: TextStyle(
              //         fontWeight: FontWeight.w500,
              //         fontSize: 18,
              //         color: const Color(0xFFEC7224),
              //       ),
              //     ),
              //
              //   ],
              // ),



            ),
          ),
        ],
      ),
    );
  }

  checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString("userId");
    if (userID != null) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => BottomNavBar(
                device: device,
              ),
            ),
            (route) => false);
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => IntroSliderScreen(
                device: device,
              ),
            ),
            (route) => false);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _context = context;
  }
}
