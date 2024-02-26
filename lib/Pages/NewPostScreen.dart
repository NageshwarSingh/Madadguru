import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Allwidgets/textForm_filed.dart';

  class NewPostScreen extends StatefulWidget {
  final String device;
  const NewPostScreen({super.key, required this.device});
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
  }
  class _NewPostScreenState extends State<NewPostScreen> {
  TextEditingController _probleDescController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _topicController = TextEditingController();
  TextEditingController _secondpartyController = TextEditingController();
  TextEditingController _problemStatementController = TextEditingController();
  TextEditingController _alreadyReportedController = TextEditingController();
  TextEditingController _financialStatusController = TextEditingController();
  TextEditingController _problemMonthController = TextEditingController();
  TextEditingController _problemYearController = TextEditingController();
  TextEditingController _solutionMonthController = TextEditingController();
  TextEditingController _solutionYearController = TextEditingController();
  var Problems;
  var problems = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  var Solutions;
  var solutions = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  var Topic;
  var topic = [
    'Private',
    'Gort Job',
    'Business',
    'Student',
    'House Wife',
    'Un-Employed',
    'NGO Worker',
    'Other',
  ];
  List<http.MultipartFile> files = [];
  File? imageFile;
  List<File> imageFiles = [];
  Map<String, dynamic> data = {};
  Map<String, dynamic>? selectedCategory;
  Map<String, dynamic>? selectedTopic;
  @override

  Future<void> addPostApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    final Uri uri = Uri.parse("https://madadguru.webkype.net/api/addPost");
    var request = http.MultipartRequest('Post', uri);
    Map<String, String> headers = {
      "Accept": "multipart/form-data",
      "Authorization": 'Bearer $usertoken',
    };
    request.headers.addAll(headers);
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('upload_document[]', imageFile!.path),
         );
        }
    request.fields['topic_id'] = selectedTopic!= null ? selectedTopic!['id'].toString() : '';
    request.fields['category_id']=   selectedCategory != null ? selectedCategory!['id'].toString() : '';
    request.fields['second_party'] = _secondpartyController.text;
    request.fields['problem_statement'] = _problemStatementController.text;
    request.fields['problem_start_month'] = _problemMonthController.text;
    request.fields['problem_start_year'] = _problemYearController.text;
    request.fields['exp_solution_month'] = _solutionMonthController.text;
    request.fields['exp_solution_year'] = _solutionYearController.text;
    request.fields['already_reported'] = _alreadyReportedController.text;
    request.fields['problem_desc'] = _probleDescController.text;
    request.fields['financial_status'] = _financialStatusController.text;
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
        Navigator.pop(context);
            // Navigator.of(context).pushAndRemoveUntil(
            //   MaterialPageRoute(
            //   builder: (context) => FeedScreen(
            //     device: widget.device,
            //
            //   ),
            // ),
            //     (route) => false);
         } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making HTTP request: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataCategory();
  }
  List<dynamic> department = [];
  List<Map<String, dynamic>> CategoryList = [];
  List<dynamic> department1 = [];
  List<Map<String, dynamic>> TopicList = [];

  String selectedCategoryId = "";

  Future<void> fetchDataCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getCategory");
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
            CategoryList = data.map((item) => {
              'id': item['id'].toString(),
              'name': item['name'],
            }).toList();
          });
          print('CategoryList: $CategoryList');
          print('Data fetched successfully');
          print(response.body);

          if (CategoryList.isNotEmpty) {
            selectedCategoryId = CategoryList[0]['id']; // Set the selected category id
            fetchDataTopic(selectedCategoryId);
          }
          print('Data fetched successfully');
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching data: $error');
      }
     }
    }

  Future<void> fetchDataTopic(String categoryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getTopic");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
          body: {
            'category_id': categoryId,
            // 'topic_id': Topic,
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          List<dynamic> data = responseData['data'] ?? [];
          List<Map<String, dynamic>> topics = [];
          for (var item in data) {
            topics.add({
              'id': item['id'].toString(),
              'name': item['name'],
            });
          }   setState(() {
            TopicList = topics;
          });

          print('TopicList: $TopicList');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Container(
          height: 45,
          alignment: Alignment.center,
        ),
        ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'I need help for:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Select Category',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 7),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                      value: selectedCategory,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                        color: Colors.black38,
                      ),
                      hint: Text(
                        "category",
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black38,
                        ),
                      ),
                      elevation: 1,
                      underline: Container(height: 1, color: Colors.orange),
                      onChanged: (Map<String, dynamic>? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                          _categoryController.text = newValue!['name'].toString();
                          // '${newValue!['id']}: ${newValue['name']}';
                        });
                        },
                      items: CategoryList.map<DropdownMenuItem<Map<String, dynamic>>>((department) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: department,
                          child: Text(
                            department['name'].toString(),
                            // '${department['id']}: ${department['name']}',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
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
                'Select topic',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),

              SizedBox(
                height: 10,
              ),


              Container(
                padding: EdgeInsets.only(left: 7),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                      value: selectedTopic,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                        color: Colors.black38,
                      ),
                      hint: Text(
                        "Topics",
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black38,
                        ),
                      ),
                      elevation: 1,
                      underline: Container(height: 1, color: Colors.orange),
                      onChanged: (Map<String, dynamic>? newValue) {
                        setState(() {
                          selectedTopic = newValue;
                          _topicController.text = newValue!['name'].toString();
                          // '${newValue!['id']}: ${newValue['name']}';
                        });
                      },
                      items: TopicList.map<DropdownMenuItem<Map<String, dynamic>>>((department1) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: department1,
                          child: Text(
                            department1['name'].toString(),
                            // '${department['id']}: ${department['name']}',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
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
                '2nd Party (if any)',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextFormFieldWidget2(
                  maxLines: 1,
                  cursorColor: Color(0xffFF9228),
                  controller: _secondpartyController,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  obscureText: false,
                  hintText: "",
                  labeltext: 'Any Party',
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Text(
                'Problem Statement',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextFormFieldWidget2(
                  maxLines: 1,
                  cursorColor: Color(0xffFF9228),
                  controller: _problemStatementController,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  obscureText: false,
                  hintText: "",
                  labeltext: 'Problem Statement',
                ),
              ),
              SizedBox(height: 10),

              Text(
                'Problem Started State:',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Container(
                  //   height: 50,
                  //   width: 170,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       color: Colors.white),
                  //   child: TextFormFieldWidget2(
                  //     maxLines: 1,
                  //     cursorColor: Color(0xffFF9228),
                  //     controller: _problemMonthController,
                  //     inputType: TextInputType.text,
                  //     inputAction: TextInputAction.next,
                  //     obscureText: false,
                  //     hintText: "",
                  //     labeltext: 'Month',
                  //   ),
                  // ),

                  Container(width: 170,
                    height: 50,
                    padding: EdgeInsets.only(left: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.transparent),
                      color: Colors.white,
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
                          value: Problems,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 30,
                            color: Colors.black38,
                          ),
                          hint: Text(
                            "Months",
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black38),
                          ),
                          elevation: 1,
                          underline: Container(height: 1, color: Colors.orange),
                          onChanged: (String? newValue) {
                            setState(() {
                              Problems = newValue!;
                              _problemMonthController.text = newValue;
                            });
                          },
                          items: problems
                              .map<DropdownMenuItem<String>>((String value) {
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
                  Container(
                    height: 50,
                    // color: Colors.orange,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: TextFormFieldWidget2(
                      maxLines: 1,
                      cursorColor: Color(0xffFF9228),
                      controller: _problemYearController,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      obscureText: false,
                      hintText: "",
                      labeltext: 'Year',
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Text(
                'Expected Solution From Madadguru',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Container(
                  //   height: 50,
                  //   width: 170,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       color: Colors.white),
                  //   child: TextFormFieldWidget2(
                  //     maxLines: 1,
                  //     cursorColor: Color(0xffFF9228),
                  //     controller: _solutionMonthController,
                  //     inputType: TextInputType.text,
                  //     inputAction: TextInputAction.next,
                  //     obscureText: false,
                  //     hintText: "",
                  //     labeltext: 'Month',
                  //   ),
                  // ),
                  Container(width: 170,
                    height: 50,
                    padding: EdgeInsets.only(left: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.transparent),
                      color: Colors.white,
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
                          value: Solutions,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 30,
                            color: Colors.black38,
                          ),
                          hint: Text(
                            "Months",
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black38),
                          ),
                          elevation: 1,
                          underline: Container(height: 1, color: Colors.orange),
                          onChanged: (String? newValue) {
                            setState(() {
                              Solutions = newValue!;
                              _solutionMonthController.text = newValue;
                            });
                          },
                          items: solutions
                              .map<DropdownMenuItem<String>>((String value) {
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



                  Container(
                    height: 50,
                    // color: Colors.orange,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: TextFormFieldWidget2(
                      maxLines: 1,
                      cursorColor: Color(0xffFF9228),
                      controller: _solutionYearController,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      obscureText: false,
                      hintText: "",
                      labeltext: 'Year',
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),
              Text(
                'Already Reported To:',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextFormFieldWidget2(
                  maxLines: 1,
                  cursorColor: Color(0xffFF9228),
                  controller: _alreadyReportedController,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  obscureText: false,
                  hintText: "",
                  labeltext: 'Reported',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Problem Description',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child:
                TextField(
                  style: TextStyle(fontSize: 12),
                  maxLines: 2,
                  controller: _probleDescController,
                  decoration: InputDecoration(
                    hintText: 'Enter the text here',
                    label: Text(
                      'Problems',
                      style: TextStyle(fontSize: 12),
                    ),
                    labelStyle:
                    TextStyle(color: Colors.black38, fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width:1.5,color: Colors.orange),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    // Handle text changes
                  },
                ),

                // ),
              ),

              SizedBox(
                height: 10,
              ),
              Text(
                'Financial Status',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextFormFieldWidget2(
                  maxLines: 1,
                  cursorColor: Color(0xffFF9228),
                  controller: _financialStatusController,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  obscureText: false,
                  hintText: "",
                  labeltext: 'Financial Status',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Upload Proof & Evidence',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),

              SizedBox(
                height: 10,
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

                      child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          // border: Border.all(width: 1, color: Colors.orange),
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
                height: 30,
              ),

              InkWell(
                onTap: () {
                  addPostApi();
                  // Navigator.pop(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 40, left: 40, bottom: 10),
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
            ],
          ),
        ),
      ),
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
