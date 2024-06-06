import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:madadguru/Allwidgets/textForm_filed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final String device;
  EditProfile({
    super.key,
    required this.device,
  });
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobilController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _iwantController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  bool isSignningIn = false;
  bool isActivate = false;
  bool isActivate1 = true;
  File? imageFile;
  var Gender;
  var Profession;
  var Listiwant=[
    "Legal Advice",
    "Banking & Loan",
    "Police & Court Related"
  ];
  var profession = [
    'Private',
    'Gort Job',
    'Business',
    'Student',
    'House Wife',
    'Un-Employed',
    'NGO Worker',
    'Other',
  ];
  var gender = ["Male", "Female", "Other"];
  Map<String, dynamic> data = {};
  bool isLoading = false;
  // Map<String, dynamic> Data = {};
  // List<dynamic> Data2 = [];
  // List<bool> switchStates = [];

  // get switchesEnabled => true;
  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
    // fisrt call myProfilre Api
    MyProfile();
    fetchData();
    //update Button click
    // updateProfile();
  }

  Map<String, dynamic> Mydata = {};

//  ======================    ***************    My  Profile   Api    **************   ===========================

  Future<void> MyProfile() async {
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
          // body: {},
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("object $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            print("respons${userData}");
            setState(() {
              Mydata = Map<String, dynamic>.from(userData);
              // Mydata = Map<String, dynamic>.from(
              //     userData); // Convert userData to Map
              // // Update controllers or variables with API response data
              _nameController.text = Mydata['name'];
              _emailController.text = Mydata['email'];
              _mobilController.text = Mydata['mobile'];
              _dobController.text = Mydata['dob'];
              _aboutController.text = Mydata['about'];
              _professionController.text = Mydata['profession'];
              _iwantController.text = Mydata['i_want'];
              _genderController.text = Mydata['gender'];
               professionList = Mydata['professions'] ?? [];

              // _aboutController.text = Mydata['about'];
              // fetchDatagetWant(Mydata['i_want']);

              // switchStates = List<bool>.filled(DepartmentList.length, false);
              // if (data['i_want'] is List) {
              //   for (var iWantId in data['i_want']) {
              //     var index = DepartmentList.indexWhere(
              //         (item) => item['id'] == iWantId);
              //        if (index != -1) {
              //       switchStates[index] = true;
              //       }
              //     }
              //   }
              // if (data['need_help_in'] is List) {
              //   department = List<dynamic>.from(data['need_help_in']);
              // }
              getProfessionApi();
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

  // void updateIWant() {
  //   List<int> selectedIds = [];
  //   for (int i = 0; i < switchStates.length; i++) {
  //     if (switchStates[i]) {
  //       selectedIds.add(Mydata[i]['id']);
  //     }
  //   }
  //   String iWantString = selectedIds.join(',');
  //   setState(() {
  //     Mydata['i_want'] = iWantString;
  //   });
  // }

//  ===========    *****    Update  Profile   Api    *******      ==========

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    final Uri uri =
        Uri.parse("https://madadguru.webkype.net/api/updateProfile");
    var request = http.MultipartRequest('Post', uri);
    Map<String, String> headers = {
      "Accept": "multipart/form-data",
      "Authorization": 'Bearer $usertoken',
    };
    request.headers.addAll(headers);
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('profile', imageFile!.path));
    }
    request.fields['about'] = _aboutController.text;
    request.fields['gender'] = _genderController.text;
    request.fields['name'] = _nameController.text;
    request.fields['mobile'] = _mobilController.text;
    request.fields['dob'] = _dobController.text;
    request.fields['email'] = _emailController.text;
    request.fields['profession'] = _professionController.text;
    request.fields['language'] = "";
    request.fields['i_want'] = iwant;
    request.fields['need_help_in'] = "";
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          data = responseData;
          isLoading = false;
        });
        print(responseData);
        // Navigator.pop(context);
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making HTTP request: $error');
    }
    //  finally {
    // setState(() {
    //   isLoading =
    //       false; // Set isLoading to false after the API call completes
    // });
    // }
  }

  List<dynamic> department = [];
  Map<String, dynamic>? selectedProfession;
  List<Map<String, dynamic>> professionList = [];

  Future<void> getProfessionApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getProfession");
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
            professionList = data
                .map((item) => {
                      'id': item['id'].toString(),
                      'name': item['name'],
                    })
                .toList();
          });
          print('professionList: $professionList');
          print('Data fetched successfully');
          print(response.body);

          // if (professionList.isNotEmpty) {
          //   selectedCategoryId = CategoryList[0]['id']; // Set the selected category id
          //   fetchDataTopic(selectedCategoryId);
          // }
          print('Data fetched successfully');
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching data: $error');
      }
    }
  }



// =============************========   ============== Api  getWant   ===========******************==================================
  List switchStates = [];
  String iwant ="";
  // bool isLoading=false;
  Map<String, dynamic> Data = {};

  List<dynamic> Data2 = [];
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
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
            switchStates = List.generate(Data2.length, (index) => false);
            print("data from api is $Data");
            isLoading = false;
          });
          // if (jData['data'] != null) {
          //   initializeSwitches(jData['data']);
          //
          // }

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


  void updateIWant() {
    List<String> selectedItems = [];
    for (int i = 0; i < switchStates.length; i++) {
      if (switchStates[i]) {
        selectedItems.add(Data2[i]['id'].toString());
      }
    }
    setState(() {
      iwant = selectedItems.join(',');
    });
    print("i want's value here: $iwant");
  }
