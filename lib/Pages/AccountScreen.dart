import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madadguru/Pages/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madadguru/Pages/EnquaryScreen.dart';
import '../AllWidgets/buttons.dart';
import '../Allwidgets/AboutUs.dart';
import '../Allwidgets/ContactsScreen.dart';
import '../Allwidgets/Editprofile.dart';
import '../Allwidgets/FaqScreen.dart';
import 'package:share/share.dart';
import 'SubcriptionScreen.dart';

  class AccountScreen extends StatefulWidget {
  final String device;
  const AccountScreen({
    super.key,
    required this.device,
  });
  @override
  State<AccountScreen> createState() => _AccountScreenState();
   }
  class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController profileController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  String text = '';
  String subject = '';
  String uri = '';
  List<String> imageNames = [];
  List<String> imagePaths = [];
  String selectedGender = '';
  String need_help_in = '';
  bool isLoading = false;

  get switchesEnabled => false;

  @override
  void initState() {
    super.initState();
    // switchStates = List<bool>.filled(Data2.length, false);
    fetchMyProfile();
    }
  Map<String, dynamic> Mydata = {};
  Future<void> fetchMyProfile() async {
    setState(() {
      // isLoading = true;
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
            print("respons${userData}");
            setState(() {
              Mydata = Map<String, dynamic>.from(
                  userData); // Convert userData to Map
              nameController.text = Mydata['name'];
              gmailController.text = Mydata['email'];
              phoneController.text = Mydata['mobile'];
              selectedGender = Mydata['gender'];
              dobController.text = Mydata['dob'];
              _aboutController.text = Mydata['about'];
              fetchDatagetWant(Mydata['i_want']);

              isLoading = false;
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
      }
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
      if (Mydata.containsKey('i_want')) {
        setState(() {
           iwant = Mydata['i_want'];
      });
      print("i want's value: $iwant");
      }
     }
     void updateSwitchStates() {
      if (Mydata.containsKey('i_want')) {
      print('Updating switchStates based on i_want');
      setState(() {
        switchStates = List<bool>.filled(Data2.length, false);
        for (int i = 0; i < Data2.length; i++) {
          switchStates[i] = Mydata['i_want'].contains(Data2[i]['id'].toString());
           }
        print('Updated switchStates: $switchStates');
      });
    } else {
      print('i_want data not found');
      }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
            children: <Widget>[
          Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.orange.shade800,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 20),
                             child: CircleAvatar(
                              radius: 46,
                               backgroundColor: Colors.black38,
                                child: CircleAvatar(
                                 radius: 45,
                                   child:
                                   ClipOval(
                                     child:
                                     Image.network(
                                       Mydata['profile'] ?? '',
                                       fit: BoxFit.cover,
                                       width: 90.0, // adjust width as needed
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
                          SizedBox(
                            height: 10,
                                ),
                              Padding(
                               padding: EdgeInsets.only(left: 10.0),
                                 child: Text(
                                Mydata.containsKey('name')
                                    ? Mydata['name']
                                    : 'Name not available',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                                 ),
                             ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              Mydata.containsKey('profession')
                                  ? Mydata['profession']
                                  : 'Name not available',
                              // 'Greater Noida',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                            InkWell(
                              onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return EditProfile(
                                    device: widget.device,
                                  );
                                }),
                              ).whenComplete(() =>  fetchMyProfile());

                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40, right: 20),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            topLeft: Radius.circular(25),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 0.3, sigmaY: 0.3),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                              return AboutUs(
                                                                  device: widget
                                                                      .device);
                                                            }),
                                                          );
                                                        },
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(children: [
                                                                // Icon(Icons
                                                                //     .accessibility_sharp),
                                                                Image.asset(
                                                                  "assets/icon/info.png",
                                                                  width: 23,
                                                                  color: Color(
                                                                      0xffFF9228),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "About Us Madadguru",
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                )
                                                              ]),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 20,
                                                              )
                                                            ]),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                              return FAqScreen(
                                                                  device: widget
                                                                      .device);
                                                            }),
                                                          );
                                                        },
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(children: [
                                                                Image.asset(
                                                                  "assets/icon/information.png",
                                                                  width: 23,
                                                                  color: Color(
                                                                      0xffFF9228),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "Faq/Help",
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                )
                                                              ]),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 20,
                                                              ),
                                                            ]),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),

                                                      GestureDetector(
                                                        onTap: () {
                                                          Share.share(
                                                              'Share this amazing Application!');
                                                        },
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(children: [
                                                                Icon(
                                                                  Icons.share,
                                                                  color: Color(
                                                                      0xffFF9228),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "Share App",
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                )
                                                              ]),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 20,
                                                              )
                                                            ]),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      GestureDetector(
                                                        // onTap: () async {
                                                        //   Navigator.pop(
                                                        //       context);
                                                        //   Navigator.push(
                                                        //       context,
                                                        //       MaterialPageRoute(
                                                        //           builder:
                                                        //               (context) {
                                                        //     return Privacy_JobPreference(
                                                        //       device:
                                                        //           widget.device,
                                                        //     );
                                                        //   }));
                                                        // },
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(children: [
                                                                Icon(
                                                                  Icons.ac_unit,
                                                                  color: Color(
                                                                      0xffFF9228),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "Privacy Policy",
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                )
                                                              ]),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 20,
                                                              )
                                                            ]),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      GestureDetector(
                                                        // onTap: () async {
                                                        //   Navigator.pop(
                                                        //       context);
                                                        //   Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder:
                                                        //             (context) {
                                                        //       return Term_JobPreference(
                                                        //         device: widget
                                                        //             .device,
                                                        //       );
                                                        //     }),
                                                        //   );
                                                        // },
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(children: [
                                                                Image.asset(
                                                                  "assets/icon/choose.png",
                                                                  width: 23,
                                                                  color: Color(
                                                                      0xffFF9228),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "Term of Use",
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                )
                                                              ]),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 20,
                                                              )
                                                            ]),
                                                      ),
                                                      // const SizedBox(
                                                      //   height: 20,
                                                      // ),
                                                      // GestureDetector(
                                                      //   onTap: () async {
                                                      //     _ShowDialoguePop1();
                                                      //   },
                                                      //   child: Row(
                                                      //       mainAxisAlignment:
                                                      //           MainAxisAlignment
                                                      //               .spaceBetween,
                                                      //       children: [
                                                      //         Row(children: [
                                                      //           Image.asset(
                                                      //             "assets/icon/choose.png",
                                                      //             width: 23,
                                                      //             color: Color(
                                                      //                 0xffFF9228),
                                                      //           ),
                                                      //           SizedBox(
                                                      //             width: 20,
                                                      //           ),
                                                      //           Text(
                                                      //             "Contact Madadguru",
                                                      //             style:
                                                      //                 GoogleFonts
                                                      //                     .roboto(
                                                      //               textStyle:
                                                      //                   const TextStyle(
                                                      //                 color: Colors
                                                      //                     .black,
                                                      //                 fontSize:
                                                      //                     16,
                                                      //                 fontWeight:
                                                      //                     FontWeight
                                                      //                         .w500,
                                                      //               ),
                                                      //             ),
                                                      //           )
                                                      //         ]),
                                                      //         Icon(
                                                      //           Icons
                                                      //               .arrow_forward_ios,
                                                      //           size: 20,
                                                      //         )
                                                      //       ]),
                                                      // ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                        prefs.clear();
                                                        Navigator.push(context,
                                                          MaterialPageRoute(builder: (context)=> Login(device: widget.device,),
                                                        ),
                                                        );

                                                        },
                                                        child: Row(children: [
                                                          Image.asset(
                                                            "assets/icon/logout.png",
                                                            width: 23,
                                                            color: Colors
                                                                .red.shade400,
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            "LogOut",
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                    ]),
                                              ),
                                            );
                                          });
                                        });
                                  },
                                  icon: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return EnquaryScreen(
                                    device: widget.device,
                                  );
                                }),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Quick Help',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ContactsScreen(
                                    device: widget.device,
                                  );
                                }),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Contact ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            // onTap: () {
                            //   Navigator.pop(context);
                            // },
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
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Subscriptions',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              _ShowDialogue(context);
                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Community',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFF1E7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 14.0),
                    child: Text(
                      Mydata.containsKey('email')
                          ? Mydata['email']
                          : 'Name not available',
                      style: TextStyle(fontSize: 12),
                    ),
                    ),
                  ),
                  SizedBox(
                  height: 10,
                ),
                Text(
                  'Date of Birth',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFF1E7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 14.0),
                    child: Text(
                      Mydata.containsKey('dob')
                          ? Mydata['dob']
                          : 'Name not available',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Text(
                  'Gender',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFF1E7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 14.0),
                    child: Text(
                      Mydata.containsKey('gender')
                          ? Mydata['gender']
                          : 'Name not available',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Text(
                  'Phone Number',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFF1E7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 14.0),
                    child: Text(
                      Mydata.containsKey('mobile')
                          ? Mydata['mobile']
                          : 'Name not available',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Text(
                  'About',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFF1E7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 14.0),
                    child: Text(
                      Mydata.containsKey('about')
                          ? Mydata['about']
                          : 'Name not available',
                      style: TextStyle(fontSize: 12),
                    ),
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
                                // value:true,
                                autofocus: true,
                                value: switchStates[index],
                                onChanged: switchesEnabled ? (value) {
                                  setState(() {
                                    switchStates[index] = value;
                                    updateIWant();
                                  });
                                } : null,

                                activeTrackColor:
                                Colors.lightGreenAccent,
                                activeColor: Colors.green.shade200,
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

                // Text(
                //   "Need Help In:",
                //   // textAlign: TextAlign.center,
                //   style: GoogleFonts.roboto(
                //     color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 14,
                //   ),
                // ),
                //
                // SizedBox(
                //   height: 10,
                // ),
                // ===========================================   Choice Chips List        ========================================================


              ],
            ),
          ),
        ]),
      ),
    );
  }

  void _ShowDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Community',
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Container(
                height: 330,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Card(
                      elevation: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12
                              // bottomLeft: Radius.circular(32),
                              // bottomRight: Radius.circular(32),
                              ),
                          child:
                              // Image.network('')
                              Image.asset(
                            'assets/images/images.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(Uri.parse(
                            'https://www.facebook.com/socialservicesmadadguru/'));
                      },
                      child: ButtonWidget(
                        text: "Join Community",
                        color: const Color(0xffFF9228),
                        textColor: Colors.white,
                        width: 200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void launchFacebookURL() async {
    const facebookURL = 'https://www.facebook.com/socialservicesmadadguru/';
    if (await canLaunch(facebookURL)) {
      await launch(facebookURL);
    } else {
      print('Could not launch Facebook URL');
    }
  }


}

