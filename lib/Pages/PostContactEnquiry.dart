import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PostContactEnquiry extends StatefulWidget {
  final String device;
  final int id;
  const PostContactEnquiry({
    super.key,
    required this.device,
    required this.id,
  });

  @override
  State<PostContactEnquiry> createState() => _PostContactEnquiryState();
}

class _PostContactEnquiryState extends State<PostContactEnquiry> {
  bool isActive = false;
  List Notification = [];
  @override
  void initState() {
    super.initState();
    EnquiryContact();
    setState(() {
      isActive = true;
    });
  }

  bool contactButton=true;
  bool isLoading = false;
  Map<String, dynamic> JsonData = {};
  Future<void> EnquiryContact() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getPostEnquiry");
      try {
        final response = await http.post(uri, headers: {
          'Authorization': 'Bearer $usertoken',
        }, body: {
          'post_id': widget.id.toString(),
        });
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          if (responseData != null && responseData['success'] == true) {
            var userData = responseData['data'];
            print("UserData: $userData"); // Print userData for debugging
            if (userData != null && userData is List) {
              setState(() {
                JsonData = {'data': List<Map<String, dynamic>>.from(userData)};

                var myUsermobile = prefs.getString('userId');
                var addByUsermobile = JsonData['data'][0]['user_id'].toString();
                print('My User ID: $myUsermobile');
                print('Add By User ID: $addByUsermobile');
                if (myUsermobile==addByUsermobile){
                  contactButton = false;
                }
              });
            } else {
              print('Data is null or not a List');
            }
          } else {
            print(
                'API request failed or success is false: ${responseData?["message"]}');
          }
          print('Data fetched successfully');
          print(response.body);
        } else {
          print('API request failed with status code: ${response.statusCode}');
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

           ),
          ),

      ),
         body: SingleChildScrollView(
          child: Column(
           children: [
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
                                                     child: CircleAvatar(
                                                    radius: 30,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        (post["icon"] != null)
                                                            ? post["icon"]
                                                            : 'profile not available',

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
                                                  children: [
                                                    SizedBox(height: 10,),
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
                                                      (post["user_email"] !=
                                                              null)
                                                          ? post["user_email"]
                                                          : 'email not available',
                                                      // post['user_email'] ?? '',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 3,
                                                    // ),
                                                    // Text(
                                                    //   (post["user_mobile"] !=
                                                    //           null)
                                                    //       ? post["user_mobile"]
                                                    //       : 'mobile not available',
                                                    //   style: GoogleFonts.roboto(
                                                    //       color: Colors.black,
                                                    //       fontSize: 12,
                                                    //       fontWeight:
                                                    //           FontWeight.w400),
                                                    // ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible:contactButton,
                                                  child: InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                context) {
                                                              return AlertDialog(
                                                                title:
                                                                    Text('Call'),
                                                                content: Text(
                                                                    'Are you sure you want to Call?'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'No'),
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

                                                                    child: Text(
                                                                        'Yes'),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Icon(Icons.call,
                                                          color: Colors
                                                              .greenAccent)),
                                                ),
                                                Visibility(
                                                    visible:contactButton,
                                                  child: InkWell(
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
                                                ),
                                              ],
                                            ),
                                          ]),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              (post["message"] != null)
                                                  ? post["message"]
                                                  : 'message not available',

                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),

                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            (post["created_at"] != null)
                                                ? post["created_at"]
                                                : 'date not available',
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
                                ),
                          );
                        }),
          ],
        ),
      ),
    );
  }
}
