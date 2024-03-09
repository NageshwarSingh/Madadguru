import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  final String device;
  const NotificationScreen({
    super.key,
    required this.device,
  });
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isActive = false;
  List Notification = [];

  // List<String> imagesDp = [
  //   'assets/images/dp1.png',
  //   'assets/images/dp2.jpeg',
  //   'assets/images/dp3.webp',
  //   'assets/images/dp4.jpeg',
  //   'assets/images/girl.png',
  //   'assets/images/dp3.webp',
  //   'assets/images/girl.png',
  //   'assets/images/dp3.webp',
  //   'assets/images/dp4.jpeg',
  //   'assets/images/people.webp',
  // ];
  @override
  void initState() {
    super.initState();
    myNotification();
    setState(() {
      isActive = true;
    });
  }

  bool isLoading = false;
  Map<String, dynamic> JsonData = {};
  Future<void> myNotification() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/myNotification");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("myNotification $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            if (userData is List) {
              setState(() {
                JsonData = {'data': List<Map<String, dynamic>>.from(userData)};

                print('API response: ${JsonData}');
              });
            }
            if (JsonData["data"] == null || JsonData["data"].isEmpty) {}
          } else {
            print('API request failed: ${responseData["message"]}');
          }
          print('Data fetched successfully');
          print(response.body);
        }
      } catch (error) {
        print('Error fetching data: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
          title: Text(
            "Notification",
            style: GoogleFonts.roboto(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
         ),
         body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15),
        child: JsonData.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 250),
                child: Center(
                    child: CircularProgressIndicator(
                  // radius: 30,
                  color: Colors.indigo[900],
                )),
              )
            : JsonData["data"].length == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        'No Post Available',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: JsonData['data'].length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var post = JsonData['data'][index];
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 15,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14)),
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: CircleAvatar(
                                backgroundColor: Colors.purple.shade200,
                                radius: 25,
                                child: ClipOval(
                                  child: Image.network(
                                    post['icon'] ?? '',
                                    fit: BoxFit.cover,
                                    width: 50.0, // adjust width as needed
                                    height: 50.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey[400],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              title:
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(

                                    (post["title"] != null)
                                        ? post["title"]
                                        : 'about not available',

                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(

                                    (post["message"] != null)
                                        ? post["message"]
                                        : 'about not available',

                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                 ),
                                subtitle: Text(
                                post['created_at'] ?? '',
                                // "Oct 06, 2023",
                                style: GoogleFonts.roboto(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            )),
                      );
                    }),
      ),
    );
  }
}
