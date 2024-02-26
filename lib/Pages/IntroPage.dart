import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_slider/source/presentation/pages/introduction_slider.dart';
import 'package:introduction_slider/source/presentation/widgets/buttons.dart';
import 'package:introduction_slider/source/presentation/widgets/dot_indicator.dart';
import 'package:introduction_slider/source/presentation/widgets/introduction_slider_item.dart';
import 'package:madadguru/Allwidgets/background_screen.dart';
import 'Login.dart';

  class IntroSliderScreen extends StatefulWidget {
  final String device;
  const IntroSliderScreen({super.key, required this.device});
  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
  }
  class _IntroSliderScreenState extends State<IntroSliderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children:[
          Background(),
           IntroductionSlider(
            items: [
                   IntroductionSliderItem(
                     title: Text(
                  "Community Help",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: const Color(0xFFEC7224),
                    ),
                    ),
                    logo: Padding(
                    padding:EdgeInsets.only(top: 20  , bottom: 10), child: Stack(clipBehavior: Clip.none, children: [
                       Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/enjoy.png",
                      ),
                      ),
                      Positioned(
                      right: 10,
                      top: -MediaQuery.of(context).size.height / 7,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 7),
                        alignment: Alignment.center,
                        height: 70,
                        width: 180,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/rectangle.png',
                            ),
                          ),
                        ),
                        child: Text(
                          "Helping People",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: const Color(0xFF524B6B),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                backgroundColor: Colors.transparent,
              ),
              IntroductionSliderItem(
                title: Text(
                  "Help In Crises",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: const Color(0xFFEC7224),
                  ),
                ),
                logo: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 90),
                  child: Stack(clipBehavior: Clip.none, children: [
                    Image.asset(
                      "assets/images/house.png",
                    ),
                    Positioned(
                      right: 10,
                      top: -MediaQuery.of(context).size.height / 6,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 7),
                        alignment: Alignment.center,
                        height: 70,
                        width: 180,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/rectangle.png"),
                          ),
                        ),
                        child: Text(
                          "Helping Society",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: const Color(0xFF524B6B),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                backgroundColor: Colors.transparent,
              ),
              IntroductionSliderItem(
                  title: Text(
                  "Legal Help & advice",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: const Color(0xFFEC7224),
                  ),
                ),
                logo: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 110),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(clipBehavior: Clip.none, children: [
                        Image.asset(
                          "assets/images/loyer.png",
                        ),
                        Positioned(
                          right: 10,
                          top: -MediaQuery.of(context).size.height / 6,
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 7),
                            alignment: Alignment.center,
                            height: 70,
                            width: 180,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/rectangle.png"),
                                       ),
                                    ),
                            child: Text(
                              "Helping Legal",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: const Color(0xFF524B6B),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
            ],
            done: Done(
              child: const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFFFEADD),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF524B6B),
                ),
              ),
              home: Login(
                device: widget.device,
              ),
            ),
            next: const Next(
                child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFFFEADD),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF524B6B),
                    ))),
            back: const Back(
                child: CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFFFEADD),
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF524B6B),
                ),
              ),
            )),
            dotIndicator: const DotIndicator(
              size: 7,
              selectedColor: Color(0xFFEC7224),
              unselectedColor: Color(0x80EC7224),
            ),
            showStatusBar: true,
                     ),
        ],
      ),
    );
  }
}
