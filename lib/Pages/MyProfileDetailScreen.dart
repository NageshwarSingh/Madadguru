import 'dart:async';
import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AllWidgets/buttons.dart';
import 'package:http/http.dart' as http;

class MyProfileDetailScreen extends StatefulWidget {
  final String device;
  const MyProfileDetailScreen({
    super.key,
    required this.device,
  });
  @override
  State<MyProfileDetailScreen> createState() => _MyProfileDetailScreenState();
}

class _MyProfileDetailScreenState extends State<MyProfileDetailScreen> {
  int segmentedControlValue = 0;
  Map JobDetail = {};
  Map<String, dynamic> data = {};

  List<dynamic> department = [];

  List<bool> switchStates = [];
  String iwant = "";
  String needhelpin = "";
  List<Map<String, dynamic>> DepartmentList = [];
  Map<String, dynamic> Data = {};
  List<dynamic> Data2 = [];
  @override
  void initState() {
    super.initState();
    switchStates = List<bool>.filled(Data2.length, false);
    fetchDataMyProfile();
        }

        // ==============      *************    MyProfile    *************      ================

    Future<void> fetchDataMyProfile() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
     if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/myProfile");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("object $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            // setState(() async {
            //   data = Map<String, dynamic>.from(userData);
            //   department = userData['need_help_in'].split(',').map((e) => int.parse(e)).toList();
            //   print("department : ${department}");
            //   await fetchDataNeedHelp(data['need_help_in']);
            //   await fetchDatagetWant(data['i_want']);
            //   updateSwitchStates();
            //   isLoading = false;
            // })
            setState(() async {
              data = Map<String, dynamic>.from(userData);
             List<String> departmentIds = data['need_help_in'].split(',');
              departmentIds = departmentIds.map((e) => e.trim()).toList();
              departmentIds.forEach((departmentId) {
                DepartmentList.forEach((departmentItem) {
                  if (departmentItem['id'].toString() == departmentId) {
                    departmentItem['isSelected'] = true;
                  }
                   });
                  });
              await fetchDataNeedHelp(data['need_help_in']);
              await fetchDatagetWant(data['i_want']);
              updateSwitchStates();
              isLoading = false;
            });
            print('Data fetched successfully');
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
           }
          }
        }
// ==============        *******     Get Want Api   *******          ============

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
    if (data.containsKey('i_want')) {
      setState(() {
        iwant = data['i_want'];
      });
      print("i want's value: $iwant");
    }
  }

  void updateSwitchStates() {
    // Update switchStates based on i_want value
    if (data.containsKey('i_want')) {
      print('Updating switchStates based on i_want');
      setState(() {
        switchStates = List<bool>.filled(Data2.length, false);
        for (int i = 0; i < Data2.length; i++) {
          switchStates[i] = data['i_want'].contains(Data2[i]['id'].toString());
        }
        print('Updated switchStates: $switchStates');
      });
    } else {
      print('i_want data not found');
    }
    // Update department based on i_need_help value
    // if (data.containsKey('i_need_help')) {
    //   setState(() {
    //     department = DepartmentList.where(
    //             (item) => data['i_need_help'].contains(item['id'].toString()))
    //         .toList();
    //   });
    // }
  }

  void onChangedSwitch(int index, bool value) {
    setState(() {
      switchStates[index] = value;
      updateIWant(); // Update i_want value
    });
  }
  void onChangedSwitches(int index, bool value) {
    setState(() {
      department[index] = value;
      updateIWant(); // Update i_want value
    });
  }

  bool isLoading = false;
  // ==============         *******   Need Help Api   ******          ============
  Future<void> fetchDataNeedHelp(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getNeedHelp");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          List<dynamic> data = responseData['data'] ?? [];
          setState(() {
            DepartmentList = data
                .map((item) => {
                      'id': item['id'],
                      'name': item['name'],
                    })
                .toList();
            department=data
                .map((item) => {
              'id': item['id'],

            })
                .toList();




          });
          print('DepartmentList: $DepartmentList');
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
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching data: $error');
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
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
                      child: Column(
                        children: [
                          Text(
                            data.containsKey('name') && data['name'] != null
                                ? data['name']
                                : '',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          // Text(
                          //   data.containsKey('name')
                          //       ? data['name']
                          //       : 'Name not available',
                          //   style: GoogleFonts.roboto(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w600,
                          //     color: Colors.black,
                          //   ),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            data.containsKey('email')
                                ? data['email']
                                : 'Name not available',
                            // "Email: email12346@gmail.com",
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
                            "Mobile: ${data.containsKey('mobile') ? data['mobile'] : 'Name not available'}",
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
                            "Dob: ${data.containsKey('dob') ? data['dob'] : 'Name not available'}",
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
                            data.containsKey('profession')
                                ? data['profession']
                                : "Name not available",
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
                                  "Gender: ${data.containsKey('gender') ? data['gender'] : 'Name not available'}",
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
                                  "Language: ${data.containsKey("language") ? data['language'] : "Name not available"}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff096001),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -40,
                      left: MediaQuery.of(context).size.width / 2.7,
                      child: CircleAvatar(
                        radius: 46.5,
                        backgroundColor: Colors.black,
                        child: Center(
                          child: CircleAvatar(
                            radius: 46,
                            backgroundColor: Colors.black38,
                            child: CircleAvatar(
                              radius: 45,
                              child: ClipOval(
                                child: data.containsKey('profile')
                                    ? Image.network(
                                        data['profile'],
                                        fit: BoxFit.cover,
                                        width: 90.0, // adjust width as needed
                                        height: 90.0, // adjust height as needed
                                        )
                                    : Icon(
                                        Icons.person,
                                        size: 20,
                                        color: Colors.grey[400],
                                      ),
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
                                  data.containsKey('about')
                                      ? data['about']
                                      : 'Name not available',
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
                                ChipsChoice<dynamic>.multiple(

                                  choiceItems:
                                      C2Choice.listFrom<dynamic, dynamic>(
                                    source: DepartmentList,
                                    value: (index1, item) =>
                                        item["id"].toString(),
                                    label: (index1, item) =>
                                        item["name"].toString(),
                                  ),
                                  value:  department,

                                  onChanged: (val) {
                                    setState(() {
                                      department = val;

                                      // department = DepartmentList.where(
                                      //     (item) => val.contains(
                                      //         item['id'].toString())).toList();
                                      // needhelpin = val.join(',');
                                      // updateSwitchStates();
                                    });
                                    print(department);
                                  },
                                  choiceCheckmark: true,
                                  choiceStyle: C2ChipStyle.outlined(
                                    color: Color(0xFFA2A09D),
                                    checkmarkColor: Colors.white,
                                    foregroundStyle: const TextStyle(
                                        color: Color(0xFF2F2924), fontSize: 12),
                                    selectedStyle: C2ChipStyle.filled(
                                      foregroundStyle: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      color: Color(0xff655D53),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  wrapped: true,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialogue();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40.0),
                                    child: ButtonWidget(
                                      text: " Contact",
                                      color: Color(0xffFBCD96),
                                      textColor: Colors.orange,
                                      width: MediaQuery.of(context).size.width,
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
      ),
    );
  }

  void showDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Your Request'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextField(
                    maxLines: 5,
                    // controller: _professionController,
                    decoration: InputDecoration(
                      hintText: 'Text here....',
                      // label: Text('/'),
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
                          left: 10, right: 10, bottom: 10, top: 10),
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
                    onTap: () {
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
  }
}
