import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madadguru/Allwidgets/Editprofile.dart';
import 'package:madadguru/Pages/SpiritualScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AllWidgets/buttons.dart';
import 'package:http/http.dart' as http;
import '../Allwidgets/GalleryScreen.dart';

class HomeScreen extends StatefulWidget {
  final String device;
  const HomeScreen({
    super.key,
    required this.device,
    required String Device,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<dynamic> Data = [];
  final TextEditingController _textController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  List<String> complains = [];
  File? _imageFile1;
  var Complains;
  var Documents;
  var documents = [
    "Pan Card",
    "Driving License",
    "Aadhaar Card",
  ];
  var Documents1;
  var documents1 = [
    "Full Time",
    " Part Time",
  ];
  List<String> images = [
    "assets/icon/report.png",
    "assets/icon/investigation.png",
    "assets/icon/contact.png",
    "assets/icon/support.png",
    "assets/icon/signing.png",
    "assets/icon/documentation.png",
  ];

  File? panCardImage;
  File? drivingLicenseImage;
  File? aadharCardImage;
  List<http.MultipartFile> files = [];
  File? imageFile;
  File? imageFile1;
  // List<File> imageFiles = [];
  Map<String, dynamic> value = {};
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    fetchDataEnquiry();
  }

  List<Map<String, dynamic>> DataList = [];
  Future<void> updateKyc() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/updateKyc");
      try {
        var request = http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $usertoken';
        if (panCardImage != null) {
          request.files.add(
            await http.MultipartFile.fromBytes(
              'pan_card',
              await panCardImage!.readAsBytes(),
              filename: panCardImage!.path,
            ),
          );
        } else {
          request.fields['pan_card'] = '';
        }

        // Add driving license image file if not null, otherwise add an empty string
        if (drivingLicenseImage != null) {
          request.files.add(
            await http.MultipartFile.fromBytes(
              'driving_license',
              await drivingLicenseImage!.readAsBytes(),
              filename: drivingLicenseImage!.path,
            ),
          );
        } else {
          request.fields['driving_license'] = '';
        }
        if (aadharCardImage != null) {
          request.files.add(
            await http.MultipartFile.fromBytes(
              'aadhar_card',
              await aadharCardImage!.readAsBytes(),
              filename: aadharCardImage!.path,
            ),
          );
        } else {
          request.fields['aadhar_card'] = '';
        }
        var response = await request.send();
        if (response.statusCode == 200) {
          print('Kyc sent to API successfully.');
          Navigator.pop(context);
        } else {
          print(
              'Failed to send Kyc selection to API. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error sending Kyc selection to API: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchDataEnquiry() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getEnquiryCategory");
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
            DataList = data
                .map((item) => {
                      'id': item['id'].toString(),
                      'name': item['name'],
                    })
                .toList();
          });
          print('DepartmentList: $DataList');
          print('Data fetched successfully');
          print(response.body);
          print('Data fetched successfully');
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

  void complainPopUp(String id, String message, File? imageFile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs != null) {
        var usertoken = prefs.getString('token');
        if (usertoken != null) {
          final Uri uri =
              Uri.parse("https://madadguru.webkype.net/api/addComplain");
          final request = http.MultipartRequest('POST', uri);
          request.headers['Authorization'] = 'Bearer $usertoken';
          request.fields['category_id'] = id;
          request.fields['message'] = message;

          if (imageFile != null) {
            // Add image file to request
            request.files.add(await http.MultipartFile.fromPath(
              'image',
              imageFile.path,
            ));
          }
          final response = await request.send();
          if (response.statusCode == 200) {
            print('ResponseaddComplain: ${response.statusCode}');
            var Data = json.decode(await response.stream.bytesToString());
            if (Data['status'] == 200 && Data['success'] == true) {
              print(
                  'ResponseaddComplain sent successfully: ${Data['message']}');
            } else {
              print('Failed to send ResponseaddComplain: ${Data['message']}');
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

  // https://madadguru.webkype.net/api/makeVolunteer
  //
  // volunteer_type:

  List<dynamic> department = [];
  Map<String, dynamic>? selectedProfession;
  List<Map<String, dynamic>> professionList = [];

  Future<void> getMakeVolunteerApi(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/makeVolunteer");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
          // Key pass Karni hai
          body: {
            "volunteer_type": newValue,
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print(response.body);
          print('Data fetched successfully');
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: Image.asset(
                      'assets/images/imageMadadguru.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: Image.asset(
                    "assets/images/mimage-removebg.png",
                    height: 60,
                    width: 60,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 5, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return EditProfile(
                                device: widget.device,
                              );
                            }),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                  color: const Color(0xff4E89AE),
                                ),
                                child: Text(
                                  "Profile Complete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Colors.white38,
                                ),
                                child: Text(
                                  "Completed",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _ShowDialogueKyc(context);
                        },
                        child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                  color: const Color(0xffED6663),
                                ),
                                child: Text(
                                  "KYC Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Colors.white38,
                                ),
                                child: Text(
                                  "Apply Now",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return GalleryScreen(
                            device: widget.device,
                          );
                        }),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Column(
                        children: [
                          Card(
                            elevation: 2,
                            child: Container(
                              height: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Color(0xffED6663),
                                //     Color(0xff4E89AE),
                                //   ],
                                //   begin: Alignment.centerLeft,
                                //   end: Alignment.centerRight,
                                // ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/gallery.png',
                                    height: 20,
                                    width: 30,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _ShowDialogueVolunteer(context);
                    },

                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) {
                    //       return GalleryScreen(
                    //         device: widget.device,
                    //       );
                    //     }),
                    //   );
                    // },

                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 2,
                            child: Container(
                              height: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,

                                // color: const Color(0xff4E89AE),
                                // color: const Color(0xffED6663),
                                //   gradient: LinearGradient(
                                //     colors: [
                                //       // Color(0xffED6663),
                                //       Color(0xffED6663),
                                //       Colors.orange.shade200,
                                //       // Colors.white,
                                //
                                //
                                //       // Color(0xff4E89AE),
                                //     ],
                                //     begin: Alignment.centerLeft,
                                //     end: Alignment.centerRight,
                                //   ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icon/volunteer.png',
                                    height: 25,
                                    width: 30,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Join as volunteer",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SpiritualScreen(
                      device: widget.device,
                    );
                  }),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  elevation: 2,
                  child: Stack(
                    children: [
                      Container(
                        height: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/baba.jpg',
                            ), // Use the current image path
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10, // Adjust the position of the icon vertically
                        right:
                            10, // Adjust the position of the icon horizontally
                        child: Image.asset(
                          "assets/images/mimage.png",
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 10, right: 10),
              //   child: Card(
              //     elevation: 2,
              //     child: Container(
              //       height: 170,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(12),
              //         image: DecorationImage(
              //             image: AssetImage(
              //               'assets/images/baba.jpg',
              //             ),
              //             fit: BoxFit.cover),
              //       ),
              //     ),
              //   ),
              // ),
            ),
            SizedBox(
              height: 10,
            ),
            buildListView(),
            Text(
              'Version 1.0',
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListView() {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: DataList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 0.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              _ShowDialoguePopText(DataList[index]['id'],
                  title: DataList[index]['name']);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5, left: 13, right: 13, bottom: 15),
              child: SizedBox(
                child: Container(
                  width: 165, // Adjust size based on constraints
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffED6663),
                        Color(0xff4E89AE),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(images[index],
                          height: 20, width: 20, color: Colors.white),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 8.0),
                        child: Text(
                          DataList[index]['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  String? selectedDocument;
  void _ShowDialogueKyc(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'KYC Verification',
            ),
            content: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.orange),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedDocument,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a value';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.orange,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      // value: selectedDocument,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                        color: Colors.black38,
                      ),
                      hint: Text(
                        "ID Proof",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black38,
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDocument = newValue!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                            child: Text(
                              "Pan Card",
                            ),
                            value: "pan_card"),
                        DropdownMenuItem(
                            child: Text("Driving License"),
                            value: "driving_license"),
                        DropdownMenuItem(
                            child: Text("Aadhar Card"), value: "aadhar_card"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                                (BuildContext context, StateSetter setState) {
                              return BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
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
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Take Photo",
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
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
                                                textStyle: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ]),
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(width: 1, color: Colors.orange),
                            ),
                            child: imageFile == null
                                ? Center(
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.black38,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      updateKyc();
                      // Navigator.pop(context);
                    },
                    child: ButtonWidget(
                      text: "Submit",
                      color: const Color(0xffFF9228),
                      textColor: Colors.white,
                      width: 130,
                    ),
                  ),
                ],
              ),
            ),
          );
         },
        );
       }

  void _ShowDialogueVolunteer(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Volunteer Request',
            ),
            content: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset('assets/images/volunteerbg.png'),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.orange),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedDocument,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a value';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.orange,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      // value: selectedDocument,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                        color: Colors.black38,
                      ),
                      hint: Text(
                        "Volunteer",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black38,
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDocument = newValue!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                            child: Text(
                              "Full time",
                            ),
                            value: "pan_card"),
                        DropdownMenuItem(
                            child: Text("Part time"), value: "driving_license"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  GestureDetector(
                    onTap: () {
                      // updateKyc();
                      getMakeVolunteerApi("newValue");
                      Navigator.pop(context);
                    },
                    child: ButtonWidget(
                      text: "Send",
                      color: const Color(0xffFF9228),
                      textColor: Colors.white,
                      width: 130,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // void _ShowDialoguePopText(String id, {required title}) {
  //   TextEditingController _textController = TextEditingController();
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("${title}"),
  //           content: Container(
  //             height: 300,
  //             child: Column(
  //               children: [
  //                 TextField(
  //                   maxLines: 3,
  //                   controller: _textController,
  //                   decoration: InputDecoration(
  //                     hintText: 'Text here....',
  //                     labelStyle: TextStyle(color: Colors.orange),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide(color: Colors.orange),
  //                     ),
  //                     disabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide(color: Colors.orange),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide(color: Colors.orange),
  //                     ),
  //                     contentPadding:
  //                         EdgeInsets.only(left: 10, right: 10, top: 10),
  //                   ),
  //                   keyboardType: TextInputType.text,
  //                   onChanged: (value) {
  //                   },
  //                 ),
  //                 SizedBox(height: 10),
  //                 Container(
  //                   alignment: Alignment.center,
  //                   width: double.infinity,
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       showModalBottomSheet(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.only(
  //                             topRight: Radius.circular(25),
  //                             topLeft: Radius.circular(25),
  //                           ),
  //                         ),
  //                         context: context,
  //                         builder: (BuildContext bc) {
  //                           return StatefulBuilder(builder:
  //                               (BuildContext context, StateSetter setState) {
  //                             return BackdropFilter(
  //                               filter:
  //                                   ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
  //                               child: Container(
  //                                 padding: const EdgeInsets.all(20),
  //                                 child: Column(
  //                                     mainAxisSize: MainAxisSize.min,
  //                                     children: [
  //                                       GestureDetector(
  //                                         onTap: () async {
  //                                           Navigator.pop(context);
  //                                           await _getFromCamera();
  //                                         },
  //                                         child: Row(children: [
  //                                           Icon(
  //                                             Icons.camera_alt_outlined,
  //                                             color: Colors.blue,
  //                                           ),
  //                                           SizedBox(
  //                                             width: 20,
  //                                           ),
  //                                           Text(
  //                                             "Take Photo",
  //                                             style: GoogleFonts.roboto(
  //                                               textStyle: const TextStyle(
  //                                                 color: Colors.black54,
  //                                                 fontSize: 14,
  //                                                 fontWeight: FontWeight.w500,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ]),
  //                                       ),
  //                                       const SizedBox(
  //                                         height: 20,
  //                                       ),
  //                                       GestureDetector(
  //                                         onTap: () async {
  //                                           Navigator.pop(context);
  //                                           await _getFromGallery();
  //                                         },
  //                                         child: Row(children: [
  //                                           Image.asset(
  //                                             "assets/images/gallery.png",
  //                                             width: 25,
  //                                             color: Colors.blue,
  //                                           ),
  //                                           const SizedBox(
  //                                             width: 20,
  //                                           ),
  //                                           Text(
  //                                             "Select from gallery",
  //                                             style: GoogleFonts.roboto(
  //                                               textStyle: const TextStyle(
  //                                                 color: Colors.black54,
  //                                                 fontSize: 14,
  //                                                 fontWeight: FontWeight.w500,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ]),
  //                                       ),
  //                                       const SizedBox(
  //                                         height: 15,
  //                                       ),
  //                                     ]),
  //                               ),
  //                             );
  //                           });
  //                         },
  //                       );
  //                     },
  //                     child: Stack(
  //                       clipBehavior: Clip.none,
  //                       children: [
  //                         Container(
  //                           height: 100,
  //                           decoration: BoxDecoration(
  //                             color: Colors.transparent,
  //                             borderRadius: BorderRadius.circular(12),
  //                             border:
  //                                 Border.all(width: 1, color: Colors.orange),
  //                           ),
  //                           child: imageFile == null
  //                               ? Center(
  //                                   child: Icon(
  //                                     Icons.add_a_photo_outlined,
  //                                     color: Colors.black38,
  //                                   ),
  //                                 )
  //                               : ClipRRect(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   child: Image.file(
  //                                     imageFile!,
  //                                     fit: BoxFit.cover,
  //                                     width: double.infinity,
  //                                   ),
  //                                 ),
  //                         ),
  //                       ],
  //                     ),
  //                     ),
  //                   ),
  //
  //                   SizedBox(
  //                   height: 30,
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     complainPopUp(id, _textController.text,imageFile);
  //                     // complainPopUp(id);
  //                     Navigator.pop(context);
  //                     },
  //                   child: ButtonWidget(
  //                     text: "Send",
  //                     color: const Color(0xffFF9228),
  //                     textColor: Colors.white,
  //                     width: 100,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  void _ShowDialoguePopText(String id, {required title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text("$title"),
            content: Container(
              height: 300,
              child: Column(
                children: [
                  TextField(
                    maxLines: 3,
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
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 10),

                  // Container(
                  // alignment: Alignment.center,
                  // width: double.infinity,
                  // child: GestureDetector(
                  //   onTap: () {
                  //     showModalBottomSheet(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.only(
                  //           topRight: Radius.circular(25),
                  //           topLeft: Radius.circular(25),
                  //         ),
                  //       ),
                  //       context: context,
                  //       builder: (BuildContext bc) {
                  //         return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  //           return BackdropFilter(
                  //             filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                  //             child: Container(
                  //               padding: EdgeInsets.all(20),
                  //               child: Column(mainAxisSize: MainAxisSize.min, children: [
                  //                 GestureDetector(
                  //                   onTap: () async {
                  //                     Navigator.pop(context);
                  //                     File? pickedImage = await _getFromCamera();
                  //                     setState(() {
                  //                       _imageFile1 = pickedImage; // Update the selected image
                  //                     });
                  //                   },
                  //                   child: Row(children: [
                  //                     Icon(
                  //                       Icons.camera_alt_outlined,
                  //                       color: Colors.blue,
                  //                     ),
                  //                       SizedBox(width: 20),
                  //                       Text(
                  //                       "Take Photo",
                  //                       style: TextStyle(
                  //                         color: Colors.black54,
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w500,
                  //                          ),
                  //                        ),
                  //                      ],
                  //                     ),
                  //                   ),
                  //                 SizedBox(height: 20),
                  //                 GestureDetector(
                  //                   onTap: () async {
                  //                     Navigator.pop(context);
                  //                     File? pickedImage1 = await _getFromGallery();
                  //                     setState(() {
                  //                       _imageFile1 = pickedImage1; // Update the selected image
                  //                     });
                  //                   },
                  //                   child: Row(children: [
                  //                     Image.asset(
                  //                       "assets/images/gallery.png",
                  //                       width: 25,
                  //                       color: Colors.blue,
                  //                     ),
                  //                     SizedBox(width: 20),
                  //                     Text(
                  //                       "Select from gallery",
                  //                       style: TextStyle(
                  //                         color: Colors.black54,
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w500,
                  //                       ),
                  //                     ),
                  //                   ]),
                  //                   ),
                  //                   SizedBox(height: 15),
                  //                   ]),
                  //                 ),
                  //               );
                  //             });
                  //           },
                  //         );
                  //       },
                  //     child: Stack(
                  //     clipBehavior: Clip.none,
                  //     children: [
                  //       Container(
                  //         height: 100,
                  //         decoration: BoxDecoration(
                  //           color: Colors.transparent,
                  //           borderRadius: BorderRadius.circular(12),
                  //           border: Border.all(width: 1, color: Colors.orange),
                  //         ),
                  //         child: _imageFile1 == null
                  //             ? Center(
                  //           child: Icon(
                  //             Icons.add_a_photo_outlined,
                  //             color: Colors.black38,
                  //               ),
                  //             )
                  //             : ClipRRect(
                  //           borderRadius: BorderRadius.circular(12),
                  //           child: Image.file(
                  //             _imageFile1!,
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //    ),
                  //  ),
                  // ),

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
                                  (BuildContext context, StateSetter setState) {
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
                                              await _getFromCamera1();
                                            },
                                            child: Row(children: [
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "Take Photo",
                                                style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                              await _getFromGallery1();
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
                                                  textStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                            ? Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      width: 1, color: Colors.orange),
                                ),
                                // radius: 45,
                                child: Container(
                                    // decoration: BoxDecoration(
                                    //   color: Colors.transparent,
                                    //   borderRadius: BorderRadius.circular(12),
                                    //   border: Border.all(
                                    //       width: 1, color: Colors.orange),
                                    // ),
                                    // child: Image.asset(
                                    //   'assets/images/people.webp',
                                    //   fit: BoxFit.cover,
                                    //   width: 90.0, // adjust width as needed
                                    //   height: 90.0, // adjust height as needed
                                    // ),
                                    ),
                              )
                            : Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Image.file(
                                  imageFile!,
                                  // 'assets/images/people.webp',
                                  fit: BoxFit.cover,
                                  // width: 90.0, // adjust width as needed
                                  // height: 90.0, // adjust height as needed
                                ),
                              ),
                        Positioned(
                          // bottom: ,
                          // right: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Center(
                              child: CircleAvatar(
                                // radius: 16,
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.black38,
                                  // width: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      complainPopUp(id, _textController.text,
                          _imageFile1); // Pass the selected image file
                      Navigator.pop(context);
                    },
                    child: ButtonWidget(
                      text: "Send",
                      color: Color(0xffFF9228),
                      textColor: Colors.white,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
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

  _getFromGallery1() async {
    XFile? pickedFile1 = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile1 != null) {
      File? img = File(pickedFile1.path);
      setState(() {
        imageFile1 = img;
      });
    }
  }

  //File? _imageFile; // Variable for the first dialog
  // File? _kycImageFile; // Variable for the KYC dialog
  //
  // void _ShowDialoguePopText(String id, {required title}) {
  //   TextEditingController _textController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
  //         return AlertDialog(
  //           title: Text("$title"),
  //           content: Container(
  //             height: 300,
  //             child: Column(
  //               children: [
  //                 TextField(
  //                   maxLines: 3,
  //                   controller: _textController,
  //                   decoration: InputDecoration(
  //                     hintText: 'Text here....',
  //                     labelStyle: TextStyle(color: Colors.orange),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide(color: Colors.orange),
  //                     ),
  //                     disabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide(color: Colors.orange),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide(color: Colors.orange),
  //                     ),
  //                     contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10),
  //                   ),
  //                   keyboardType: TextInputType.text,
  //                   onChanged: (value) {},
  //                 ),
  //                 SizedBox(height: 10),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     File? pickedImage = await _getFromGallery();
  //                     if (pickedImage != null) {
  //                       setState(() {
  //                         _imageFile = pickedImage;
  //                       });
  //                     }
  //                   },
  //                   child: Container(
  //                     height: 100,
  //                     decoration: BoxDecoration(
  //                       color: Colors.transparent,
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(width: 1, color: Colors.orange),
  //                     ),
  //                     child: _imageFile == null
  //                         ? Center(
  //                             child: Icon(
  //                               Icons.add_a_photo_outlined,
  //                               color: Colors.black38,
  //                             ),
  //                           )
  //                         : ClipRRect(
  //                             borderRadius: BorderRadius.circular(12),
  //                             child: Image.file(
  //                               _imageFile!,
  //                               fit: BoxFit.cover,
  //                               width: double.infinity,
  //                             ),
  //                           ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 30),
  //                 GestureDetector(
  //                   onTap: () {
  //                     complainPopUp(id, _textController.text, _imageFile);
  //                     Navigator.pop(context);
  //                   },
  //                   child: ButtonWidget(
  //                     text: "Send",
  //                     color: Color(0xffFF9228),
  //                     textColor: Colors.white,
  //                     width: 100,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }
  //
  // void _ShowDialogueKyc(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
  //         return AlertDialog(
  //           title: Text('KYC Verification'),
  //           content: Container(
  //             height: 300,
  //             width: MediaQuery.of(context).size.width,
  //             child: Column(
  //               children: [
  //                 // Other fields for KYC dialog
  //                 SizedBox(height: 20),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     File? pickedImage = await _getFromGalleryForKYC();
  //                     if (pickedImage != null) {
  //                       setState(() {
  //                         _kycImageFile = pickedImage;
  //                       });
  //                     }
  //                   },
  //                   child: Container(
  //                     height: 100,
  //                     decoration: BoxDecoration(
  //                       color: Colors.transparent,
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(width: 1, color: Colors.orange),
  //                     ),
  //                     child: _kycImageFile == null
  //                         ? Center(
  //                             child: Icon(
  //                               Icons.add_a_photo_outlined,
  //                               color: Colors.black38,
  //                             ),
  //                           )
  //                         : ClipRRect(
  //                             borderRadius: BorderRadius.circular(12),
  //                             child: Image.file(
  //                               _kycImageFile!,
  //                               fit: BoxFit.cover,
  //                               width: double.infinity,
  //                             ),
  //                           ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 40),
  //                 GestureDetector(
  //                   onTap: () {
  //                     updateKyc();
  //                   },
  //                   child: ButtonWidget(
  //                     text: "Submit",
  //                     color: const Color(0xffFF9228),
  //                     textColor: Colors.white,
  //                     width: 130,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      File? img = File(pickedFile.path);
      setState(() {
        imageFile1 = img;
      });
    }
  }

  _getFromCamera1() async {
    XFile? pickedFile1 = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile1 != null) {
      File? img = File(pickedFile1.path);
      setState(() {
        imageFile1 = img;
      });
    }
  }
}
// https://madadguru.webkype.net/api/addComplain
//
// category_id:38
// message:test

// void _ShowDialoguePopText(String id, {required title}) {
//   TextEditingController _textController = TextEditingController();
//   File? _imageFile; // Variable to store the selected image
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
//         return AlertDialog(
//           title: Text("$title"),
//           content: Container(
//             height: 300,
//             child: Column(
//               children: [
//                 TextField(
//                   maxLines: 3,
//                   controller: _textController,
//                   decoration: InputDecoration(
//                     hintText: 'Text here....',
//                     labelStyle: TextStyle(color: Colors.orange),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.orange),
//                     ),
//                     disabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.orange),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.orange),
//                     ),
//                     contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10),
//                   ),
//                   keyboardType: TextInputType.text,
//                   onChanged: (value) {},
//                 ),
//                 SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () async {
//                     // Open gallery to select an image
//                     File? pickedImage = await _getFromGallery();
//                     if (pickedImage != null) {
//                       setState(() {
//                         _imageFile = pickedImage; // Update the selected image
//                       });
//                     }
//                   },
//                   child: Container(
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(width: 1, color: Colors.orange),
//                     ),
//                     child: _imageFile == null
//                         ? Center(
//                       child: Icon(
//                         Icons.add_a_photo_outlined,
//                         color: Colors.black38,
//                       ),
//                     )
//                         : ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.file(
//                         _imageFile!,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 GestureDetector(
//                   onTap: () {
//                     complainPopUp(id, _textController.text, _imageFile); // Pass the selected image file
//                     Navigator.pop(context);
//                   },
//                   child: ButtonWidget(
//                     text: "Send",
//                     color: Color(0xffFF9228),
//                     textColor: Colors.white,
//                     width: 100,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
//     },
//   );
// }

// void complainPopUp(String id, String message,String imageFile) async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs != null) {
//              var usertoken = prefs.getString('token');
//              if (usertoken != null) {
//              final Uri uri =
//              Uri.parse("https://madadguru.webkype.net/api/addComplain");
//              final response = await http.post(
//              uri,
//              headers: {
//               'Authorization': 'Bearer $usertoken',},
//               body: {
//             "category_id": id,
//             "message": message,
//                "image": imageFile,
//           },
//         );
//         if (response.statusCode == 200) {
//           print('ResponseaddComplain: ${response.body}');
//
//           var Data = jsonDecode(response.body);
//           if (Data['status'] == 200 && Data['success'] == true) {
//             print(
//                 'ResponseaddComplain sent successfully: ${Data['message']}');
//           } else {
//             print('Failed to send ResponseaddComplain: ${Data['message']}');
//           }
//         } else {
//           print(
//               'API request failed with status code: ${response.statusCode}');
//         }
//       } else {
//         print('No token found in SharedPreferences.');
//       }
//     } else {
//       print('SharedPreferences is null.');
//     }
//   } catch (error) {
//     print('Error: $error');
//   }
// }
