
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madadguru/Allwidgets/background_screen.dart';
import 'package:madadguru/Pages/Preference_set.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  final String device;

  const LanguageScreen({super.key, required this.device,});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
   }
     class _LanguageScreenState extends State<LanguageScreen> {
     String value="";


     Future<void> sendSelectedAPI(String value) async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var usertoken = prefs.getString('token');
       if (usertoken != null){
       final Uri uri = Uri.parse("https://madadguru.webkype.net/api/updateProfile");
       try {
         final response = await http.post(
           uri,
           headers: {
             'Authorization': 'Bearer $usertoken',
           },
           body: {
             "language": value,
           },
         );
         print(" response${response}");
         if (response.statusCode == 200) {
           print(response.body);
           Navigator.of(context).pushAndRemoveUntil(
               MaterialPageRoute(
                 builder: (context) => PreferenceSet(
                   device: widget.device,
                 ),
               ),
                   (route) => false);

           print('Language selection sent to API successfully.');
         } else {
           print('Failed to send language selection to API. Status code: ${response.statusCode}');
         }}catch (error) {
         print('Error sending language selection to API: $error');
       }
       }
     }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        const Background(),
        SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
               SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 7),
              alignment: Alignment.center,
              height: 50,
              width: 220,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/images/rectangle.png"
                      ),
                    fit: BoxFit.fill),
                 ),
                child: Text(
                "Select Language:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: const Color(0xFF524B6B),
                 ),
                ),
              ),
             SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                         child: GestureDetector(
                        onTap: () {
                          setState(() {
                            value = "English";
                          });
                          sendSelectedAPI("English");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: (value == "English")
                                  ? const Color(0xFFCDEDCC)
                                  : const Color(0xFFFDFBF9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xff2F2924), width: 1)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xff2F2924),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "English",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: const Color(0xFF524B6B),
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            value = "Hindi";
                          });
                          sendSelectedAPI("Hindi");

                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: (value == "Hindi")
                                  ? const Color(0xFFCDEDCC)
                                  : const Color(0xFFFDFBF9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xff2F2924), width: 1)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xff2F2924),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Hindi",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: const Color(0xFF524B6B),
                                  ),
                                )
                              ]),
                        ),
                      ),
                    )
                  ]),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            value = "Marathi";
                          });
                          sendSelectedAPI("Marathi");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: (value == "Marathi")
                                  ? const Color(0xFFCDEDCC)
                                  : const Color(0xFFFDFBF9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xff2F2924), width: 1)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xff2F2924),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Marathi",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: const Color(0xFF524B6B),
                                  ),
                                )
                              ]),
                        ),
                       ),
                      ),
                     SizedBox(
                      width: 20,
                      ),
                       Expanded(
                        child: GestureDetector(
                        onTap: () {
                          setState(() {
                            value = "Marathi";
                          });
                          sendSelectedAPI("Bengali");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: (value == "Bengali")
                                  ? const Color(0xFFCDEDCC)
                                  : const Color(0xFFFDFBF9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xff2F2924), width: 1)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xff2F2924),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Bengali",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: const Color(0xFF524B6B),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),

                  ]),
            ),
            SizedBox(height: 50,),


          ]),
        ),
        Positioned(
          right: 10,
          bottom: 40,
          child: GestureDetector(
            onTap: () {
               // Navigate to the second page
               Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) =>
                         // MapScreen
                         PreferenceSet
                      (
                       device: widget.device,
                     ),
                 ),
               );
             },
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFFFEADD),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF524B6B),
              ),
            ),
          ),
        ),

      ]),
    );
  }
}
