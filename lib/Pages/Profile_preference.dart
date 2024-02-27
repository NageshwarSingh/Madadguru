import 'dart:convert';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madadguru/Allwidgets/background_screen.dart';
import '../Allwidgets/BottomNavBar.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//Screen Need_Help

class ProfilePreference extends StatefulWidget {
  final String device;
  const ProfilePreference({super.key, required this.device});
  @override
  State<ProfilePreference> createState() => _ProfilePreferenceState();
}
class _ProfilePreferenceState extends State<ProfilePreference> {
  bool isLoading = false;
  String needhelpin = "";
  List<dynamic> department = [];
  List<Map<String, dynamic>> DepartmentList = [];

  Future<void> ProfileSelectedAPI(String value) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/updateProfile");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
          body: {
            "need_help_in": needhelpin,
          },
        );
        print(" response${response}");
        if (response.statusCode == 200) {
          print(response.body);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MySplashScreen(
                  device: widget.device,
                ),
              ),
              (route) => false);

          print('need_help_in selection sent to API successfully.');
        } else {
          print(
              'Failed to send need_help_in selection to API. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error sending need_help_in selection to API: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
      }
     }

  @override
  void initState() {
    super.initState();
    // Call API to get data and initialize switches
    getNeedfetchData();
  }

  Future<void> getNeedfetchData() async {
    setState(() {
      isLoading = true;
    });
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
          });
          print('DepartmentList: $DepartmentList');
          print('Data fetched successfully');
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
      finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
            SafeArea(
              child: isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 4,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, bottom: 15),
                            padding: const EdgeInsets.only(bottom: 7),
                            alignment: Alignment.center,
                            height: 50,
                            width: 180,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/rectangle.png"),
                                //    fit: BoxFit.fill
                              ),
                            ),
                            child: Text(
                              "Need Help In:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: const Color(0xFF524B6B),
                              ),
                            ),
                          ),
                          ChipsChoice<dynamic>.multiple(
                            choiceItems: DepartmentList.isNotEmpty
                                ? C2Choice.listFrom<dynamic, dynamic>(
                              source: DepartmentList,
                              value: (index1, item) => item["id"].toString(),
                              label: (index1, item) => item["name"].toString(),
                            )
                                : [], // Provide an empty list as a fallback
                            value: department
                                .map((item) => item['id'].toString())
                                .toList(),
                            onChanged: (List<dynamic> val) {
                              setState(() {
                                department = DepartmentList.where((item) =>
                                    val.contains(item['id'].toString())).toList();
                                needhelpin = department
                                    .map((item) => item['id'].toString())
                                    .join(',');
                              });
                            },
                            choiceCheckmark: true,
                            choiceStyle: C2ChipStyle.outlined(
                              color: Color(0xFFA2A09D),
                              checkmarkColor: Colors.white,
                              foregroundStyle: const TextStyle(
                                color: Color(0xFF2F2924),
                                fontSize: 12,
                              ),
                              selectedStyle: C2ChipStyle.filled(
                                foregroundStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                color: Color(0xff655D53),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            wrapped: true,
                          ),



                          // ChipsChoice<dynamic>.multiple(
                          //   choiceItems: C2Choice.listFrom<dynamic, dynamic>(
                          //     source: DepartmentList,
                          //     value: (index1, item) => item["id"].toString(),
                          //     label: (index1, item) => item["name"].toString(),
                          //   ),
                          //
                          //   value: department
                          //       .map((item) => item['id'].toString())
                          //       .toList(),
                          //   onChanged: (List<dynamic> val) {
                          //     setState(() {
                          //       department = DepartmentList.where((item) =>
                          //               val.contains(item['id'].toString()))
                          //           .toList();
                          //       needhelpin = department
                          //           .map((item) => item['id'].toString())
                          //           .join(',');
                          //     });
                          //
                          //     // ProfileSelectedAPI(department);
                          //   },
                          //
                          //   // onChanged: (val) => setState(() => DepartmentList = val),
                          //   choiceCheckmark: true,
                          //   choiceStyle: C2ChipStyle.outlined(
                          //     color: Color(0xFFA2A09D),
                          //     checkmarkColor: Colors.white,
                          //     foregroundStyle: const TextStyle(
                          //         color: Color(0xFF2F2924), fontSize: 12),
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
                          //   // onChanged: (List<dynamic> value) {
                          //
                          //   // },
                          // ),
                          SizedBox(
                            height: 40,
                          ),
                        ]),
                  ),
          ),
          Positioned(
            right: 10,
            bottom: 40,
            child: GestureDetector(
              onTap: () {
                ProfileSelectedAPI(needhelpin);
                // Navigate to the second page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //
                //       builder: (context) =>
                //       // BottomNavBar
                //     MySplashScreen(
                //         device: widget.device,
                //       ),
                //   ),
                // );
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
        ],
      ),
    );
  }
}
