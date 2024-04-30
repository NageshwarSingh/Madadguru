import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import '../Pages/AccountScreen.dart';
import '../Pages/HomeScreen.dart';
import '../Pages/FeedScreen.dart';
import '../Pages/PostScreen.dart';
import '../Pages/Volunteer.dart';

class MySplashScreen extends StatefulWidget {
  final String device;
  const MySplashScreen({super.key, required this.device});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      nextScreen: BottomNavBar(device: widget.device),
      splash: WelcomePopupSplash(),
      backgroundColor: Colors.transparent,
      duration: 1500,
      splashIconSize: MediaQuery.of(context).size.height,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

class WelcomePopupSplash extends StatelessWidget {
  late final String device;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        // height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          ),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/mimage.png', height: 234, width: 276),
            SizedBox(height: 20),

            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Close'),
            // ),

            SizedBox(height: 20),
            Text(
              'Welcome',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
                'I need help is a statement that indicates the speakers current situation or request for assistance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
            SizedBox(height: 20),
            Text(
              'Just Second Wait.....',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),

            SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => BottomNavBar(
                        // device: widget.device,
                        device: '',
                      ),
                    ),
                    (route) => false);
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) {
                //       return BottomNavBar(device: '',
                //
                //         // device: widget.device,
                //       );
                //     }),
                //   );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 40, left: 40, top: 20, bottom: 10),
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffFBCD96)),
                      child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                         ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final String device;
  const BottomNavBar({
    super.key,
    required this.device,
  });
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List pages = [
    const HomeScreen(
      Device: "IOS",
      device: '',
    ),
    const FeedScreen(
      device: "IOS",
    ),
    VolunteerScreen(
      device: "Android",
    ),
    PostScreen(
      back: false,
      device: "Android",
      ),
      const AccountScreen(
      device: "IOS",
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (currentIndex != 0) {
            setState(() {
              currentIndex = 0;
            });
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xffFF9228),
            currentIndex: currentIndex,
            onTap: onTap,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.orange,
                ),
                icon: Icon(
                  Icons.home,
                  color: Colors.grey,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Feed',
                activeIcon: Icon(
                  Icons.toc_outlined,
                  color: Colors.orange,
                ),
                icon: Icon(
                  Icons.toc_outlined,
                  color: Colors.grey,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Volunteer',
                activeIcon: Icon(
                  Icons.room_preferences,
                  color: Colors.orange,
                ),
                icon: Icon(
                  Icons.room_preferences,
                  color: Colors.grey,
                ),
              ),
              BottomNavigationBarItem(
                label: 'My Post',
                activeIcon: Icon(
                  Icons.join_right_rounded,
                  color: Colors.orange,
                ),
                icon: Icon(
                  Icons.join_right_rounded,
                  color: Colors.grey,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Account',
                activeIcon: Icon(
                  Icons.person,
                  color: Colors.orange,
                ),
                icon: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ));
  }
}
