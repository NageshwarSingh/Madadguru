import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatefulWidget {
  final String device;
  const ContactsScreen({
    super.key,
    required this.device,
  });
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool isActive = false;
  List Notification = [];
  @override
  void initState() {
    super.initState();
    myContact();
    setState(() {
      isActive = true;
    });
  }

  bool isLoading = false;
  Map<String, dynamic> JsonData = {};
  Future<void> myContact() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/myContact");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("myContact $responseData");
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          'Contacts',
          style: GoogleFonts.roboto(
            color: Colors.black,
            // fontSize: 16,
          ),
        ),

        // Container(
        //   height: 40,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     color: const Color(0xffffffff),
        //     border: Border.all(color: Colors.black38, width: 1.5),
        //     borderRadius: const BorderRadius.all(
        //       Radius.circular(12),
        //     ),
        //   ),
        //   child: TextField(
        //       autofocus: false,
        //       // controller: searchController,
        //       keyboardType: TextInputType.text,
        //       textInputAction: TextInputAction.search,
        //       decoration: InputDecoration(
        //           suffixIcon: const Icon(
        //             Icons.search,
        //             color: Color(0xff7a7979),
        //             size: 25,
        //           ),
        //           contentPadding: EdgeInsets.only(left: 5, right: 5),
        //           // const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        //           border: InputBorder.none,
        //           hintText: "Search",
        //           hintStyle: TextStyle(
        //             color: const Color(0xff7a7979),
        //             fontSize: 14,
        //             fontWeight: FontWeight.w500,
        //           )),
        //       onSubmitted: (_) {}),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, bottom: 15, top: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Contacts',
            //         style: GoogleFonts.roboto(
            //             color: Colors.black,
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ],
            //   ),
            // ),
            JsonData.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 250),
                    child: Center(
                      child: CircularProgressIndicator(
                        // radius: 30,
                        color: Colors.indigo[900],
                      ),
                    ),
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
                    : Container(
                        // height: MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height - 100,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: JsonData['data'].length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            print(JsonData);
                            var post = JsonData['data'][index];
                            return Container(
                                // height: 400,
                                //  width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(0)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10,
                                      left: 10.0,
                                      top: 10,
                                      bottom: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child:
                                                      // CircleAvatar(
                                                      //   radius: 35,
                                                      //   backgroundImage: NetworkImage(
                                                      //     'https://i.pinimg.com/originals/5a/6b/16/5a6b16956a2753892d9ee5714f6f112a.jpg',
                                                      //   ),
                                                      // ),
                                                      CircleAvatar(
                                                    radius: 30,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        post['icon'] ?? '',
                                                        fit: BoxFit.cover,
                                                        width:
                                                            60.0, // adjust width as needed
                                                        height: 60.0,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Icon(
                                                            Icons.person,
                                                            size: 50,
                                                            color: Colors
                                                                .grey[400],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // mainAxisAlignment: MainAxisAlignment.s,
                                                  children: [
                                                    Text(
                                                      post['user_name'] ?? '',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      post['user_email'] ?? '',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      post['user_mobile'] ?? '',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    // Text(
                                                    //   post['message'] ?? '',
                                                    //   // textAlign:
                                                    //   //     TextAlign.center,
                                                    //   style: GoogleFonts.roboto(
                                                    //       color: Colors.black,
                                                    //       fontSize: 12,
                                                    //       fontWeight:
                                                    //           FontWeight.w400),
                                                    //   // softWrap: true,
                                                    //   overflow:
                                                    //       TextOverflow.ellipsis,
                                                    //   maxLines: 3,
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text('Call'),
                                                            content: Text(
                                                                'Are you sure you want to Call?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Text('No'),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  var phoneNumber =
                                                                      post['user_mobile'] ??
                                                                          '';
                                                                  var url =
                                                                      "tel:$phoneNumber";
                                                                  print(
                                                                      "Calling $phoneNumber");
                                                                  await launchUrl(
                                                                      Uri.parse(
                                                                          url));
                                                                },
                                                                child:
                                                                    Text('Yes'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Icon(Icons.call,
                                                      color:
                                                          Colors.greenAccent),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'WhatsApp'),
                                                            content: Text(
                                                                'Are you sure you want to WhatsApp Message?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Text('No'),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  var phoneNumber =
                                                                      post['user_mobile'] ??
                                                                          ''; // Extract mobile number from post
                                                                  var message =
                                                                      "Hello"; // Predefined message
                                                                  var url =
                                                                      "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";
                                                                  print(
                                                                      "The URL is $url");
                                                                  await launchUrl(
                                                                      Uri.parse(
                                                                          url));
                                                                },
                                                                child:
                                                                    Text('Yes'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/whats.png',
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              post['message'] ?? '',
                                              // textAlign:
                                              //     TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w400),
                                              // softWrap: true,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Gender: ${post['user_gender'] ?? ''}",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            post['created_at'] ?? '',
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                                // subtitle:
                                );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
