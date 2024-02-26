import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../AllWidgets/buttons.dart';

class feedScreenPost extends StatefulWidget {
  final String device;
  final int postId;
  const feedScreenPost({
    super.key,
    required this.device,
    required this.postId,
  });
  @override
  State<feedScreenPost> createState() => _feedScreenPostState();
}

class _feedScreenPostState extends State<feedScreenPost> {
  bool isLoading = false;
  Map jsonData = {};
  TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print("TheUserdPost:${widget.postId}");
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getPostDetails");
      try {
        final response = await http.post(uri, headers: {
          'Authorization': 'Bearer $usertoken',
        }, body: {
          'post_id': widget.postId.toString(),
        });
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("object $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            setState(() {
              jsonData = userData;
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
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // void complainPopUp(String id) async {
  //   TextEditingController _textController = TextEditingController();
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     if (prefs != null) {
  //       var usertoken = prefs.getString('token');
  //       if (usertoken != null) {
  //         final Uri uri = Uri.parse("https://madadguru.webkype.net/api/addPostEnquiry");
  //         final response = await http.post(
  //           uri,
  //           headers: {
  //             'Authorization': 'Bearer $usertoken',
  //           },
  //           body: {
  //             "post_id": id.toString(),
  //             "message": _textController.text,
  //           },
  //         );
  //         if (response.statusCode == 200) {
  //           print('ResponseEnquiry: ${response.body}');
  //
  //         } else {
  //           print('API request failed with status code: ${response.statusCode}');
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
  void addPostEnquiryPopUp(String id, String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs != null) {
        var usertoken = prefs.getString('token');
        if (usertoken != null) {
          final Uri uri =
              Uri.parse("https://madadguru.webkype.net/api/addPostEnquiry");
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $usertoken',
            },
            body: {
              "post_id": id,
              "message": message,
            },
          );
          if (response.statusCode == 200) {
            print('addPostEnquiry: ${response.body}');
            var Data = jsonDecode(response.body);
            if (Data['status'] == 200 && Data['success'] == true) {
              print('Complaint sent successfully: ${Data['message']}');
            } else {
              print('Failed to send complaint: ${Data['message']}');
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

  // TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          "Post",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: [
                  Card(
                    elevation: 2,
                    // color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              color: Colors.grey.shade200,
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: ClipOval(
                                          child: jsonData.containsKey(
                                                  'add_by_user_image')
                                              ? Image.network(
                                                  jsonData['add_by_user_image'],
                                                  fit: BoxFit.cover,
                                                  width:
                                                      90.0, // adjust width as needed
                                                  height:
                                                      90.0, // adjust height as needed
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

                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (jsonData["add_by_user_name"] !=
                                                    null)
                                                ? jsonData["add_by_user_name"]
                                                : 'Name not available',
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "Type: ${(jsonData["add_by_user_type"] != null) ? jsonData["add_by_user_type"] : 'Name not available'}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ]),
                                  ),

                                  Container(
                                    //   height: 40,
                                    // width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.black26),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(child: Text('Paid')),
                                    ),
                                  )
                                  // Image.asset('assets/images/x.png',height: 10,width: 10,)
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5),
                            child: Text(
                              (jsonData["problem_statement"] != null)
                                  ? jsonData["problem_statement"]
                                  : 'Name not available',
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Container(
                              color: Colors.black,
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                (jsonData["post_images"][0]["image"] != null)
                                    ? jsonData["post_images"][0]["image"]
                                    : 'Name not available',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Party: ${(jsonData["second_party"] != null) ? jsonData["second_party"] : 'Name not available'}",
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Problem description",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          (jsonData["problem_desc"] != null)
                              ? jsonData["problem_desc"]
                              : 'Name not available',
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    color: Colors.white,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Information's -:",
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (jsonData["category_name"] != null)
                                        ? jsonData["category_name"]
                                        : 'not available',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "Category",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                                SizedBox(
                                height: 10,
                              ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                  children: [
                                  Text(
                                    "Select Topic",
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    (jsonData["topic_name"] != null)
                                        ? jsonData["topic_name"]
                                        : 'Name not available',
                                    style: GoogleFonts.roboto(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "2nd party (if Any)",
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        (jsonData["second_party"] != null)
                                            ? jsonData["second_party"]
                                            : 'Name not available',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Problem Started State",
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        (jsonData["problem_statement"] != null)
                                            ? jsonData["problem_statement"]
                                            : 'Name not available',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Reported From Madadguru",
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        (jsonData["already_reported"] != null)
                                            ? jsonData["already_reported"]
                                            : 'Name not available',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Financial Status",
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        (jsonData["financial_status"] != null)
                                            ? jsonData["financial_status"]
                                            : 'Name not available',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Problem Month/Year",
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        " ${(jsonData["problem_start_month"] != null) ?
                                        jsonData["problem_start_month"] : 'Name not available'}-"
                                            "${(jsonData["problem_start_year"] != null) ? jsonData["problem_start_year"] : 'Name not available'}",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                        ),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Exp. Month/Year",
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    " ${(jsonData["exp_solution_month"] != null) ? jsonData["exp_solution_month"] : 'Name not available'}-${(jsonData["exp_solution_year"] != null) ? jsonData["exp_solution_year"] : 'Name not available'}",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ]),
                      ),
                    ),
                  ),
                        GestureDetector(
                        onTap: () {
                         showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Enter your Complains'),
                              content: Container(
                                height: 200,
                                child: Column(
                                  children: [
                                    TextField(
                                      maxLines: 5,
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        hintText: 'Text here....',
                                        labelStyle:
                                            TextStyle(color: Colors.orange),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide:
                                              BorderSide(color: Colors.orange),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide:
                                              BorderSide(color: Colors.orange),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide:
                                              BorderSide(color: Colors.orange),
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
                                      onTap: () {
                                           addPostEnquiryPopUp(widget.postId.toString(),
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
                    //   showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return AlertDialog(
                    //           title: Text('Enter Your Request'),
                    //           content: Container(
                    //             height: 200,
                    //             child: Column(
                    //               children: [
                    //                 TextField(
                    //                   maxLines: 5,
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
                    //                     contentPadding: EdgeInsets.only(
                    //                         left: 10, right: 10, bottom: 10, top: 10),
                    //                   ),
                    //                   keyboardType: TextInputType.text,
                    //                   onChanged: (value) {
                    //                     // Handle text changes
                    //                   },
                    //                 ),
                    //                 SizedBox(
                    //                   height: 15,
                    //                 ),
                    //                 GestureDetector(
                    //                   onTap: () {
                    //                     Navigator.pop(context);
                    //                   },
                    //                   child: ButtonWidget(
                    //                     text: "Save",
                    //                     color: const Color(0xffFF9228),
                    //                     textColor: Colors.white,
                    //                     width: 100,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //
                    //         );
                    //       });
                    // },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 30, left: 30, top: 20, bottom: 20),
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
                              'Contact',
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
                ]),
              ),
      ),
    );
  }
}
