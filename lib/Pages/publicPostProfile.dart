import 'dart:convert';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Map JobDetail = {};

  Map profileData = {};
  TextEditingController _textController = TextEditingController();
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
        final response = await http.post(uri,
            headers: {
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
          final Uri uri = Uri.parse("https://madadguru.webkype.net/api/addUserContact");
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
            print('API request failed with status code: ${response.statusCode}');
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


  // Map<String, dynamic> data = {};
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
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //       builder: (context) => ProfilePreference(
          //         device: widget.device,
          //       ),
          //     ),
          //         (route) => false);
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
    // Update switchStates based on i_want value
    if (userData.containsKey('i_want')) {
      print('Updating switchStates based on i_want');
      setState(() {
        switchStates = List<bool>.filled(Data2.length, false);
        for (int i = 0; i < Data2.length; i++) {
          switchStates[i] = userData['i_want'].contains(Data2[i]['id'].toString());
        }
        print('Updated switchStates: $switchStates');
      });
    } else {
      print('i_want data not found');
    }
    // Update department based on i_need_help value
    if (userData.containsKey('i_need_help')) {
      setState(() {
        department = DepartmentList.where(
                (item) => userData['i_need_help'].contains(item['id'].toString()))
            .toList();
      });
    }
  }
  void onChangedSwitch(int index, bool value) {
    setState(() {
      switchStates[index] = value;
      updateIWant(); // Update i_want value
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
                            // "Email: email12346@gmail.com",
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
                            // "Phone : +918877665544",
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
                            "Dob: ${(userData["dob"] != null) ?
                            userData["dob"] : "dob not available"}",
                            // "DOB : 12/12/1999",
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
                            // "Profession: Lowyer",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text(
                          //   "Location - Greater Noida",
                          //   style: GoogleFonts.roboto(
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //     color: Colors.black,
                          //   ),
                          // ),
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
                                    "Gender: ${(userData["gender"] != null) ?
                                    userData["gender"] : "dob not available"}",

                                    // "Gender: Female",
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
                                      "Language: ${(userData["language"] != null)
                                          ? userData["language"] : "dob not available"}",

                                      // "Language: English",
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
                                child: userData.containsKey('profile')
                                    ? Image.network(
                                        userData['profile'],
                                        fit: BoxFit.cover,
                                        width: 90.0, // adjust width as needed
                                        height: 90.0, // adjust height as needed
                                      )
                                       : Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey[400],
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "About",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    (userData["about"] != null)
                                        ? userData["about"]
                                        : 'about not available',
                                    // "Delivery drivers are responsible for transporting goods from distribution centers to customers. They follow a specified schedule and identify the most efficient routes to avoid delays. They also conduct regular vehicle check-ups and maintenance to keep company vehicles in good working condition.",
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
                                    "I want",
                                    // textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
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
                                            borderRadius:
                                            BorderRadius.circular(12),
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
                                                  value: switchStates[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      switchStates[index] =
                                                          value; // Update switch state
                                                      updateIWant(); // Update i_want value
                                                    });
                                                  }, // Call onChangedSwitch method
                                                  activeTrackColor:
                                                  Colors.lightGreenAccent,
                                                  activeColor: Colors.green,
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
                                  Text(
                                    "Need Help In:",
                                    // textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // ChipsChoice<dynamic>.multiple(
                                  //   choiceItems:
                                  //       C2Choice.listFrom<dynamic, dynamic>(
                                  //     source: DepartmentList,
                                  //     value: (index1, item) =>
                                  //         DepartmentList[index1]['id'],
                                  //     label: (index1, item) =>
                                  //         DepartmentList[index1]['filterValue'],
                                  //   ),
                                  //   value: department,
                                  //   onChanged: (val) =>
                                  //       setState(() => department = val),
                                  //   choiceCheckmark: true,
                                  //   choiceStyle: C2ChipStyle.outlined(
                                  //     color: Color(0xFFA2A09D),
                                  //     checkmarkColor: Colors.white,
                                  //     foregroundStyle: const TextStyle(
                                  //         color: Color(0xFF2F2924),
                                  //         fontSize: 12),
                                  //     selectedStyle: C2ChipStyle.filled(
                                  //       foregroundStyle: TextStyle(
                                  //           color: Colors.white, fontSize: 12),
                                  //       color: Color(0xff655D53),
                                  //       borderRadius: BorderRadius.all(
                                  //         Radius.circular(10),
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   wrapped: true,
                                  // ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
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
                                                        contentPadding: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            // bottom: 10,
                                                            top: 10),
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
                                                      // onTap: () {
                                                      //   addPostEnquiryPopUp(widget.postId.toString(),
                                                      //       _textController.text);
                                                      //   Navigator.pop(context);
                                                      // },
                                                      onTap: () {
                                                              contactUserPopUp(widget.postId.toString(),
                                                            _textController.text);
                                                            Navigator.pop(context);
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
                                      // _ShowDialoguePopText(jsonData['id']);
                                      // Navigator.pop(context);
                                    },
                                    // onTap: () {
                                    //
                                    //
                                    //
                                    //   Navigator.pop(context);
                                    //
                                    //   // Navigator.push(
                                    //   //   context,
                                    //   //   MaterialPageRoute(builder: (context) {
                                    //   //     return (
                                    //   //       device: widget.device, Device: '' ,
                                    //   //     );
                                    //   //   }),
                                    //   // );
                                    // },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30.0),
                                      child: ButtonWidget(
                                        text: " Contact",
                                        color: Color(0xffFBCD96),
                                        textColor: Colors.orange,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: (widget.device == "IOS") ? 80 : 30,
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
        ));
  }
}
