import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../AllWidgets/buttons.dart';

class SpiritualScreen extends StatefulWidget {
  final String device;
  const SpiritualScreen({super.key, required this.device});
  @override
  State<SpiritualScreen> createState() => _SpiritualScreenState();
}

class _SpiritualScreenState extends State<SpiritualScreen> {
  bool isLoading = false;
  int selectedButtonIndex =
      -1;
  String value="";

  // void onTap(int index) {
  //   setState(() {
  //     selectedButtonIndex = index; // Update the selectedButtonIndex when an item is tapped
  //   });
  // }

  void onTap(int index) {
    setState(() {
      selectedButtonIndex =
          index; // Update the selectedButtonIndex when an item is tapped
    });
  }

  List<String> textList = [
    "#Meditation",
    "#Gratitude",
    "#Fasting",
    "#Silence",
    "#Study",
    "#Prayer",
  ];
  @override
  void initState() {
    super.initState();
    fetchData();
    // sendSelectedAPI();
  }

  Map jsonData = {};
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getGuru");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("volunteer $responseData");
          if (responseData is List) {
            setState(() {
              jsonData = {"data": responseData};
            });
          } else if (responseData is Map && responseData.containsKey('data')) {
            setState(() {
              jsonData = responseData;
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
  final formKey = GlobalKey<FormState>();
  List<String> formValue = [];
  int tag = 3;
  List<String> tags = ['Education'];
  List<String> options = [
    'News',
    'Entertainment',
    'Politics',
    'Automotive',
    'Sports',
    'Education',
    'Fashion',
    'Travel',
    'Food',
    'Tech',
    'Science',
  ];

  // String? user;
  // final usersMemoizer = C2ChoiceMemoizer<String>();
  // Future<List<C2Choice<String>>> getUsers() async {
  //   try {
  //     String url =
  //         "https://randomuser.me/api/?inc=gender,name,nat,picture,email&results=25";
  //     var res = await Dio().get(url);
  //     return C2Choice.listFrom<String, dynamic>(
  //       source: res.data['results'],
  //       value: (index, item) => item['email'],
  //       label: (index, item) =>
  //           item['name']['first'] + ' ' + item['name']['last'],
  //       avatarImage: (index, item) =>
  //           NetworkImage(item['picture']['thumbnail']),
  //       meta: (index, item) => item,
  //     )..insert(0, const C2Choice<String>(value: 'all', label: 'All'));
  //   } on DioError catch (e) {
  //     throw ErrorDescription("message");
  //   }
  // }
  List<String> selectedItems = [];
  // void toggleOption(int index) {
  //   setState(() {
  //     if (selectedItems.contains(textList[index])) {
  //       selectedItems.remove(textList[index]);
  //     } else {
  //       selectedItems.add(textList[index]);
  //     }
  //   });
  // }
  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }
  List<String> selectedOptions = [];
  // Future<void> sendSelectedAPI() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var usertoken = prefs.getString('token');
  //   if (usertoken != null) {
  //     final Uri uri =
  //         Uri.parse("https://madadguru.webkype.net/api/addGuruRequest");
  //     try {
  //       final response = await http.post(
  //         uri,
  //         headers: {
  //           'Authorization': 'Bearer $usertoken',
  //         },
  //         body: {
  //           "guru_type": selectedOptions.join(','),
  //         },
  //       );
  //       print(" response${response}");
  //       if (response.statusCode == 200) {
  //         print(response.body);
  //
  //         print('options selection sent to API successfully.');
  //               } else {
  //         print('Failed to send options selection to API. Status code: ${response.statusCode}');
  //       }
  //     } catch (error) {
  //       print('Error sending options selection to API: $error');
  //     }
  //
  //
  //   }
  // }

  void sendSelectedAPI(String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs != null) {
        var usertoken = prefs.getString('token');
        if (usertoken != null) {
          final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/addGuruRequest");
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $usertoken',
            },
            body: {
              "guru_type": selectedOptions.join(','),
            },
          );
          if (response.statusCode == 200) {
            print('option: ${response.body}');
            var Data = jsonDecode(response.body);
            if (Data['status'] == 200 && Data['success'] == true) {
              print('option sent successfully: ${Data['message']}');
            } else {
              print('Failed to send option: ${Data['message']}');
            }
          } else {
            print(
                'API request failed with status code: ${response.statusCode}');
          }
        } else {
          print('No token found ');
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
        title: Text("Spiritual Connect"),
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
                            'assets/images/baba.jpg',
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
                  'Spirituality involves the recognition of a feeling or sense or belief that there is something greater than myself, something more to being human than sensory experience, and that the greater whole of which we are part is cosmic or divine in nature.'),
            ),
            Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: textList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () async {
                        // String postId = DataList[index]["id"].toString();
                        // await getPost(postId);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5.0),
                        child: Center(
                          child: Text(
                            textList[index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            buildListView(),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                _ShowDialogueVolunteer(context);
                },
                  // onTap: () {
              //   if (_formKey.currentState!.validate()) addPostApi();
              // },
              child: Padding(
                padding: const EdgeInsets.only(right: 50, left: 50, bottom: 30),
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
                        'Submit',
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
    );
  }
  Widget buildListView() {
    return jsonData.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: CircularProgressIndicator(
                // radius: 30,
                color: Colors.indigo[900],
              ),
            ),
          )
        : jsonData["data"].length == 0
            ? Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    'No Post Available',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: jsonData["data"].length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 0.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var post = jsonData['data'][index];
                  return InkWell(
                    // onTap: () {
                    //   _ShowDialoguePopText(DataList[index]['id'],
                    //       title: DataList[index]['name']);
                    // },

                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 13, right: 13, bottom: 25),
                      child: SizedBox(
                        child: Container(
                          width: 165,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: CircleAvatar(
                                  radius: 46,
                                  backgroundColor: Colors.black38,
                                  child: CircleAvatar(
                                    radius: 45,
                                    child: ClipOval(
                                      child: Image.network(
                                        post['image'] ?? '',
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
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 10.0),
                                child: Text(
                                  post['guru_name'] ?? '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                post['aashram_name'] ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                post['aashram_address'] ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
  }
  void _ShowDialogueVolunteer(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Spiritual Request'),
          content: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      elevation: 2,
                      child: Container(
                        height: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage('assets/images/baba.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: textList.map((item) {
                          final isSelected = selectedOptions.contains(item);
                          return InkWell(
                            onTap: () {
                              print("Item tapped: $item");
                              setState(() {
                                toggleOption(item);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 1,
                                      color:  getColorForItem(item),
                                      // selectedOptions.contains(item)  ? Colors.orange : Colors.blue.shade900,
                                    ),
                                  ),
                                    child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      item,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:  selectedOptions.contains(item) ? Colors.orange : Colors.blue.shade900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    sendSelectedAPI(value);
                    Navigator.pop(context);
                    await fetchData();
                  },

                  child: Card(
                    elevation: 2,
                    child: ButtonWidget(
                      text: "Send",
                      color: Color(0xffFBCD96),
                      textColor: Colors.orange,
                      width: 130,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Color getColorForItem(String item) {
    return selectedOptions.contains(item) ? Colors.orange : Colors.blue.shade900;
  }
  // void _ShowDialogueVolunteer(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           title: Text(
  //             'Spiritual Request',
  //           ),
  //           content: Container(
  //             height: 300,
  //             width: MediaQuery.of(context).size.width,
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //
  //                 Container(
  //                   margin: const EdgeInsets.only(bottom: 10),
  //                   height: 150,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(left: 10, right: 10),
  //                     child: Card(
  //                       elevation: 2,
  //                       child: Container(
  //                         height: 170,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(12),
  //                           image: DecorationImage(
  //                               image: AssetImage('assets/images/baba.jpg'),
  //                               fit: BoxFit.cover),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //
  //                 Container(
  //                   height: 50,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: SingleChildScrollView(
  //                       scrollDirection: Axis.horizontal,
  //                       child: ListView.builder(
  //                         shrinkWrap: true,
  //                         itemCount: textList.length,
  //                         scrollDirection: Axis.horizontal,
  //                         itemBuilder: (context, index) => GestureDetector(
  //                           onTap: ()  {
  //                             toggleOption(index);
  //
  //                             // String postId = DataList[index]["id"].toString();
  //                             // await getPost(postId);
  //
  //                           },
  //                           child: Padding(
  //                             padding:
  //                                 const EdgeInsets.only(left: 5, right: 5.0),
  //                             child: Center(
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   border: Border.all(
  //                                       width: 1,
  //                                       color: selectedButtonIndex == index
  //                                           ? Colors.orange
  //                                           : Colors.blue.shade900),
  //                                 ),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(5.0),
  //                                   child: Center(
  //                                     child: GestureDetector(
  //                                       onTap: () {
  //                                         onTap(index);
  //                                         Navigator.pop(context);
  //                                       },
  //                                       child: Text(
  //                                         textList[
  //                                             index], // Display the text from textList at the current index
  //                                         textAlign: TextAlign.center,
  //                                         style: GoogleFonts.roboto(
  //                                           fontSize: 16,
  //                                           color: selectedButtonIndex == index
  //                                               ? Colors.orange
  //                                               : Colors.blue.shade900,
  //                                           fontWeight: FontWeight.w600,
  //                                         ),
  //                                       ),
  //                                     ),
  //
  //                                     // GestureDetector(
  //                                     //   onTap: () {
  //                                     //     onTap(index);
  //                                     //   },
  //                                     //   child: Text(
  //                                     //     textList[index],
  //                                     //     textAlign: TextAlign.center,
  //                                     //     style: GoogleFonts.roboto(
  //                                     //       fontSize: 16,
  //                                     //       color: selectedButtonIndex == index ? Colors.orange : Colors.blue.shade900,
  //                                     //       fontWeight: FontWeight.w600,
  //                                     //     ),
  //                                     //   ),
  //                                     // ),
  //
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //
  //                 SizedBox(
  //                   height: 15,
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     // updateKyc();
  //                     sendSelectedAPI();
  //                     Navigator.pop(context);
  //                   },
  //                   child: Card(
  //                     elevation: 2,
  //                     child: ButtonWidget(
  //                       text: "Send",
  //                       color: Color(0xffFBCD96),
  //                       textColor: Colors.orange,
  //                       width: 130,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}

// Padding(
//  padding: const EdgeInsets.all(8.0),
//  child: SingleChildScrollView(
//   scrollDirection: Axis.horizontal,
//    child: ListView.builder(
//     shrinkWrap: true,
//     itemCount: 7,
//     scrollDirection: Axis.horizontal,
//      itemBuilder: (context, index) => GestureDetector(
//       onTap: () async {
//         // String postId = DataList[index]["id"].toString();
//         // await getPost(postId);
//         },
//         child: Padding(
//         padding: const EdgeInsets.only(left: 5, right: 5.0),
//           child: Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               color: Colors.blue.shade200,
//             ),
//             width: 80,
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     'name',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.roboto(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       // color: (selectIndex == index.toString())
//                       //     ? Color(0xff41BFFF)
//                       //     : Colors.black54,
//                     ),
//                   ),
//                 ]),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
// ),