//
//   String iwant = "";
//   Future<void> fetchDatagetWant(String activeValues) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var usertoken = prefs.getString('token');
//     if (usertoken != null) {
//       final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getWant");
//       try {
//         final response = await http.post(
//           uri,
//           headers: {
//             'Authorization': 'Bearer $usertoken',
//           },
//         );
//         if (response.statusCode == 200) {
//           var jData = json.decode(response.body);
//           setState(() {
//             Data = jData;
//             Data2 = Data['data'];
//             switchStates = List<bool>.filled(Data2.length, false);
//             for (int i = 0; i < Data2.length; i++) {
//               if (activeValues.contains(Data2[i]['id'].toString())) {
//                 switchStates[i] = true;
//               }
//             }
//             switchStates = List.generate(Data2.length, (index) => false);
//             updateSwitchStates();
//             print("Data From Api$Data");
//           });
//           print(response.body);
//
//           print('Data fetched successfully');
//         } else {
//           print('Failed to fetch Data. Status code: ${response.statusCode}');
//         }
//       } catch (error) {
//         print('Error fetching data: $error');
//       }
//     }
//   }
//
//   void updateIWant() {
//     if (Mydata.containsKey('i_want')) {
//       setState(() {
//         iwant = Mydata['i_want'];
//       });
//       print("i want's value: $iwant");
//     }
//   }
//
//   void updateSwitchStates() {
//     if (Mydata.containsKey('i_want')) {
//       print('Updating switchStates based on i_want');
//       setState(() {
//         switchStates = List<bool>.filled(Data2.length, false);
//         for (int i = 0; i < Data2.length; i++) {
//           switchStates[i] =
//               Mydata['i_want'].contains(Data2[i]['id'].toString());
//         }
//         print('Updated switchStates: $switchStates');
//       });
//     } else {
//       print('i_want data not found');
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
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
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    await _getFromCamera();
                                                  },
                                                  child: Row(children: [
                                                    Icon(
                                                      Icons.camera_alt_outlined,
                                                      color: Colors.blue,
                                                    ),
                                                    // Image.asset(
                                                    //   "assets/icons/photo-camera-interface-symbol-for-button.png",
                                                    //   width: 25,
                                                    //   color: Colors.black54,
                                                    // ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      "Take Photo",
                                                      style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    await _getFromGallery();
                                                  },
                                                  child: Row(children: [
                                                    Image.asset(
                                                      "assets/images/gallery.png",
                                                      width: 25,
                                                      color: Colors.blue,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      "Select from gallery",
                                                      style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ]),
                                        ),
                                      );
                                    });
                                  });
                            },
                            child: Stack(clipBehavior: Clip.none, children: [
                              (imageFile == null)
                                  ? CircleAvatar(
                                      radius: 45,
                                      child: ClipOval(
                                        child: Image.network(
                                          Mydata['profile'] ?? '',
                                          // 'assets/images/people.webp',
                                          fit: BoxFit.cover,
                                          width: 90.0, // adjust width as needed
                                          height: 90.0,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.grey[400],
                                            );
                                          }, // adjust height as needed
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 45,
                                      child: ClipOval(
                                        child: Image.file(
                                          imageFile!,
                                          // 'assets/images/people.webp',
                                          fit: BoxFit.cover,
                                          width: 90.0, // adjust width as needed
                                          height:
                                              90.0, // adjust height as needed
                                        ),
                                      ),
                                    ),
                              Positioned(
                                bottom: 10,
                                right: -5,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      Color(0xffFF9228).withOpacity(0.7),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    // width: 16,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Name",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFEADD),
                          ),
                          child: TextFormFieldWidget1(
                            cursorColor: Color(0xffFF9228),
                            controller: _nameController,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            obscureText: false,
                            hintText: "Enter Name",
                            // labeltext: 'Enter your old password',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Mobile",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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
                            color: Color(0xffFFEADD),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 15,
                            ),
                            child: Text(
                              _mobilController.text.isNotEmpty
                                  ? _mobilController.text
                                  : 'Loading...',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          // TextFormFieldWidget1(
                          //   cursorColor: Color(0xffFF9228),
                          //   controller: _mobilController,
                          //   inputType: TextInputType.number,
                          //   inputAction: TextInputAction.next,
                          //   obscureText: false,
                          //   hintText: "Enter Mobile",
                          //   // labeltext: 'Enter your old password',
                          // ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFEADD),
                          ),
                          child: TextFormFieldWidget1(
                            cursorColor: Color(0xffFF9228),
                            controller: _emailController,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            obscureText: false,
                            hintText: "Enter Email",
                            // labeltext: 'Enter your old password',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Gender",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 7),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // border: Border.all(width: 1.5, color: Colors.orange),
                            color: Color(0xffFFEADD),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.orange),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                value: Gender,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: Colors.black38,
                                ),
                                hint: Text(
                                  _genderController.text.isNotEmpty
                                      ? _genderController.text
                                      : 'Loading...',
                                  // gender ?? 'Loading',
                                  // Gender != null ? Gender : 'Select Gender',
                                  // widget.gender,

                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                elevation: 1,
                                underline:
                                    Container(height: 1, color: Colors.orange),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    Gender = newValue!;
                                    _genderController.text = newValue;
                                  });
                                },
                                items: gender.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Date Of Birth",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFFEADD),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            readOnly: true,
                            cursorColor: Color(0xffFF9228),
                            obscureText: false,
                            controller: _dobController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  DateTime currentDate = DateTime.now();
                                  DateTime firstAllowedDate = DateTime(
                                      currentDate.year -
                                          100); // Restrict to 100 years ago
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: currentDate,
                                    firstDate: firstAllowedDate,
                                    lastDate: currentDate,
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _dobController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.black38,
                                  size: 23,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              hintText: "Date Of Birth",
                              hintStyle: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black38),
                            ),
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Profession",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          padding: EdgeInsets.only(left: 7),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xffFFEADD),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Map<String, dynamic>>(
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.orange,
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                value: selectedProfession,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: Colors.black38,
                                ),
                                hint: Text(
                                  _professionController.text.isNotEmpty
                                      ? _professionController.text
                                      : 'Loading...',
                                  // "Profession",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                elevation: 1,
                                onChanged: (Map<String, dynamic>? newValue) {
                                  setState(() {
                                    selectedProfession = newValue;
                                    _professionController.text =
                                        newValue?['name'] ?? '';
                                  });
                                },
                                // Check if professionList is not null and build dropdown items
                                items: professionList.map<
                                    DropdownMenuItem<Map<String, dynamic>>>(
                                  (Map<String, dynamic> profession) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: profession,
                                      child: Text(
                                        profession['name'].toString(),
                                        style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "About",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFFEADD),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            style: TextStyle(fontSize: 12),
                            maxLines: 3,
                            controller: _aboutController,
                            decoration: InputDecoration(
                              hintText: 'Enter the text here',
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Colors.black38),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10, top: 10),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              // Handle text changes
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                          height: 15,
                             ),
                        _buildListView(),
                            // ListView.builder(
                        //     scrollDirection: Axis.vertical,
                        //     // itemCount: Data.length,
                        //     shrinkWrap: true,
                        //     padding: EdgeInsets.zero,
                        //     itemCount: 4,
                        //     itemBuilder: (context, index) {
                        //   // if (index >= Data2.length) {
                        //   //   return Container();
                        //   // }
                        //       return  Image.asset('assets/images/icon.png');
                        //         // Container(
                        //         // child: Row(
                        //         //
                        //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         //   children: [
                        //         //     Row(
                        //         //       children: [
                        //         //         Image.asset('assets/images/icon.png'),
                        //         //         Text('jfnjnfjnf',
                        //         //           // Data2[index]['name'].toString(), // Use data from your Data list
                        //         //           style: TextStyle(
                        //         //             fontSize: 14,
                        //         //           ),
                        //         //         ),
                        //         //       ],
                        //         //     ),
                        //         //   ],
                        //         // ),);
                        // }),

                        //
                        //
                        //     ListView.builder(
                        //   scrollDirection: Axis.vertical,
                        //   itemCount: Data2.length,
                        //   shrinkWrap: true,
                        //   padding: EdgeInsets.zero,
                        //   itemBuilder: (context, index) {
                        //     final item = Data2[index];
                        //     final itemId = item['id'];
                        //     final bool isActive = Mydata != null && Mydata['i_want'] != null && Mydata['i_want'].toString().split(',').contains(itemId.toString());
                        //     return ListTile(
                        //       title: Container(
                        //         padding: EdgeInsets.zero,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(12),
                        //           border: Border.all(width: 1, color: Colors.orange),
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(left: 5, right: 5.0),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Image.asset('assets/images/icon.png'),
                        //                   // Text(
                        //                   //   item['name'].toString(),
                        //                   //   style: TextStyle(fontSize: 14),
                        //                   // ),
                        //                 ],
                        //               ),
                        //               Switch(
                        //                 value: isActive,
                        //                 onChanged: switchesEnabled ? (value) {
                        //                   setState(() {
                        //                     if (value) {
                        //                       Mydata['i_want'] = (Mydata['i_want'] != null ? Mydata['i_want'].toString() + ',' : '') + itemId.toString();
                        //                     } else {
                        //                       final List<String> iWantValues = Mydata['i_want'] != null ? Mydata['i_want'].toString().split(',') : [];
                        //                       iWantValues.remove(itemId.toString());
                        //                       Mydata['i_want'] = iWantValues.join(',');
                        //                     }
                        //                     updateIWant();
                        //                   });
                        //                 } : null,
                        //                 activeTrackColor: Colors.lightGreenAccent,
                        //                 activeColor: Colors.green.shade200,
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        //
                        //

                        // ListView.builder(
                        //   scrollDirection: Axis.vertical,
                        //   itemCount: Data.length,
                        //   shrinkWrap: true,
                        //   padding: EdgeInsets.zero,
                        //   itemBuilder: (context, index) {
                        //     if (index >= Data2.length) {
                        //       return Container();
                        //     }
                        //     return ListTile(
                        //       title: Container(
                        //         padding: EdgeInsets.zero,
                        //         decoration: BoxDecoration(
                        //           borderRadius:
                        //           BorderRadius.circular(12),
                        //           border: Border.all(
                        //               width: 1, color: Colors.orange),
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(
                        //               left: 5, right: 5.0),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Image.asset(
                        //                       'assets/images/icon.png'),
                        //                   Text(
                        //                     Data2[index]['name']
                        //                         .toString(),
                        //                     style:
                        //                     TextStyle(fontSize: 14),
                        //                   ),
                        //                 ],
                        //               ),
                        //
                        //               Switch(
                        //                 // value:true,
                        //                 autofocus: true,
                        //                 value: switchStates[index],
                        //                 onChanged: switchesEnabled ? (value) {
                        //                   setState(() {
                        //                     switchStates[index] = value;
                        //                     updateProfile();
                        //                   });
                        //                 } : null,
                        //
                        //                 activeTrackColor:
                        //                 Colors.lightGreenAccent,
                        //                 activeColor: Colors.green.shade200,
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),

                        //   ListView.builder(
                        //   scrollDirection: Axis.vertical,
                        //   itemCount: Mydata != null ? Mydata.length : 0, // Add a null check here
                        //   shrinkWrap: true,
                        //   padding: EdgeInsets.zero,
                        //   itemBuilder: (context, index) {
                        //     if (Mydata == null || index >= Mydata.length) { // Add a null check here as well
                        //       return Container();
                        //       }
                        //     return ListTile(
                        //       title: Container(
                        //         margin: EdgeInsets.only(bottom: 10),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(12),
                        //           border: Border.all(width: 1, color: Colors.orange),
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(left: 5, right: 5.0),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Image.asset('assets/images/icon.png'),
                        //                   Text(
                        //                     Mydata[index]['name'] != null ? Mydata[index]['name'].toString() : 'Name not available', // Add a null check here
                        //                     style: TextStyle(fontSize: 14),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Switch(
                        //                 value: switchStates[index],
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     switchStates[index] = value;
                        //                       updateIWant();
                        //
                        //                     // Call the function to update "i_want"
                        //                   });
                        //                 },
                        //                 activeTrackColor: Colors.lightGreenAccent,
                        //                 activeColor: Colors.green,
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),

                        // ListView.builder(
                        //   scrollDirection: Axis.vertical,
                        //   itemCount: Data.length,
                        //   shrinkWrap: true,
                        //   padding: EdgeInsets.zero,
                        //   itemBuilder: (context, index) {
                        //     if (index >= Data2.length) {
                        //       return Container();
                        //     }
                        //     return ListTile(
                        //       title: Container(
                        //         padding: EdgeInsets.zero,
                        //         decoration: BoxDecoration(
                        //           borderRadius:
                        //           BorderRadius.circular(12),
                        //           border: Border.all(
                        //               width: 1, color: Colors.orange),
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(
                        //               left: 5, right: 5.0),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Image.asset(
                        //                       'assets/images/icon.png'),
                        //                   Text(
                        //                     Data2[index]['name']
                        //                         .toString(),
                        //                     style:
                        //                     TextStyle(fontSize: 14),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Switch(
                        //                 value: switchStates[index],
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     switchStates[index] =
                        //                         value; // Update switch state
                        //                     // updateIWant(); // Update i_want value
                        //                   });
                        //                 }, // Call onChangedSwitch method
                        //                 activeTrackColor:
                        //                 Colors.lightGreenAccent,
                        //                 activeColor: Colors.green,
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                          SizedBox(
                          height: 20,
                            ),
                          InkWell(
                           onTap: () {
                            if (_formKey.currentState!.validate())
                              updateProfile();
                            // Navigator.pop(context);
                          },

                          // onTap: () {
                          //     ApiProfile();
                          //     Navigator.pop(context);
                          // },
                          // onTap: () {
                          //   ApiProfile();
                          //   Navigator.pop(context);
                          // },

                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 50, right: 50.0),
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
                                    'Save',
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ]),
                ),
              ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: Data.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index >= Data2.length) {
          print(Data2);
          return Container();
         }
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: Colors.orange),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5.0,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/icon.png'),
                    Text(Data2[index]['name'].toString(),),
                       ],
                    ),  Switch(
                  value: switchStates[index],

                  onChanged: (value) {
                    setState(() {

                      switchStates[index] = value;
                    });
                    updateIWant();
                  },
                  // value: switchStates[index],
                  // onChanged: (value) {
                  //   setState(() {
                  //     switchStates[index] = value;
                  //     iwant = value.toString();
                  //
                  //     // iwant = value.map((item) => item['id'].toString()).join(',');
                  //
                  //     print("i want's value here $iwant");
                  //   });
                  // },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),

                // Switch(
                //   value: switchStates[index],
                //   onChanged: (value) {
                //     setState(() {
                //       switchStates[index] = value;
                //     });
                //     updateIWant();
                //   },
                //
                //   // value: switchStates[index],
                //   // onChanged: (value) {
                //   //   setState(() {
                //   //     switchStates[index] = value;
                //   //     iwant = value.toString();
                //   //
                //   //     // iwant = value.map((item) => item['id'].toString()).join(',');
                //   //
                //   //     print("i want's value here $iwant");
                //   //   });
                //   // },
                //
                //   activeTrackColor: Colors.lightGreenAccent,
                //   activeColor: Colors.green,
                // ),
              ],
            ),
          ),
        );
        //   ListTile(
        //   title: Container(
        //     margin: EdgeInsets.only(bottom: 10),
        //     decoration: BoxDecoration(
        //       borderRadius:BorderRadius.circular(12),
        //       border: Border.all(width: 1,color: Colors.orange),
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 5,right: 5.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Row(
        //             children: [
        //               Image.asset('assets/images/icon.png'),
        //               Text(
        //                 Data2[index]['name'].toString(), // Use data from your Data list
        //                 style: TextStyle(
        //                   fontSize: 14,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Switch(
        //             value: switchStates[index],
        //             onChanged: (value) {
        //               setState(() {
        //                 switchStates[index] = value;
        //               });
        //               updateIWant();
        //             },
        //             // value: switchStates[index],
        //             // onChanged: (value) {
        //             //   setState(() {
        //             //     switchStates[index] = value;
        //             //     iwant = value.toString();
        //             //
        //             //     // iwant = value.map((item) => item['id'].toString()).join(',');
        //             //
        //             //     print("i want's value here $iwant");
        //             //   });
        //             // },
        //             activeTrackColor: Colors.lightGreenAccent,
        //             activeColor: Colors.green,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }

  late DateTime _selectedDate;
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      File? img = File(pickedFile.path);
      setState(() {
        imageFile = img;
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      File? img = File(pickedFile.path);
      setState(() {
        imageFile = img;
      });
    }
  }
}

