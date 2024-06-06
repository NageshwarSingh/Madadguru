import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../AllWidgets/buttons.dart';

class healthScreen extends StatefulWidget {
  final String device;
  const healthScreen({super.key, required this.device});
  @override
  State<healthScreen> createState() => _healthScreenState();
  }
class _healthScreenState extends State<healthScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> listdata = [
    {
      "name": "Mental Health",
      "Image": "assets/images/fear.png",
      "id": 1,
    },
    {
      "name": "Physical Health",
      "Image": "assets/images/exercise.png",
      "id": 2,
    }
  ];

  var name = ["Mental Health", "Physical Health"];
  var Imags = [
    "assets/images/fear.png",
    "assets/images/exercise.png",
  ];
  @override
  void initState() {
    super.initState();
    // fetchData();
    // sendSelectedAPI();
  }

  TextEditingController _textController = TextEditingController();
  Map jsonData = {};

  void doctorContactPopUp(String id, String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs != null) {
        var usertoken = prefs.getString('token');
        if (usertoken != null) {
          final Uri uri =
              Uri.parse("https://madadguru.webkype.net/api/addExpertRequest");
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $usertoken',
            },
            body: {
              "expert_id": id,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health and Education'),
         ),
         body: SingleChildScrollView(
          child: Column(
            children: [
             Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              height: 170,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/mental health.jpg',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  'Being both physically and emotionally fit is the key to success in all aspects of life. People should be aware of the consequences of mental illness and must give utmost importance to keeping the mind healthy like the way the physical body is kept healthy. Mental and physical health cannot be separated from each other.'),
              ),
            SizedBox(height: 15),
            Text(
              "Meet the mental and Physical Health Experts",
              style: GoogleFonts.roboto(
                  color: Colors.blue.shade900,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            buildListView(),
            SizedBox(height: 15),
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
      itemCount: listdata.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 0.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            _showDialogue(listdata[index]['id'],context);
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 13, right: 13, bottom: 15),
            child: SizedBox(
              height: 150, // Set a fixed height for the container
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xffED6663), Color(0xff4E89AE)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      listdata[index]["Image"],
                      height: 50, // Adjust the image height as needed
                      width: 50, // Adjust the image width as needed
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        listdata[index]["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
      },
    );
  }

  void _showDialogue(int id,
     BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Request appointment',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
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
                      contentPadding:
                          EdgeInsets.only(left: 10, right: 10, top: 10),
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
                    onTap: () async {
                      doctorContactPopUp(id.toString(),_textController.text);
                      Navigator.pop(context);
                      _textController.clear();
                      // await fetchData();
                    },
                    child: ButtonWidget(
                      text: "Submit",
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

// Widget buildListView() {
//   return jsonData.isEmpty
//       ? Padding(
//           padding: const EdgeInsets.only(top: 100),
//           child: Center(
//             child: CircularProgressIndicator(
//               // radius: 30,
//               color: Colors.indigo[900],
//             ),
//           ),
//         )
//       : jsonData["data"].length == 0
//           ? Padding(
//               padding: const EdgeInsets.only(top: 100),
//               child: Center(
//                 child: Text(
//                   'No Post Available',
//                   style: TextStyle(fontSize: 25),
//                 ),
//               ),
//             )
//           : ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.zero,
//               itemCount: jsonData["data"].length,
//               itemBuilder: (BuildContext context, int index) {
//                 var post = jsonData['data'][index];
//                 return Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Card(
//                     elevation: 2,
//                     child: Container(
//                       margin: const EdgeInsets.only(
//                         bottom: 15,
//                       ),
//                           child: Padding(
//                         padding: const EdgeInsets.only(
//                             right: 10, left: 10.0, top: 20, bottom: 10),
//                           child: Column(
//                           children: [
//                             Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(left: 10),
//                                         child: CircleAvatar(
//                                           radius: 40,
//                                           child: ClipOval(
//                                             child: Image.network(
//                                               post['image'] ?? '',
//                                               fit: BoxFit.cover,
//                                               width:
//                                                   80.0, // adjust width as needed
//                                               height: 80.0,
//                                               errorBuilder:
//                                                   (context, error, stackTrace) {
//                                                 return Icon(
//                                                   Icons.person,
//                                                   size: 50,
//                                                   color: Colors.grey[400],
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 15,
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             post['expert_category'] ?? '',
//                                             style: GoogleFonts.roboto(
//                                                 color: Colors.black,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           SizedBox(
//                                             height: 3,
//                                           ),
//                                           Text(
//                                             post['expert_name'] ?? '',
//                                             style: GoogleFonts.roboto(
//                                                 color: Colors.black,
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                           SizedBox(
//                                             height: 3,
//                                           ),
//                                           Text(
//                                             post['expert_degree'] ?? '',
//                                             style: GoogleFonts.roboto(
//                                                 color: Colors.black,
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                           SizedBox(
//                                             height: 3,
//                                           ),
//                                           Text(
//                                             post['hospital_name'] ?? '',
//                                             style: GoogleFonts.roboto(
//                                                 color: Colors.black,
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                           SizedBox(
//                                             height: 3,
//                                           ),
//                                           Text(
//                                             "Exp. ${post['expert_experience'] ?? ''} ",
//                                             style: GoogleFonts.roboto(
//                                                 color: Colors.black,
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'Consulting Fee',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Row(children: [
//
//                                         Image.asset(
//                                           'assets/images/rupee.png',
//                                           width: 15,
//                                           height: 15,
//                                         ),
//                                         Text(
//                                           // " Amount: ${(post["amount"] != null) ? post["amount"].toString() // Convert integer to string
//                                           //     : 'Not available'}",
//                                           // Consulting Fee add rupee symbol
//
//                                           "${post['expert_fees'] ?? ''} ",
//                                           style: TextStyle(
//                                             color: Colors.blue.shade900,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ]),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//
//                                           _showDialogue(context,post["id"]);
//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(12)),
//                                               color: Colors.orange.shade300,
//                                               border: Border.all(
//                                                   width: 1,
//                                                   color: Color(0xffFBCD96),
//                                                      ),
//                                                        ),
//                                                  child: Padding(
//                                                  padding: const EdgeInsets.all(8.0),
//                                                 child: Text(
//                                               'Book Now',
//                                                 style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ]),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               });
// }
// Widget buildListView() {
//   return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.zero,
//       itemCount: listdata.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 1.0,
//         mainAxisSpacing: 0.0,
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         return InkWell(
//           onTap: () {
//             _showDialogue(listdata[index]['id'],
//               context,
//             );
//
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(
//                 top: 5, left: 13, right: 13, bottom: 15),
//             child: SizedBox(
//               child: Container(
//                 width: 165, // Adjust size based on constraints
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: LinearGradient(
//                     colors: [
//                       Color(0xffED6663),
//                       Color(0xff4E89AE),
//                     ],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                 ),
//                 child: Column(
//                   // crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       listdata[index]["Image"],
//                       height: 30,
//                       width: 30,
//                       color: Colors.white,
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 8, right: 8, top: 8.0),
//                       child: Text(
//                         listdata[index]["name"],
//
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       });
// }

// Container(
//   height: 50,
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: textList.length,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) => GestureDetector(
//           onTap: () async {
//             // String postId = DataList[index]["id"].toString();
//             // await getPost(postId);
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(left: 5, right: 5.0),
//             child: Center(
//               // child: Text(
//               //   textList[index],
//               //   textAlign: TextAlign.center,
//               //   style: GoogleFonts.roboto(
//               //     fontSize: 16,
//               //     color: Colors.blue.shade900,
//               //     fontWeight: FontWeight.w600,
//               //   ),
//               // ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
//   InkWell(
//   // onTap: () {
//   //   _ShowDialoguePopText(DataList[index]['id'],
//   //       title: DataList[index]['name']);
//   // },
//
//   child: Padding(
//     padding: const EdgeInsets.only(
//         top: 10, left: 13, right: 13, bottom: 5),
//     child: SizedBox(
//       child: Card(
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Container(
//             width: 165,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               // mainAxisAlignment: MainAxisAlignment.,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius:
//                             BorderRadius.circular(60),
//                       ),
//                       child: CircleAvatar(
//                         radius: 46,
//                         backgroundColor: Colors.black38,
//                         child: CircleAvatar(
//                           radius: 45,
//                           child: ClipOval(
//                             child: Image.network(
//                               post['image'] ?? '',
//                               fit: BoxFit.cover,
//                               width:
//                                   90.0, // adjust width as needed
//                               height: 90.0,
//                               errorBuilder: (context, error,
//                                   stackTrace) {
//                                 return Icon(
//                                   Icons.person,
//                                   size: 50,
//                                   color: Colors.grey[400],
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   width: 40,
//                 ),
//                 Column(
//                   // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           post['expert_name'] ?? '',
//                           style: TextStyle(
//                             color: Colors.blue.shade900,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(
//                           width: 50,
//                         ),
//                         Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Image.asset(
//                                   'assets/images/rupee.png',
//                                   width: 15,
//                                   height: 15,
//                                 ),
//                                 Text(
//                                   // " Amount: ${(post["amount"] != null) ? post["amount"].toString() // Convert integer to string
//                                   //     : 'Not available'}",
//
//                                   // Consulting Fee add rupee symbol
//
//                                   "${post['expert_fees'] ?? ''} ",
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 12,
//                                     fontWeight:
//                                         FontWeight.w500,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(Radius.circular(12)),
//                                   border: Border.all(
//                                       width: 1,
//                                       color: Colors
//                                           .blue.shade900)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text('Book Now'),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                     Text(
//                       post['expert_degree'] ?? '',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     Text(
//                       // Exp:
//                       post['expert_experience'] ?? '',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     Text(
//                       post['hospital_name'] ?? '',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     // Text(
//                     //   // " Amount: ${(post["amount"] != null) ? post["amount"].toString() // Convert integer to string
//                     //   //     : 'Not available'}",
//                     //
//                     //   // Consulting Fee add rupee symbol
//                     //
//                     //   "Consulting Fee: Rs.${post['expert_fees'] ?? ''} ",
//                     //   style: TextStyle(
//                     //     color: Colors.black,
//                     //     fontSize: 12,
//                     //     fontWeight: FontWeight.w500,
//                     //   ),
//                     //   textAlign: TextAlign.center,
//                     //   ),
//
//                     //   Button Add== Book Now
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   ),
// );
// InkWell(
//   onTap: () {
//     // _ShowDialogueVolunteer(context);
//   },
//   // onTap: () {
//   //   if (_formKey.currentState!.validate()) addPostApi();
//   // },
//   child: Padding(
//     padding: const EdgeInsets.only(right: 50, left: 50, bottom: 30),
//     child: Card(
//       elevation: 2,
//       child: Container(
//         height: 45,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: Color(0xffFBCD96)),
//         child: Center(
//           child: Text(
//             'Submit',
//             style: TextStyle(
//                 color: Colors.orange,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 17),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
// Future<void> fetchData() async {
//   setState(() {
//     isLoading = true;
//   });
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var usertoken = prefs.getString('token');
//   if (usertoken != null) {
//     final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getExpert");
//     try {
//       final response = await http.post(
//         uri,
//         headers: {
//           'Authorization': 'Bearer $usertoken',
//         },
//       );
//       if (response.statusCode == 200) {
//         var responseData = json.decode(response.body);
//         print("volunteer $responseData");
//         if (responseData is List) {
//           setState(() {
//             jsonData = {"data": responseData};
//           });
//           } else if (responseData is Map && responseData.containsKey('data')) {
//           setState(() {
//             jsonData = responseData;
//           });
//         } else {
//           print('API request failed: ${responseData["message"]}');
//         }
//         print('Data fetched successfully');
//         print(response.body);
//       } else {
//         print('Failed to fetch data. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//     }
//   }
// }
