import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:madadguru/Allwidgets/background_screen.dart';
import 'package:madadguru/Allwidgets/textForm_filed.dart';
import 'package:madadguru/Pages/LanguagePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  final String device;
  final String mobile;
  final String userid;
  final String userotp;
  const SignUpScreen({
    super.key,
    required this.device,
    required this.userotp,
    required this.mobile,
    required this.userid,
  });
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobilController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  bool isSignningIn = false;
  bool isActivate = false;
  bool isActivate1 = true;
  File? imageFile;
  var Gender;
  var Profession;
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
  bool isLoading = false;
  var gender = ["Male", "Female", "Other"];
  Map<String, dynamic> data = {};

  Future<void> ApiProfile() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    // if (authToken != null && authToken.isNotEmpty) {
    //   final Uri uri = Uri.parse("https://madadguru.webkype.net/api/updateProfile/${widget.userid}?_method=PATCH");
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
    request.fields['userotp'] = widget.userotp;
    request.fields['mobile'] = widget.mobile;
    request.fields['about'] = _aboutController.text;
    request.fields['gender'] = _genderController.text;
    request.fields['name'] = _nameController.text;

    request.fields['dob'] = _dobController.text;
    request.fields['email'] = _emailController.text;

    request.fields['profession'] = _professionController.text;
    request.fields['language'] = "";
    request.fields['i_want'] = "";
    request.fields['need_help_in'] = "";
    // try{
    //
    // }
// "userotp": widget.userotp,
//         "mobile": widget.mobile,
//         "about": _aboutController.text.toString(),
//         "gender": _genderController.text.toString(),
//         "name": _nameController.text.toString(),
//         "dob": _dobController.text.toString(),
//         "email": _emailController.text.toString(),
//         "profession": _professionController.text.toString(),
//         "language": "",
//         "i_want": "",
//         "need_help_in": "",
//         "profile": "",
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          data = responseData;
        });
        print(responseData);

        // responseData.forEach((key, value) {
        //   print('$key: $value');
        // });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LanguageScreen(
                device: widget.device,
              ),
            ),
            (route) => false);
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making HTTP request: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        const Background(),
        SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 120, left: 15, right: 15),
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
                                                        Icons
                                                            .camera_alt_outlined,
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
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle:
                                                              const TextStyle(
                                                            color:
                                                                Colors.black54,
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
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle:
                                                              const TextStyle(
                                                            color:
                                                                Colors.black54,
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
                                          child: Image.asset(
                                            'assets/images/people.webp',
                                            fit: BoxFit.cover,
                                            width:
                                                90.0, // adjust width as needed
                                            height:
                                                90.0, // adjust height as needed
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
                                            width:
                                                90.0, // adjust width as needed
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
                            "Complete My Profile",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormFieldWidget(
                            cursorColor: Color(0xffFF9228),
                            controller: _nameController,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            obscureText: false,
                            labeltext: "Name",
                            hintText: "Enter your full name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Row(children: [
                            Expanded(
                              child: TextFormFieldWidget(
                                cursorColor: Color(0xffFF9228),
                                controller: _mobilController,
                                inputType: TextInputType.number,
                                inputAction: TextInputAction.next,
                                obscureText: false,
                                labeltext: "Mobile Number",
                                hintText: "0000000000",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                // inputFormatters: [
                                //   LengthLimitingTextInputFormatter(10), // Limits input length to 10 characters
                                //   FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Allows only numeric input
                                // ],
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 20,
                          ),

                          TextFormFieldWidget(
                            cursorColor: Color(0xffFF9228),
                            controller: _emailController,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            obscureText: false,
                            labeltext: "Email",
                            hintText: "Enter Email",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 7),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.orange),
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                    "Gender",
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black38),
                                  ),
                                  elevation: 1,
                                  underline: Container(
                                      height: 1, color: Colors.orange),
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
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            cursorColor: Color(0xffFF9228),
                            obscureText: false,
                            controller: _dobController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2100));
                                  setState(() {
                                    _dobController.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(DateTime.parse(
                                                pickedDate.toString()))
                                            .toString();
                                  });
                                },
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.black38,
                                  size: 23,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.orange),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.orange),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              labelText: "Date Of Birth",
                              labelStyle: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black38),
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
                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            padding: EdgeInsets.only(left: 7),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.orange),
                              color: Colors.transparent,
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
                                child: DropdownButton<String>(
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.orange),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  value: Profession,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.black38,
                                  ),
                                  hint: Text(
                                    "Profession",
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black38),
                                  ),
                                  elevation: 1,
                                  underline: Container(
                                      height: 1, color: Colors.orange),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Profession = newValue!;
                                      _professionController.text = newValue;
                                    });
                                  },
                                  items: profession
                                      .map<DropdownMenuItem<String>>(
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
                            height: 20,
                          ),
                          TextField(
                            style: TextStyle(fontSize: 12),
                            maxLines: 3,
                            controller: _aboutController,
                            decoration: InputDecoration(
                              hintText: 'Enter the text here',
                              label: Text(
                                'About',
                                style: TextStyle(fontSize: 12),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.black38, fontSize: 12),
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
                            height: 40,
                          ),

                          InkWell(
                            onTap: () {
                              if(_formKey.currentState!.validate())
                              ApiProfile();
                               },
                            // onTap: () {
                            //   // Navigate to the second page
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => LanguageScreen(
                            //               device: widget.device,
                            //         ),
                            //     ),
                            //   );
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
                                      color: Color(0xffFFEADD)),
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
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
      ]),
    );
   }
  // _getFromCamera() async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 50,
  //   );
  //   if (pickedFile != null) {
  //     File? img = File(pickedFile.path);
  //     setState(() {
  //       imageFile = img;
  //     });
  //   }
  // }
  //

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

// multipart ke through
//documents Send
// image path