// // import 'package:flutter/material.dart';
// //
// // class EditProfile extends StatefulWidget {
// //   final String device;
// //   const EditProfile({super.key, required this.device});
// //
// //   @override
// //   State<EditProfile> createState() => _EditProfileState();
// // }
// //
// // class _EditProfileState extends State<EditProfile> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //
// //     );
// //   }
// // }
// import 'dart:io';
// import 'dart:ui';
// import 'package:chips_choice/chips_choice.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:madadguru/Pages/EnquaryScreen.dart';
// import 'package:madadguru/Pages/SettingScreen.dart';
// import '../Allwidgets/AboutUs.dart';
// import '../Allwidgets/Account_JobPreference.dart';
// import '../Allwidgets/FaqScreen.dart';
// import '../Allwidgets/textForm_filed.dart';
//
// class EditProfile extends StatefulWidget {
//   final String device;
//   const EditProfile({
//     super.key,
//     required this.device,
//   });
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController _genderController = TextEditingController();
//   final TextEditingController _aboutController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _professionController = TextEditingController();
//   String selectedGender = '';
//   var Gender;
//   var gender = ["Male", "Female", "Other"];
//   File? imageFile;
//   bool isfieldsIn = false;
//   List<dynamic> Data = [];
//   List<dynamic> items = [
//     'hjfjg',
//     'bdbds',
//     'vdvsb',
//     'sndkj',
//     'jhbdh',
//   ];
//   var Language;
//   var language = ['Hindi', 'English', 'Marathi', 'Bengali'];
//   var Profession;
//   var profession = [
//     'Private',
//     'Gort Job',
//     'Business',
//     'Student',
//     'House Wife',
//     'Un-Employed',
//     'NGO Worker',
//     'Other',
//     '',
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Edit Profile',
//           style: GoogleFonts.roboto(
//             color: Colors.black,
//             fontWeight: FontWeight.w400,
//             fontSize: 14,
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: <Widget>[
//           Stack(children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               // height: 300,
//               // decoration: BoxDecoration(
//               //   color: Colors.orange.shade800,
//               //   borderRadius: BorderRadius.only(
//               //     bottomLeft: Radius.circular(32),
//               //     bottomRight: Radius.circular(32),
//               //   ),
//               //   ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(32),
//                   bottomRight: Radius.circular(32),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//
//                       const SizedBox(
//                         height: 20,
//                       ),
//
//                       Container(
//                         alignment: Alignment.center,
//                         // width: double.infinity,
//                         child: GestureDetector(
//                           onTap: () {
//                             showModalBottomSheet(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(25),
//                                     topLeft: Radius.circular(25),
//                                   ),
//                                 ),
//                                 context: context,
//                                 builder: (BuildContext bc) {
//                                   return StatefulBuilder(builder:
//                                       (BuildContext context,
//                                           StateSetter setState) {
//                                     return BackdropFilter(
//                                         filter: ImageFilter.blur(
//                                             sigmaX: 0.3, sigmaY: 0.3),
//                                         child: Container(
//                                           padding: const EdgeInsets.all(20),
//                                           child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () async {
//                                                     Navigator.pop(context);
//                                                     await _getFromCamera();
//                                                   },
//                                                   child: Row(children: [
//                                                     Icon(
//                                                       Icons.camera_alt_outlined,
//                                                       color: Colors.blue,
//                                                     ),
//                                                     // Image.asset(
//                                                     //   "assets/icons/photo-camera-interface-symbol-for-button.png",
//                                                     //   width: 25,
//                                                     //   color: Colors.black54,
//                                                     // ),
//                                                     const SizedBox(
//                                                       width: 20,
//                                                     ),
//                                                     Text(
//                                                       "Take Photo",
//                                                       style: GoogleFonts.roboto(
//                                                         textStyle:
//                                                             const TextStyle(
//                                                           color: Colors.black54,
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ]),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () async {
//                                                     Navigator.pop(context);
//                                                     await _getFromGallery();
//                                                   },
//                                                   child: Row(children: [
//                                                     Image.asset(
//                                                       "assets/images/gallery.png",
//                                                       width: 25,
//                                                       color: Colors.blue,
//                                                     ),
//                                                     const SizedBox(
//                                                       width: 20,
//                                                     ),
//                                                     Text(
//                                                       "Select from gallery",
//                                                       style: GoogleFonts.roboto(
//                                                         textStyle:
//                                                             const TextStyle(
//                                                           color: Colors.black54,
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ]),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                               ]),
//                                         ));
//                                   });
//                                 });
//                           },
//                           child: Stack(clipBehavior: Clip.none, children: [
//                             (imageFile == null)
//                                 ? CircleAvatar(
//                                     radius: 45,
//                                     child: ClipOval(
//                                       child: Image.asset(
//                                         'assets/images/people.webp',
//                                         fit: BoxFit.cover,
//                                         width: 90.0, // adjust width as needed
//                                         height: 90.0, // adjust height as needed
//                                       ),
//                                     ),
//                                   )
//                                 : CircleAvatar(
//                                     radius: 45,
//                                     child: ClipOval(
//                                       child: Image.asset(
//                                         'assets/images/people.webp',
//                                         fit: BoxFit.cover,
//                                         width: 90.0, // adjust width as needed
//                                         height: 90.0, // adjust height as needed
//                                       ),
//                                     ),
//                                   ),
//                             Positioned(
//                               bottom: 10,
//                               right: -5,
//                               child: CircleAvatar(
//                                 radius: 16,
//                                 backgroundColor:
//                                     Color(0xffFF9228).withOpacity(0.7),
//                                 child: Icon(
//                                   Icons.edit,
//
//                                   color: Colors.white,
//                                   // width: 16,
//                                 ),
//                               ),
//                             ),
//                           ]),
//                         ),
//                       ),
//
//                       // SizedBox(
//                       //   height: 10,
//                       // ),
//                       // Text('Rajesh Rajesh Rajesh',
//                       //     style: TextStyle(
//                       //         color: Colors.white,
//                       //         fontWeight: FontWeight.w500,
//                       //         fontSize: 14)),
//                       // SizedBox(
//                       //   height: 5,
//                       // ),
//                       // Text(
//                       //   '   Greater Noida',
//                       //   style: TextStyle(
//                       //       color: Colors.white,
//                       //       fontWeight: FontWeight.w500,
//                       //       fontSize: 14),
//                       // ),
//                       // SizedBox(
//                       //   height: 20,
//                       // ),
//                       // // SizedBox(height: 5,),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Name',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color(0xffFFF1E7),
//                   ),
//                   child: TextFormFieldWidget1(
//                     cursorColor: Color(0xffFF9228),
//                     controller: nameController,
//                     inputType: TextInputType.text,
//                     inputAction: TextInputAction.next,
//                     obscureText: false,
//                     hintText: "Enter your full name",
//                     // labeltext: 'Name',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Email',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color(0xffFFF1E7),
//                   ),
//                   child: TextFormFieldWidget1(
//                     cursorColor: Color(0xffFF9228),
//                     controller: phoneController,
//                     inputType: TextInputType.text,
//                     inputAction: TextInputAction.next,
//                     obscureText: false,
//                     // labeltext: "Gmail",
//                     hintText: "Enter your Gmail",
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Phone Number',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color(0xffFFF1E7),
//                   ),
//                   child: TextFormFieldWidget1(
//                     cursorColor: Color(0xffFF9228),
//                     controller: phoneController,
//                     inputType: TextInputType.number,
//                     inputAction: TextInputAction.next,
//                     obscureText: false,
//                     // labeltext: "Phone",
//                     hintText: "Enter your Phone",
//                   ),
//                 ),
//
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Date of Birth',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Color(0xffFFF1E7)),
//                   child: TextField(
//                     readOnly: true,
//                     cursorColor: Color(0xffFF9228),
//                     obscureText: false,
//                     controller: dobController,
//                     keyboardType: TextInputType.text,
//                     textInputAction: TextInputAction.done,
//                     decoration: InputDecoration(
//                       suffixIcon: IconButton(
//                           onPressed: () async {
//                             DateTime? pickedDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime(1950),
//                                 lastDate: DateTime(2100));
//                             setState(() {
//                               dobController.text = DateFormat('dd-MM-yyyy')
//                                   .format(DateTime.parse(pickedDate.toString()))
//                                   .toString();
//                             });
//                           },
//                           icon: const Icon(
//                             Icons.calendar_month,
//                             color: Colors.black45,
//                             size: 23,
//                           )),
//                           enabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                             width: 1.5, color: Color(0xffFFF1E7)),
//                         borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(width: 1.5, color: Colors.black45),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       // labelText: "Date of birth",
//                       // labelStyle: GoogleFonts.roboto(
//                       //     fontSize: 15,
//                       //     fontWeight: FontWeight.w400,
//                       //     color: Colors.black45),
//                       hintText: "Date of birth",
//                       hintStyle: GoogleFonts.roboto(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black45),
//                     ),
//                     style: GoogleFonts.roboto(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Gender',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(left: 7),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     // border: Border.all(width: 1.5, color: Colors.orange),
//     color: Color(0xffFFF1E7),
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: InputDecorator(
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                       ),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         style: GoogleFonts.roboto(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.orange),
//                         dropdownColor: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         value: Gender,
//                         isExpanded: true,
//                         icon: const Icon(
//                           Icons.keyboard_arrow_down,
//                           size: 30,
//                           color: Colors.black38,
//                         ),
//                         hint: Text(
//                           "Gender",
//                           style: GoogleFonts.roboto(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.black38),
//                         ),
//                         elevation: 1,
//                         underline: Container(height: 1, color: Colors.orange),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             Gender = newValue!;
//                             _genderController.text = newValue;
//                           });
//                         },
//                         items: gender
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: GoogleFonts.roboto(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Container(
//                 //       height: 50,
//                 //       width: 170,
//                 //       decoration: BoxDecoration(
//                 //           borderRadius: BorderRadius.circular(12),
//                 //           color: Color(0xffFFF1E7)),
//                 //       child: Center(
//                 //         child: RadioListTile(
//                 //           title: Text('Male'),
//                 //           value: 'male',
//                 //           groupValue: selectedGender,
//                 //           onChanged: (value) {
//                 //             setState(() {
//                 //               selectedGender = value!;
//                 //             });
//                 //           },
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     // Container(
//                 //     //   height: 50,
//                 //     //   width: 170,
//                 //     //   decoration: BoxDecoration(
//                 //     //       borderRadius: BorderRadius.circular(10),
//                 //     //       color: Color(0xffFFF1E7)),
//                 //     //   child: Center(
//                 //     //     child: RadioListTile(
//                 //     //       title: Text('Female'),
//                 //     //       value: 'female',
//                 //     //       groupValue: selectedGender,
//                 //     //       onChanged: (value) {
//                 //     //         setState(() {
//                 //     //           selectedGender = value!;
//                 //     //         });
//                 //     //       },
//                 //     //     ),
//                 //     //   ),
//                 //     // ),
//                 //     Container(
//                 //       padding: EdgeInsets.only(left: 7),
//                 //       alignment: Alignment.center,
//                 //       decoration: BoxDecoration(
//                 //         border: Border.all(width: 1.5, color: Colors.orange),
//                 //         color: Colors.transparent,
//                 //         borderRadius: BorderRadius.all(Radius.circular(10)),
//                 //       ),
//                 //       child: InputDecorator(
//                 //         decoration: const InputDecoration(
//                 //           border: InputBorder.none,
//                 //           contentPadding: EdgeInsets.symmetric(
//                 //             horizontal: 10,
//                 //           ),
//                 //         ),
//                 //         child: DropdownButtonHideUnderline(
//                 //           child: DropdownButton<String>(
//                 //             style: GoogleFonts.roboto(
//                 //                 fontSize: 12,
//                 //                 fontWeight: FontWeight.w400,
//                 //                 color: Colors.orange),
//                 //             dropdownColor: Colors.white,
//                 //             borderRadius: BorderRadius.circular(10),
//                 //             value: Gender,
//                 //             isExpanded: true,
//                 //             icon: const Icon(
//                 //               Icons.keyboard_arrow_down,
//                 //               size: 30,
//                 //               color: Colors.black38,
//                 //             ),
//                 //             hint: Text(
//                 //               "Gender",
//                 //               style: GoogleFonts.roboto(
//                 //                   fontSize: 12,
//                 //                   fontWeight: FontWeight.w400,
//                 //                   color: Colors.black38),
//                 //             ),
//                 //             elevation: 1,
//                 //             underline: Container(height: 1, color: Colors.orange),
//                 //             onChanged: (String? newValue) {
//                 //               setState(() {
//                 //                 Gender = newValue!;
//                 //                 _genderController.text = newValue;
//                 //               });
//                 //             },
//                 //             items: gender
//                 //                 .map<DropdownMenuItem<String>>((String value) {
//                 //               return DropdownMenuItem<String>(
//                 //                 value: value,
//                 //                 child: Text(
//                 //                   value,
//                 //                   style: GoogleFonts.roboto(
//                 //                       fontSize: 12,
//                 //                       fontWeight: FontWeight.w400,
//                 //                       color: Colors.black),
//                 //                 ),
//                 //               );
//                 //             }).toList(),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // SizedBox(height: 10),
//                 // Text(
//                 //   'Location',
//                 //   style: GoogleFonts.roboto(
//                 //     color: Colors.black,
//                 //     fontWeight: FontWeight.w400,
//                 //     fontSize: 14,
//                 //   ),
//                 // ),
//                 // SizedBox(height: 10),
//                 // Container(
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(10),
//                 //     color: Color(0xffFFF1E7),
//                 //   ),
//                 //   child: TextFormFieldWidget1(
//                 //     cursorColor: Color(0xffFF9228),
//                 //     controller: locationController,
//                 //     inputType: TextInputType.text,
//                 //     inputAction: TextInputAction.next,
//                 //     obscureText: false,
//                 //     labeltext: "Location",
//                 //     hintText: "Enter your Location",
//                 //   ),
//                 // ),
//                 SizedBox(
//                   height: 10,
//                 ),
//
//                 Text(
//                   'Profession',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//
//                 Container(
//                   padding: EdgeInsets.only(left: 15, right: 15),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     // border: Border.all(width: 1.5, color: Colors.orange),
//                     // color: Colors.transparent,
//                     color: Color(0xffFFF1E7),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   child: InputDecorator(
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                       ),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         style: GoogleFonts.roboto(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black38),
//                         dropdownColor: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         value: Profession,
//                         isExpanded: true,
//                         icon: const Icon(
//                           Icons.keyboard_arrow_down,
//                           size: 30,
//                           color: Colors.black38,
//                         ),
//                         hint: Text(
//                           "Profession",
//                           style: GoogleFonts.roboto(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.black38),
//                         ),
//                         elevation: 1,
//                         underline: Container(height: 1, color: Colors.black38),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             Profession = newValue!;
//                             _professionController.text = newValue;
//                           });
//                         },
//                         items: profession
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: GoogleFonts.roboto(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//
//
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'About',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Color(0xffFFF1E7),
//                    ),
//                    child: TextField(
//                     maxLines: 2,
//                     controller: _aboutController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter the text here',
//                       // label: Text('About'),
//                       hintStyle: TextStyle(color: Colors.black38,fontSize: 12),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.transparent),
//                       ),
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.black38),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.black38),
//                       ),
//                       contentPadding: EdgeInsets.only(
//                           left: 10, right: 10, bottom: 10, top: 10),
//                     ),
//                     keyboardType: TextInputType.text,
//                     onChanged: (value) {
//                       // Handle text changes
//                     },
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 //
//                 // Text(
//                 //   'I want -',
//                 //   style: GoogleFonts.roboto(
//                 //     color: Colors.black,
//                 //     fontWeight: FontWeight.w400,
//                 //     fontSize: 14,
//                 //   ),
//                 // ),
//                 // // SizedBox(
//                 // //   height: 10,
//                 // // ),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 //
//                 // Container(
//                 //   height: 55,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     border: Border.all(width: 1, color: Colors.orange),
//                 //   ),
//                 //   child: Center(
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //       children: [
//                 //         Row(
//                 //           children: [
//                 //             Image.asset('assets/images/icon.png'),
//                 //             Text(
//                 //               'Personal Help',
//                 //               style: TextStyle(
//                 //                 fontSize: 17,
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //         Center(
//                 //           child: Switch(
//                 //             value: isSwitched,
//                 //             onChanged: (value) {
//                 //               setState(() {
//                 //                 isSwitched = value;
//                 //               });
//                 //             },
//                 //             activeTrackColor: Colors.lightGreenAccent,
//                 //             activeColor: Colors.green,
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   height: 20,
//                 // ),
//                 //
//                 // Container(
//                 //   height: 55,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     border: Border.all(width: 1, color: Colors.orange),
//                 //   ),
//                 //   child: Center(
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //       children: [
//                 //         Row(
//                 //           children: [
//                 //             Image.asset('assets/images/icon.png'),
//                 //             Text(
//                 //               'Legal Help',
//                 //               style: TextStyle(
//                 //                 fontSize: 17,
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //         Center(
//                 //           child: Switch(
//                 //             value: isSwitched1,
//                 //             onChanged: (value) {
//                 //               setState(() {
//                 //                 isSwitched1 = value;
//                 //               });
//                 //             },
//                 //             activeTrackColor: Colors.lightGreenAccent,
//                 //             activeColor: Colors.green,
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//                 //
//                 // SizedBox(
//                 //   height: 20,
//                 // ),
//                 //
//                 // Container(
//                 //   height: 55,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     border: Border.all(width: 1, color: Colors.orange),
//                 //   ),
//                 //   child: Center(
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //       children: [
//                 //         Row(
//                 //           children: [
//                 //             Image.asset('assets/images/icon.png'),
//                 //             Text(
//                 //               'Community Help',
//                 //               style: TextStyle(
//                 //                 fontSize: 17,
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //         Center(
//                 //           child: Switch(
//                 //             value: isSwitched2,
//                 //             onChanged: (value) {
//                 //               setState(() {
//                 //                 isSwitched2 = value;
//                 //               });
//                 //             },
//                 //             activeTrackColor: Colors.lightGreenAccent,
//                 //             activeColor: Colors.green,
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//                 //
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 // Text(
//                 //   "Need Help In:",
//                 //   // textAlign: TextAlign.center,
//                 //   style: GoogleFonts.roboto(
//                 //     color: Colors.black,
//                 //     fontWeight: FontWeight.w400,
//                 //     fontSize: 14,
//                 //   ),
//                 // ),
//                 //
//                 // ChipsChoice<dynamic>.multiple(
//                 //   choiceItems: C2Choice.listFrom<dynamic, dynamic>(
//                 //     source: DepartmentList,
//                 //     value: (index1, item) => DepartmentList[index1]['id'],
//                 //     label: (index1, item) =>
//                 //         DepartmentList[index1]['filterValue'],
//                 //   ),
//                 //   value: department,
//                 //   onChanged: (val) => setState(() => department = val),
//                 //   choiceCheckmark: true,
//                 //   choiceStyle: C2ChipStyle.outlined(
//                 //     color: Color(0xFFA2A09D),
//                 //     checkmarkColor: Colors.white,
//                 //     foregroundStyle:
//                 //         const TextStyle(color: Color(0xFF2F2924), fontSize: 14),
//                 //     selectedStyle: C2ChipStyle.filled(
//                 //       foregroundStyle:
//                 //           TextStyle(color: Colors.white, fontSize: 14),
//                 //       color: Color(0xff655D53),
//                 //       borderRadius: BorderRadius.all(
//                 //         Radius.circular(10),
//                 //       ),
//                 //     ),
//                 //   ),
//                 //   wrapped: true,
//                 // ),
//               ],
//              ),
//             ),
//
//           // Text('Need help In'),
//
//           // Padding(
//           //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//           //   child: Container(
//           //     height: 55,
//           //     width: MediaQuery.of(context).size.width,
//           //     decoration: BoxDecoration(
//           //       borderRadius: BorderRadius.circular(10),
//           //       border: Border.all(width: 1, color: Color(0xffEC7224)),
//           //     ),
//           //     child: Center(
//           //       child: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Row(
//           //             children: [
//           //               Padding(
//           //                 padding: const EdgeInsets.only(left: 10, right: 15),
//           //                 child: Icon(Icons.logout, color: Color(0xffEC7224)),
//           //               ),
//           //               Text(
//           //                 'Pan Card',
//           //                 style:
//           //                     TextStyle(fontSize: 16, color: Color(0xffEC7224)),
//           //               ),
//           //             ],
//           //           ),
//           //           Center(
//           //             child: Switch(
//           //               value: isSwitched,
//           //               onChanged: (value) {
//           //                 setState(() {
//           //                   isSwitched = value;
//           //                 });
//           //               },
//           //               // paintBorder()
//           //               // inactiveTrackColor: Colors.orange,
//           //               activeTrackColor: Colors.orange,
//           //               activeColor: Colors.orange.shade50,
//           //               inactiveThumbColor: Colors.orange,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           //
//           // Padding(
//           //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//           //   child: Container(
//           //     height: 55,
//           //     width: MediaQuery.of(context).size.width,
//           //     decoration: BoxDecoration(
//           //       borderRadius: BorderRadius.circular(12),
//           //       border: Border.all(width: 1, color: Color(0xffEC7224)),
//           //     ),
//           //     child: Center(
//           //       child: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Row(
//           //             children: [
//           //               Padding(
//           //                 padding: const EdgeInsets.only(left: 10, right: 15),
//           //                 child: Icon(Icons.logout, color: Color(0xffEC7224)),
//           //               ),
//           //               Text(
//           //                 'Aadhaar Card',
//           //                 style:
//           //                     TextStyle(fontSize: 16, color: Color(0xffEC7224)),
//           //               ),
//           //             ],
//           //           ),
//           //           Center(
//           //             child: Switch(
//           //               value: isSwitched1,
//           //               onChanged: (value) {
//           //                 setState(() {
//           //                   isSwitched1 = value;
//           //                 });
//           //               },
//           //               inactiveThumbColor: Colors.orange,
//           //               activeTrackColor: Colors.orange,
//           //               activeColor: Colors.orange.shade50,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           //
//           // Padding(
//           //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//           //   child: Container(
//           //     height: 55,
//           //     width: MediaQuery.of(context).size.width,
//           //     decoration: BoxDecoration(
//           //       borderRadius: BorderRadius.circular(12),
//           //       border: Border.all(width: 1, color: Color(0xffEC7224)),
//           //     ),
//           //     child: Center(
//           //       child: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Row(
//           //             children: [
//           //               Padding(
//           //                 padding: const EdgeInsets.only(left: 10, right: 15),
//           //                 child: Icon(Icons.logout, color: Color(0xffEC7224)),
//           //               ),
//           //
//           //               // Image.asset('assets/images/icon.png',color: Color(0xffEC7224)),
//           //               Text(
//           //                 'RC',
//           //                 style:
//           //                     TextStyle(fontSize: 16, color: Color(0xffEC7224)),
//           //               ),
//           //             ],
//           //           ),
//           //           Center(
//           //             child: Switch(
//           //               value: isSwitched2,
//           //               onChanged: (value) {
//           //                 setState(() {
//           //                   isSwitched2 = value;
//           //                 });
//           //               },
//           //               activeTrackColor: Colors.orange,
//           //               activeColor: Colors.orange.shade50,
//           //               inactiveThumbColor: Colors.orange,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           InkWell(
//             onTap: () {
//               Navigator.pop(context);
//
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(
//                   right: 40, left: 40, top: 20, bottom: 10),
//               child: Card(
//                 elevation: 2,
//                 child: Container(
//                   height: 45,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Color(0xffFBCD96)),
//                   child: Center(
//                     child: Text(
//                       'SAVE',
//                       style: TextStyle(
//                           color: Colors.orange,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16),
//                        ),
//                       ),
//                     ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 40,
//           ),
//         ]),
//       ),
//     );
//   }
//
//   _getFromGallery() async {
//     XFile? pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       File? img = File(pickedFile.path);
//       setState(() {
//         imageFile = img;
//       });
//     }
//   }
//
//   _getFromCamera() async {
//     XFile? pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.camera,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       File? img = File(pickedFile.path);
//       setState(() {
//         imageFile = img;
//       });
//     }
//   }
// }
