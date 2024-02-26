import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
 bool isLoading=false;

  Map<String, dynamic> voluteerData = {};
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
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
              voluteerData = userData;
              fetchDatagetWant(voluteerData["i_want"]);
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
      }finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  // Map<String, dynamic> data = {};
  List<bool> switchStates = [];
  Map<String, dynamic> Data = {};
  List<dynamic> Data2 = [];
  String iwant = "";
  String needhelpin = "";
  // List<dynamic> department = [];
  // List<Map<String, dynamic>> DepartmentList = [];
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
    if (voluteerData.containsKey('i_want')) {
      setState(() {
        iwant = voluteerData['i_want'];
      });
      print("i want's value: $iwant");
    }
  }
  void updateSwitchStates() {
    // Update switchStates based on i_want value
    if (voluteerData.containsKey('i_want')) {
      print('Updating switchStates based on i_want');
      setState(() {
        switchStates = List<bool>.filled(Data2.length, false);
        for (int i = 0; i < Data2.length; i++) {
          switchStates[i] = voluteerData['i_want'].contains(Data2[i]['id'].toString());
        }
        print('Updated switchStates: $switchStates');
      });
    } else {
      print('i_want data not found');
    }
    // Update department based on i_need_help value
    if (voluteerData.containsKey('i_need_help')) {
      // setState(() {
      //   department = DepartmentList.where(
      //           (item) => voluteerData['i_need_help'].contains(item['id'].toString()))
      //       .toList();
      // });
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
                            (voluteerData["name"] != null)
                                ? voluteerData["name"]
                                : 'Name not available',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          (voluteerData["email"] != null)
                              ? voluteerData["email"]
                              : 'email not available',
                          // "Gmail : email@123456@gmail.com",
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
                          "Mobile: ${(voluteerData["mobile"] != null) ? voluteerData["mobile"] : 'mobile not available'}",

                          // "+918877665544",
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
                          "Dob: ${(voluteerData["dob"] != null) ? voluteerData["dob"] : 'dob not available'}",
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
                          (voluteerData["profession"] != null)
                              ? voluteerData["profession"]
                              : 'profession not available',
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
                                "Gender: ${(voluteerData["gender"] != null) ? voluteerData["gender"] : 'gender not available'}",
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
                                "Language: ${(voluteerData["language"] != null) ? voluteerData["language"] : 'gender not available'}",
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
                      backgroundColor: Colors.black38,
                      child: Center(
                        child: CircleAvatar(
                          radius: 45,
                          child: ClipOval(
                            child: voluteerData.containsKey('profile')
                                ? Image.network(
                                    voluteerData['profile'],
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
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
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
                        (voluteerData["about"] != null)
                            ? voluteerData["about"]
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
                        "I want:",
                        // textAlign: TextAlign.center,
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
                        choiceItems: C2Choice.listFrom<dynamic, dynamic>(
                          source: DepartmentList,
                          value: (index1, item) => DepartmentList[index1]['id'],
                          label: (index1, item) =>
                              DepartmentList[index1]['filterValue'],
                        ),
                        value: department,
                        onChanged: (val) => setState(() => department = val),
                        choiceCheckmark: true,
                        choiceStyle: C2ChipStyle.outlined(
                          color: Color(0xFFA2A09D),
                          checkmarkColor: Colors.white,
                          foregroundStyle: const TextStyle(
                              color: Color(0xFF2F2924), fontSize: 12),
                          selectedStyle: C2ChipStyle.filled(
                            foregroundStyle:
                                TextStyle(color: Colors.white, fontSize: 12),
                            color: Color(0xff655D53),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        wrapped: true,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return SubcriptionScreen(
                                device: widget.device,

                              );
                            }),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, top: 20, bottom: 20),
                          child: Card(
                            elevation: 2,
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xffFBCD96)),
                              child: Center(
                                child: Text(
                                  'Unlock Contact',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
