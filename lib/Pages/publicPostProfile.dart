import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AllWidgets/buttons.dart';
import 'package:http/http.dart' as http;

class PublicPostProfile extends StatefulWidget {
  final String device;
  final int postId;
  const PublicPostProfile({
    super.key,
    required this.device,
    required this.postId,
  });
  @override
  State<PublicPostProfile> createState() => _PublicPostProfileState();
  }
  class _PublicPostProfileState extends State<PublicPostProfile> {
  int segmentedControlValue = 0;
  bool isLoading = false;
  bool alreadyContacted = false;
  bool contactButton = true;
  Map JobDetail = {};
  bool showButton = true;
  Map profileData = {};
  TextEditingController _textController = TextEditingController();
  get switchesEnabled => false;
  @override
  void initState() {
    super.initState();
    fetchuserProfile();
  }
    Map<String, dynamic> userData = {};
    // wrong APi
    Future<void> fetchuserProfile() async {
    print("TheUseridididid${widget.postId}");
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/userProfile");
      try {
        final response = await http.post(uri, headers: {
          'Authorization': 'Bearer $usertoken',
        }, body: {
          'user_id': widget.postId.toString(),
        });
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("UserProfile $responseData");
          if (responseData['success'] == true) {
            var userDataa = responseData['data'];
            setState(() {
              userData = userDataa;
              fetchDatagetWant(userData['i_want']);
              var myUserId = prefs.getString('userId');
              var addByUserId = userData['id'].toString();
              print('My User ID: $myUserId');
              print('Add By User ID: $addByUserId');
              if (addByUserId == myUserId) {
                showButton = false;
              }
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
            print('userData API request failed: ${responseData["message"]}');
          }
          print('userData fetched successfully');
          print(response.body);
        } else {
          print(
              'Failed to fetch userData. Status code: ${response.statusCode}');
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

  void contactUserPopUp(String id, String message) async {
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

  List<bool> switchStates = [];
  Map<String, dynamic> Data = {};
  List<dynamic> Data2 = [];
  String iwant = "";
  String needhelpin = "";
  List<dynamic> department = [];
  List<Map<String, dynamic>> DepartmentList = [];
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
    if (userData.containsKey('i_want')) {
      setState(() {
        iwant = userData['i_want'];
      });
      print("i want's value: $iwant");
    }
  }

  void updateSwitchStates() {
    if (userData.containsKey('i_want')) {
      print('Updating switchStates based on i_want');
      setState(() {
        switchStates = List<bool>.filled(Data2.length, false);
        for (int i = 0; i < Data2.length; i++) {
          switchStates[i] =
              userData['i_want'].contains(Data2[i]['id'].toString());
        }
        print('Updated switchStates: $switchStates');
      });
    } else {
      print('i_want data not found');
    }

    if (userData.containsKey('i_need_help')) {
      setState(() {
        department = DepartmentList.where((item) =>
            userData['i_need_help'].contains(item['id'].toString())).toList();
      });
    }
  }

  void onChangedSwitch(int index, bool value) {
    setState(() {
      switchStates[index] = value;
      updateIWant();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: [
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
                  Stack(clipBehavior: Clip.none, children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.only(
                          top: 65, left: 10, right: 10, bottom: 10),
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: Column(children: [
                        Text(
                          (userData["name"] != null)
                              ? userData["name"]
                              : 'Name not available',
                          // "Gajendra Singh",
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
                          (userData["email"] != null)
                              ? userData["email"]
                              : 'email not available',
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
                          "Mobile: ${(userData["mobile"] != null) ? userData["mobile"] : 'mobile not available'}",
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
                          "Dob: ${(userData["dob"] != null) ? userData["dob"] : "dob not available"}",
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
                          (userData["profession"] != null)
                              ? userData["profession"]
                              : 'profession not available',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  "Gender: ${(userData["gender"] != null) ? userData["gender"] : "dob not available"}",
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
                                    "Language: ${(userData["language"] != null) ? userData["language"] : "dob not available"}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff096001),
                                    )),
                              ),
                            ])
                      ]),
                    ),
                    Positioned(
                      top: -40,
                      left: MediaQuery.of(context).size.width / 2.7,
                      child: CircleAvatar(
                        radius: 46.5,
                        backgroundColor: Colors.black,
                        child: Center(
                          child: CircleAvatar(
                            radius: 45,
                            child: ClipOval(
                              child: Image.network(
                                userData['profile'],
                                fit: BoxFit.cover,
                                width: 90.0,
                                height: 90.0,
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
                  ]),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "About",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  (userData["about"] != null)
                                      ? userData["about"]
                                      : 'about not available',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  "I want:",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
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
                                                  Data2[index]['name']
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 14),
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
                                                  Colors.green.shade200,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
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
                              userData == null ||
                                      userData['contactdata'] == null
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 150),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          // radius: 30,
                                          color: Colors.indigo[900],
                                        ),
                                      ),
                                    )
                                  : userData['contactdata'].length == 0
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
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
                                              userData['contactdata'].length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var post =
                                                userData['contactdata'][index];
                                            return GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                      ),
                                                     child: Padding(
                                                        padding:
                                                       EdgeInsets.only(
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
                                                                            60.0,
                                                                        height:
                                                                            60.0,
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Icon(
                                                                            Icons.person,
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
                                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          10,
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
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: Text('Call'),
                                                                              content: Text('Are you sure you want to Call?'),
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
                                                                          });
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
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: Text('WhatsApp'),
                                                                              content: Text('Are you sure you want to WhatsApp Message?'),
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
                                                                          });
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/whats.png',
                                                                      height:
                                                                          50,
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
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          // Text(
                                                          //  "Gender: ${(post["user_gender"] !=null)? post["user_gender"]: 'gender not available'}",
                                                          //
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
                                                            style: GoogleFonts.roboto(
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
                                          }),
                              SizedBox(
                                height: 20,
                              ),
                              Visibility(
                                visible: showButton,
                                child: GestureDetector(
                                  onTap: () {
                                    _showDialogue(context);
                                    setState(() {
                                      alreadyContacted = true;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30.0),
                                    child: ButtonWidget(
                                      text: alreadyContacted
                                          ? "Already Contacted"
                                          : "Contact",
                                      color: Color(0xffFBCD96),
                                      textColor: Colors.orange,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: (widget.device == "IOS") ? 80 : 30,
                              ),
                            ]),
                      ],
                    ),
                  ),
                ]),
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
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      contactUserPopUp(
                          widget.postId.toString(), _textController.text);
                      Navigator.pop(context);
                      await fetchuserProfile();
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
