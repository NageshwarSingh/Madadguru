import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madadguru/Allwidgets/background_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class SubcriptionScreen extends StatefulWidget {
  final String device;
  const SubcriptionScreen({super.key, required this.device});
  @override
  State<SubcriptionScreen> createState() => _SubcriptionScreenState();
}
class _SubcriptionScreenState extends State<SubcriptionScreen> {
  bool isLoading = false;
  Map<String, dynamic> JsonDataGet = {};
  @override
  initState() {
    super.initState();
    getSubscription();
  }

  Future<void> getSubscription() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getSubscription");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },

        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print(
              "Response: $responseData"); // Print the entire response for debugging
          if (responseData != null && responseData['success'] == true) {
            var userData = responseData['data'];
            print("UserData: $userData"); // Print userData for debugging
            if (userData != null && userData is List) {
              setState(() {
                JsonDataGet = {
                  'data': List<Map<String, dynamic>>.from(userData)
                };
                print('API response: ${JsonDataGet}');
              });
            } else {
              print('Data is null or not a List');
            }
          } else {
            print(
                'API request failed or success is false: ${responseData?["message"]}');
          }
          print('Data fetched successfully');
          print(response.body);
        } else {
          print('API request failed with status code: ${response.statusCode}');
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

  Map<String, dynamic> JsonDataBuy = {};


  Future<void> buySubscription(int postId) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/buySubscription");
      try {
        final response = await http.post(uri, headers: {
          'Authorization': 'Bearer $usertoken',
        }, body: {
          "plan_id": postId.toString(),
        });
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("Response: $responseData"); // Print the entire response for debugging
          if (responseData != null && responseData['success'] == true) {

            await getSubscription();
          } else {
            print('API request failed or success is false: ${responseData?["message"]}');
          }
          print('Data fetched successfully');
          print(response.body);
        } else {
          print('API request failed with status code: ${response.statusCode}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body:isLoading?
      Center(child: CircularProgressIndicator(),):Stack(
        children: [
          Background(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 40,),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),SizedBox(width: 15,),
                    Text(
                      'Subscriptions',
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 18,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: buildView1()),
                // buildView2(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildView1() {
    return JsonDataGet.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 250),
            child: Center(
              child: CircularProgressIndicator(
                // radius: 30,
                color: Colors.indigo[900],
              ),
            ),
          )
        : JsonDataGet['data'].length == 0
            ? Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Center(
                  child: Text(
                    'No Post Available',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                )
                : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: JsonDataGet['data'].length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                  var post = JsonDataGet['data'][index];
                  bool isActive = post['is_active'] == '1';

                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Card(
                      elevation: 2,
                      child: Container(
                        height: 265,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SizedBox(height: 40,),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 10),
                              child: CircleAvatar(
                                radius: 40,
                                child: ClipOval(
                                  child: Image.network(
                                    post['icon'] ?? '',
                                    fit: BoxFit.cover,
                                    width: 80.0, // adjust width as needed
                                    height: 80.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.grey[400],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            Text(
                              (post["title"] != null)
                                  ? post["title"]
                                  : 'Not available',
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),

                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              (post["description"] != null)
                                  ? post["description"]
                                  : 'Not available',
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 35, right: 35),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        (post["type"] != null)
                                            ? post["type"]
                                            : 'Not available',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        " Amount: ${(post["amount"] != null) ? post["amount"].toString() // Convert integer to string
                                            : 'Not available'}",
                                        style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Validity: ${(post["validity"] != null) ? post["validity"] : 'Not available'}",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),

                            // Buttons based on the isActive status
                            if (isActive)
                              // Active button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, right: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Handle active button press
                                      },
                                      child: Row(
                                        children: [
                                          Text('Active',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green.shade200,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Handle cancel button press
                                      },
                                      child: Text('Cancel',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showConfirmationDialog(context,
                                        post["id"]); // Pass postId here
                                  },
                                  child: Text('Subscription',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade200,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
  }

  void _showConfirmationDialog(BuildContext context, int postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to buy this subscription?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                buySubscription(postId); // Pass postId to buySubscription
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

//
// class SubscriptionScreen extends StatefulWidget {
//   final String device;
//   final int postId;
//   const SubscriptionScreen({
//     super.key,
//     required this.device,
//     required this.postId,
//   });
//
//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
//   }
// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//
//   Map<String, dynamic> JsonDataMy = {};
//   bool isLoading = false;
//   @override
//   initState() {
//     super.initState();
//     // buySubscription();
//     }
//     Future<void> buySubscription() async {
//     setState(() {
//       isLoading = true;
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var usertoken = prefs.getString('token');
//     if (usertoken != null) {
//       final Uri uri =
//           Uri.parse("https://madadguru.webkype.net/api/buySubscription");
//          try {
//           final response = await http.post(uri, headers: {
//           'Authorization': 'Bearer $usertoken',
//         }, body: {
//           "plan_id": widget.postId.toString(),
//           });
//         if (response.statusCode == 200) {
//           var responseData = json.decode(response.body);
//           print(
//               "Response: $responseData"); // Print the entire response for debugging
//           if (responseData != null && responseData['success'] == true) {
//             var userData1 = responseData['data'];
//             if (userData1 != null && userData1 is List) {
//               setState(() {
//                 JsonDataMy = {
//                   'data': List<Map<String, dynamic>>.from(userData1)
//                 };
//                 print('API response: ${JsonDataMy}');
//                 // getSubscription();
//               });
//             }
//           } else {
//             print(
//                 'API request failed or success is false: ${responseData?["message"]}');
//           }
//           print('Data fetched successfully');
//           print(response.body);
//         } else {
//           print('API request failed with status code: ${response.statusCode}');
//         }
//       } catch (error) {
//         print('Error fetching data: $error');
//       } finally {
//         setState(() {
//           isLoading = false;
//         });
//         }
//       }
//      }
//
//   void _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirmation"),
//           content: Text("Are you sure you want to buy this subscription?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text("No"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 buySubscription();
//               },
//               child: Text("Yes"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   //
//   // Map<String, dynamic> JsonDataGet = {};
//   // Future<void> getSubscription() async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   var usertoken = prefs.getString('token');
//   //   if (usertoken != null) {
//   //     final Uri uri =
//   //     Uri.parse("https://madadguru.webkype.net/api/getSubscription");
//   //     try {
//   //       final response = await http.post(
//   //         uri,
//   //         headers: {
//   //           'Authorization': 'Bearer $usertoken',
//   //         },
//   //         //     body: {
//   //         //   'post_id': widget.id
//   //         //       .toString(), // Assuming this function returns the post ID
//   //         // }
//   //       );
//   //       if (response.statusCode == 200) {
//   //         var responseData = json.decode(response.body);
//   //         print(
//   //             "Response: $responseData"); // Print the entire response for debugging
//   //         if (responseData != null && responseData['success'] == true) {
//   //           var userData = responseData['data'];
//   //           print("UserData: $userData"); // Print userData for debugging
//   //           if (userData != null && userData is List) {
//   //             setState(() {
//   //               JsonDataGet = {
//   //                 'data': List<Map<String, dynamic>>.from(userData)
//   //               };
//   //               print('API response: ${JsonDataGet}');
//   //             });
//   //           } else {
//   //             print('Data is null or not a List');
//   //           }
//   //         } else {
//   //           print(
//   //               'API request failed or success is false: ${responseData?["message"]}');
//   //         }
//   //         print('Data fetched successfully');
//   //         print(response.body);
//   //       } else {
//   //         print('API request failed with status code: ${response.statusCode}');
//   //       }
//   //     } catch (error) {
//   //       print('Error fetching data: $error');
//   //     } finally {
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //     }
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//         return Column(
//           children: [
//             Text('data'),
//             BackButton(
//               // Your widget implementation
//               onPressed: () {
//                 _showConfirmationDialog(context);
//               },
//             ),
//           ],
//         );
//
//
//
//   }
//
// }

//   Scaffold(
//   backgroundColor: Colors.grey.shade200,
//   body: Stack(children: [
//     Background(),
//     Padding(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 30,
//           ),
//           InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Icon(Icons.arrow_back)),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Buy Subscriptions',
//                 style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           // Expanded(child: buildView1()),
//           // buildView2(),
//           SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     ),
//   ]),
// );

// Widget buildView1() {
//   return JsonDataMy.isEmpty
//       ? Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Center(
//             child: CircularProgressIndicator(
//               // radius: 30,
//               color: Colors.indigo[900],
//             ),
//           ),
//         )
//       : JsonDataMy['data'].length == 0
//           ? Padding(
//               padding: const EdgeInsets.only(top: 200),
//               child: Center(
//                 child: Text(
//                   'No Post Available',
//                   style: TextStyle(fontSize: 25),
//                 ),
//               ),
//             )
//           : ListView.builder(
//               scrollDirection: Axis.vertical,
//               itemCount: JsonDataMy['data'].length,
//               shrinkWrap: true,
//               padding: EdgeInsets.zero,
//               itemBuilder: (context, index) {
//                 var post = JsonDataMy['data'][index];
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 20.0),
//                   child: Card(
//                     elevation: 2,
//                     child: Container(
//                       height: 265,
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade100,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15, right: 15, top: 15, bottom: 10),
//                             child: CircleAvatar(
//                               radius: 40,
//                               child: ClipOval(
//                                 child: Image.network(
//                                   post['icon'] ?? '',
//                                   fit: BoxFit.cover,
//                                   width: 80.0, // adjust width as needed
//                                   height: 80.0,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Icon(
//                                       Icons.person,
//                                       size: 30,
//                                       color: Colors.grey[400],
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             (post["title"] != null)
//                                 ? post["title"]
//                                 : 'Not available',
//                             style: GoogleFonts.roboto(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             height: 3,
//                           ),
//                           Text(
//                             (post["description"] != null)
//                                 ? post["description"]
//                                 : 'Not available',
//                             style: GoogleFonts.roboto(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 20, left: 35, right: 35),
//                             child: Row(
//                               mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Text(
//                                       (post["type"] != null)
//                                           ? post["type"]
//                                           : 'Not available',
//                                       style: GoogleFonts.roboto(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       "Amount: ${(post["amount"] != null) ? post["amount"].toString() // Convert integer to string
//                                           : 'Not available'}",
//                                       style: GoogleFonts.roboto(
//                                           color: Colors.black,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       "Validity: ${(post["validity"] != null) ? post["validity"] : 'Not available'}",
//                                       style: GoogleFonts.roboto(
//                                           color: Colors.black,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                     Text(
//                                       " ${(post["expire_on"] != null) ? post["expire_on"] : 'Not available'}",
//                                       style: GoogleFonts.roboto(
//                                           color: Colors.black,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 110, right: 110, top: 10),
//                             child: Card(
//                               child: Container(
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(12),
//                                     color: Colors.white),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Active',
//                                       style: GoogleFonts.roboto(
//                                           color: Colors.green,
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               });
// }
