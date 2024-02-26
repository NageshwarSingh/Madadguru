import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madadguru/Allwidgets/background_screen.dart';

class SubcriptionScreen extends StatefulWidget {
  final String device;
  const SubcriptionScreen({super.key, required this.device});
  @override
  State<SubcriptionScreen> createState() => _SubcriptionScreenState();
}

class _SubcriptionScreenState extends State<SubcriptionScreen> {
  List<String> imagesDp = [
    'assets/images/dp1.png',
    'assets/images/dp2.jpeg',
    'assets/images/dp3.webp',
    'assets/images/dp4.jpeg',
    'assets/images/girl.png',
    'assets/images/dp3.webp',
    'assets/images/dp4.jpeg',
    'assets/images/people.webp',
  ];
  List<String> names = [
    'For Helper',
    'For user',
    'For volunteer',
    'For Helper',
    'For user',
    'For volunteer',
    'For Helper',
    'For user',
  ];
  List<Color> cardColors=[
    Colors.orange.shade100,
    Colors.blue.shade100,
    Colors.orange.shade100,
    Colors.blue.shade100,
    Colors.yellow.shade100,
    Colors.red.shade100,
    Colors.cyan.shade100,
    Colors.blue.shade100,

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
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
                  onTap: () {
                    Navigator.pop(context);
                  },

                    // onTap: () {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) {
                    //     return BottomNavBar(device: widget.device);
                    //   }
                    //   ));
                    // },
                    child: Icon(Icons.arrow_back)),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Subscriptions',
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: buildView()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildView() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 8,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Card(
              elevation: 2,
              child: Container(
                height: 285,
                decoration: BoxDecoration(
                  color: cardColors[index],
                     // border: Border.all(width: 1,color:Colors.orange),
                     borderRadius: BorderRadius.circular(12),
                     ),
                   child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: CircleAvatar(
                                  radius: 30,
                                  child: ClipOval(
                                    child: Image.asset(
                                      imagesDp[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.s,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    names[index],
                                    // "Gajendra Singh ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                      "joined program on 3 sep 2024",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(width: 100,),

                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(height: 5,),
                                Image.asset(
                                  'assets/images/crown.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ],
                            ),
                          ),
                        ]),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Free',
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Expire on 10 dec 2024',
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Text(
                        '7 days free trial after thet 299/month \n plan exclusions: \n'
                        '* Access to all podcasts and videos \n'
                        '* Access to upto 10 games \n'
                        '* Access to all e-books',
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                       ),
                     ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Card(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                            child: Center(
                            child: Text
                              ('Cancle Subscription',
                               style: GoogleFonts.roboto(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
