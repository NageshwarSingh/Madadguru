import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../AllWidgets/buttons.dart';
import 'SubcriptionScreen.dart';

class VolunteerProfileDetailScreen extends StatefulWidget {
  final String device;
  final int postId;
  const VolunteerProfileDetailScreen({
    super.key,
    required this.device,
    required this.postId,
  });
  @override
  State<VolunteerProfileDetailScreen> createState() =>
      _VolunteerProfileDetailScreenState();
   }
  class _VolunteerProfileDetailScreenState
    extends State<VolunteerProfileDetailScreen> {
  int segmentedControlValue = 0;
  bool isActive = false;
  List<dynamic> department = [];
  List DepartmentList = [
    {
      "id": 29,
      "filterValue": "Property",
    },
    {
      "id": 30,
      "filterValue": "Loan",
    },
    {
      "id": 31,
      "filterValue": "Family",
    },
    {
      "id": 32,
      "filterValue": "Legal Case",
    },
    {
      "id": 33,
      "filterValue": "Marriage",
    },
    {
      "id": 34,
      "filterValue": "Relation",
    },
    {
      "id": 35,
      "filterValue": "Divorce",
    },
    {
      "id": 36,
      "filterValue": "Labour Law",
    },
    {
      "id": 37,
      "filterValue": "Ministry",
    },
    {
      "id": 38,
      "filterValue": "Govt",
    },
  ];

  bool isLoading = false;
  Map<String, dynamic> volunteerData = {};
  get switchesEnabled => false;
  TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    volunteerProfile();
  }

  bool contactButton = true;
  Future<void> volunteerProfile() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/volunteerProfile");
      try {
        final response = await http.post(uri, headers: {
          'Authorization': 'Bearer $usertoken',
        }, body: {
          'volunteer_id': widget.postId.toString(),
        });
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("object $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            setState(() {
              volunteerData = userData;
              fetchDatagetWant(volunteerData["i_want"]);
              var myUserid = prefs.getString('userId');
              var addByUserid =
                  userData['contactdata'][0]['user_id'].toString();
              print('myUsermobile: $myUserid');
              print('addByUsermobile: $addByUserid');
              if (myUserid == addByUserid) {
                contactButton = false;
              }
            });
          } else {
            print('API request failed: ${responseData["message"]}');
          }
          print('Data fetched successfully');
          print(response.body);
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
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
  bool alreadyContacted = false;
  List<bool> switchStates = [];
  Map<String, dynamic> Data = {};
  List<dynamic> Data2 = [];
  String iwant = "";
  String needhelpin = "";
  Future<void> fetchDatagetWant(String activeValues) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getWant");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
        );
        if (response.statusCode == 200) {
          var jData = json.decode(response.body);
          setState(() {
            Data = jData;
            Data2 = Data['data'];
            switchStates = List<bool>.filled(Data2.length, false);
            for (int i = 0; i < Data2.length; i++) {
              if (activeValues.contains(Data2[i]['id'].toString())) {
                switchStates[i] = true;
              }
            }
            switchStates = List.generate(Data2.length, (index) => false);
            updateSwitchStates();
            print("Data From Api$Data");
          });
          print(response.body);

          print('Data fetched successfully');
        } else {
          print('Failed to fetch Data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching data: $error');
      }
    }
  }

  void updateIWant() {
    if (volunteerData.containsKey('i_want')) {
      setState(() {
        iwant = volunteerData['i_want'];
      });
      print("i want's value: $iwant");
    }
  }

  void updateSwitchStates() {
    if (volunteerData.containsKey('i_want')) {
      print('Updating switchStates based on i_want');
      setState(() {
        switchStates = List<bool>.filled(Data2.length, false);
        for (int i = 0; i < Data2.length; i++) {
          switchStates[i] =
              volunteerData['i_want'].contains(Data2[i]['id'].toString());
        }
        print('Updated switchStates: $switchStates');
      });
    } else {
      print('i_want data not found');
    }
    if (volunteerData.containsKey('i_need_help')
    ) {}
  }

  void onChangedSwitch(int index, bool value) {
    setState(() {
      switchStates[index] = value;
      updateIWant(); // Update i_want value
    });
  }


  void contactUserPopUp(String id, String message,String Volunteer) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs != null) {
        var usertoken = prefs.getString('token');
        if (usertoken != null) {
          final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/addUserContact");
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $usertoken',
            },
            body: {
              "user_id": id,
              "message": message,
              "type":Volunteer,
            },
          );
          if (response.statusCode == 200) {
            print('addPostEnquiry: ${response.body}');
            var Data = jsonDecode(response.body);
            if (Data['status'] == 200 && Data['success'] == true) {
              print('addUserContact sent successfully: ${Data['message']}');
            } else {
              print('Failed to send addUserContact: ${Data['message']}');
            }
          } else {
            print(
                'API request failed with status code: ${response.statusCode}');
          }
        } else {
          print('No token found in SharedPreferences.');
        }
      } else {
        print('SharedPreferences is null.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xcd000000),
                        ),
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          // margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.only(
                              top: 65, left: 10, right: 10, bottom: 10),
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: Column(
                            children: [
                              Text(
                                (volunteerData["name"] != null)
                                    ? volunteerData["name"]
                                    : 'Not available',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                (volunteerData["email"] != null)
                                    ? volunteerData["email"]
                                    : 'Not available',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Mobile: ${(volunteerData["mobile"] != null) ? volunteerData["mobile"] : 'Not available'}",
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Dob: ${(volunteerData["dob"] != null) ? volunteerData["dob"] : 'Not available'}",
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                (volunteerData["profession"] != null)
                                    ? volunteerData["profession"]
                                    : 'Not available',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0x4d6cabff),
                                    ),
                                    child: Text(
                                      "Gender: ${(volunteerData["gender"] != null) ? volunteerData["gender"] : 'Not available'}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff3600FF),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0x4D8EE386),
                                    ),
                                    child: Text(
                                      "Language: ${(volunteerData["language"] != null) ? volunteerData["language"] : 'Not available'}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff096001),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -40,
                          left: MediaQuery.of(context).size.width / 2.7,
                          child: CircleAvatar(
                            radius: 46.5,
                            backgroundColor: Colors.black38,
                            child: Center(
                              child: CircleAvatar(
                                radius: 45,
                                child: ClipOval(
                                  child: Image.network(
                                    volunteerData['profile'] ?? 'No Image',
                                    fit: BoxFit.cover,
                                    height: 90,
                                    width: 90,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 10, left: 10, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'About',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              (volunteerData["about"] != null)
                                  ? volunteerData["about"]
                                  : 'Not available',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "I want:",
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: Data.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                if (index >= Data2.length) {
                                  return Container();
                                }
                                return ListTile(
                                  title: Container(
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          width: 1, color: Colors.orange),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                  'assets/images/icon.png'),
                                              Text(
                                                Data2[index]['name'].toString(),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Switch(
                                              autofocus: true,
                                              value: switchStates[index],
                                              onChanged: switchesEnabled
                                                  ? (value) {
                                                      setState(() {
                                                        switchStates[index] =
                                                            value;
                                                        updateIWant();
                                                      });
                                                    }
                                                  : null,
                                              activeTrackColor:
                                                  Colors.lightGreenAccent,
                                              activeColor:
                                                  Colors.green.shade200),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "Contacts",
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                                    ),
                                    volunteerData == null ||
                                    volunteerData['contactdata'] == null
                                     ? Padding(
                                    padding: const EdgeInsets.only(top: 150),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        // radius: 30,
                                        color: Colors.indigo[900],
                                      ),
                                    ),
                                  )
                                : volunteerData['contactdata'].length == 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 50),
                                        child: Center(
                                          child: Text(
                                            'No Contact Available',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            volunteerData['contactdata'].length,
                                        // itemCount: Mydata['data'].length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post =
                                              volunteerData['contactdata']
                                                  [index];
                                          return GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 15,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(0)),
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
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 30,
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .network(
                                                                      post['icon'] ??
                                                                          '',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width:
                                                                          60.0, // adjust width as needed
                                                                      height:
                                                                          60.0,
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Icon(
                                                                          Icons
                                                                              .person,
                                                                          size:
                                                                              50,
                                                                          color:
                                                                              Colors.grey[400],
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
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    post['user_name'] ??
                                                                        '',
                                                                    style: GoogleFonts.roboto(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Text(
                                                                    post['user_email'] ??
                                                                        '',
                                                                    style: GoogleFonts.roboto(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  // SizedBox(
                                                                  //   height: 3,
                                                                  // ),
                                                                  // Text(
                                                                  //
                                                                  //   post['user_mobile'] ??
                                                                  //       '',
                                                                  //   style: GoogleFonts.roboto(
                                                                  //       color: Colors
                                                                  //           .black,
                                                                  //       fontSize: 12,
                                                                  //       fontWeight:
                                                                  //       FontWeight
                                                                  //           .w400),
                                                                  //     ),
                                                                  SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Visibility(
                                                                visible:
                                                                    contactButton,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Call'),
                                                                          content:
                                                                              Text('Are you sure you want to Call?'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text('No'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                var phoneNumber = post['user_mobile'] ?? '';
                                                                                var url = "tel:$phoneNumber";
                                                                                print("Calling $phoneNumber");
                                                                                await launchUrl(
                                                                                  Uri.parse(url),
                                                                                );
                                                                              },
                                                                              child: Text('Yes'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Icon(
                                                                      Icons
                                                                          .call,
                                                                      color: Colors
                                                                          .greenAccent),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    contactButton,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('WhatsApp'),
                                                                            content:
                                                                                Text('Are you sure you want to WhatsApp Message?'),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text('No'),
                                                                                 ),
                                                                                TextButton(
                                                                                onPressed: () async {
                                                                                  var phoneNumber = post['user_mobile'] ?? '';
                                                                                  var message = "Hello";
                                                                                  var url = "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";
                                                                                  print("The URL is $url");
                                                                                  await launchUrl(
                                                                                    Uri.parse(url),
                                                                                  );
                                                                                },
                                                                                child: Text('Yes'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                    );
                                                                  },
                                                                  child: Image
                                                                      .asset(
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
                                                            (post["message"] !=
                                                                    null)
                                                                ? post[
                                                                    "message"]
                                                                : 'message not available',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [

                                                        // Text(
                                                        //  "Gender: ${(post["user_gender"] !=null)? post["user_gender"]: 'gender not available'}"
                                                        //   style: GoogleFonts.roboto(
                                                        //       color: Colors.black,
                                                        //       fontSize: 12,
                                                        //       fontWeight: FontWeight.w500),
                                                        //   ),

                                                        Text(
                                                          (post["created_at"] !=
                                                                  null)
                                                              ? post[
                                                                  "created_at"]
                                                              : 'date not available',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                     ),
                                     SizedBox(
                                      height: 20,
                                    ),
                            if (volunteerData.containsKey('is_subscription') &&
                                volunteerData['is_subscription'] == 1)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showDialogue(context);
                                    setState(() {
                                      alreadyContacted = true;
                                    });
                                    // volunteerProfile();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: ButtonWidget(
                                    text: alreadyContacted
                                        ? "Already Contacted"
                                        : "Unlocked",
                                    color: Colors.orange.shade200,
                                    textColor: Colors.orange,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                ),
                                if (volunteerData.containsKey('is_subscription') &&
                                volunteerData['is_subscription'] == 0)
                                Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SubcriptionScreen(
                                            device: widget.device),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade200,
                                    // padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                        'Unlock',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            //**********  Correct Code    **********
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) {
                            //           return SubcriptionScreen(
                            //             device: widget.device,
                            //             );
                            //         },
                            //        ),
                            //       );
                            //     },
                            //     child: Padding(
                            //     padding: const EdgeInsets.only(
                            //         right: 20, left: 20, top: 20, bottom: 20),
                            //     child: Card(
                            //       elevation: 2,
                            //       child: Container(
                            //         height: 45,
                            //         width: MediaQuery.of(context).size.width,
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(12),
                            //             color: Color(0xffFBCD96)),
                            //         child: Center(
                            //           child: Text(
                            //             'Unlock',
                            //             style: TextStyle(
                            //                 color: Colors.orange,
                            //                 fontWeight: FontWeight.bold,
                            //                 fontSize: 16),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _showDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Contact'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextField(
                    maxLines: 5,
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Text here....',
                      labelStyle: TextStyle(color: Colors.orange),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      contentPadding:
                      EdgeInsets.only(left: 10, right: 10, top: 10),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      // Handle text changes
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      contactUserPopUp(
                          widget.postId.toString(),_textController.text,widget.key.toString());
                      Navigator.pop(context);
                      await volunteerProfile();
                    },
                    child: ButtonWidget(
                      text: "Send",
                      color: const Color(0xffFF9228),
                      textColor: Colors.white,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
