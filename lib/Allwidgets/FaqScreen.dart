import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAqScreen extends StatefulWidget {
  final String device;
  const FAqScreen({super.key, required this.device});

  @override
  State<FAqScreen> createState() => _FAqScreenState();
}
class _FAqScreenState extends State<FAqScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              ),
             ),
            ),
            title: Text("Faq/Help",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
             ),
             ),
             ),
         body: SingleChildScrollView(
           child: Column(
             children: [

              ListView.builder(
               itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
               shrinkWrap: true,
              itemBuilder: (context, index) {
                return
                  Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xffFFEADD),
                      borderRadius: BorderRadius.circular(15)),
                  child: Theme(
                    data:
                    Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                        title: Text("How can i figure out my life:",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          children:[
                           Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                                 child: Text(
                                    "1. Reflect on your values, beliefs, and goals.\n"
                                    "2. Identify your passions and interests.\n"
                                    "3. Evaluate your strengths and weaknesses.\n"
                                    "4. Set achievable, realistic, and meaningful goals.\n"
                                    "5. Seek advice from trusted individuals such as family, friends, or a therapist.\n"
                                    "6. Try new experiences and don't be afraid of failure.\n"
                                    "7. Maintain a positive outlook and growth mindset.\n"
                                    "8. Stay self-aware and continue to reflect on your progress and growth.",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                 ),
                          ),
                        ]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
