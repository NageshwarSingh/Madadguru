import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madadguru/AllWidgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../Pages/GalleryImagesScreen.dart';

class GalleryScreen extends StatefulWidget {
  final String device;
  const GalleryScreen({super.key, required this.device});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // List<Map<String, dynamic>> GalleryData = [];
  Map<String, dynamic> JsonData = {};
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getGalleryCategory();
  }

  Future<void> getGalleryCategory() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getGalleryCategory");
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
            if (userData is List) {
              setState(() {
                JsonData = {'data': List<Map<String, dynamic>>.from(userData)};
                print('API response json: ${JsonData}');
              });
            }
          } else {
            print('API request failed: ${responseData["message"]}');
          }
          print('Data fetched successfully');
          print(response.body);
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text('Our journey so far'),
        // actions: [
        //   PopupMenuButton<String>(
        //     color: Colors.white,
        //     icon: Icon(Icons.more_vert_rounded),
        //     onSelected: (value) {
        //       switch (value) {
        //         case 'Video editor':
        //           break;
        //         case 'Collage':
        //           break;
        //         case 'Clip':
        //           break;
        //         case 'Free up space':
        //           break;
        //         case 'Sort and view':
        //           break;
        //         case 'Create an album':
        //           break;
        //         case 'Settings':
        //           break;
        //       }
        //     },
        //     itemBuilder: (BuildContext context) => [
        //       PopupMenuItem<String>(
        //         value: 'Video editor',
        //         child: Text('Video editor'),
        //       ),
        //       PopupMenuItem<String>(
        //         value: 'Collage',
        //         child: Text('Collage'),
        //       ),
        //       PopupMenuItem<String>(
        //         value: 'Clip',
        //         child: Text('Clip'),
        //       ),
        //       PopupMenuItem<String>(
        //         value: 'Free up space',
        //         child: Text('Free up space'),
        //       ),
        //       PopupMenuItem<String>(
        //         value: 'Sort and view',
        //         child: Text('Sort and view'),
        //       ),
        //       PopupMenuItem<String>(
        //         value: 'Create an album',
        //         child: Text('Create an album'),
        //       ),
        //       PopupMenuItem<String>(
        //         value: 'Settings',
        //         child: Text('Settings'),
        //       ),
        //     ],
        //   ),
        // ]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildListView(),
          Column(
            children: [
              Text(
                'Connect on Social',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  InkWell(
                      onTap: () async {
                        await launchUrl(Uri.parse(
                            'https://www.facebook.com/socialservicesmadadguru/'));
                      },
                      child: Image.asset(
                        'assets/images/facebook.png',
                        height: 45,
                        width: 45,
                      )),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://www.instagram.com/madadguru?igsh=Mmg5MnA4cG11aDE='));
                      },
                    child: Image.asset(
                      'assets/images/instagram.png',
                      height: 45,
                      width: 45,
                    ),
                  ),
                  // meet the mental and phyisical health experts
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://www.linkedin.com/company/madadguru/'));
                    },
                    child: Image.asset(
                      'assets/images/linkedin.png',
                      height: 45,
                      width: 45,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Image.asset(
                  //     'assets/images/telegram.png',
                  //     height: 45,
                  //     width: 45,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 6,
                  // ),
                  InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://x.com/GuruMadad?t=JEZ7d44IpeVxR56Oh0gQHw&s=08'));
                    },
                    child: Image.asset(
                      'assets/images/xtwitter.png',
                      height: 45,
                      width: 45,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://youtube.com/@madadguru248?si=zLGlYdbdLe4JJoFe'));
                    },
                    child: Image.asset(
                      'assets/images/youtube.png',
                      height: 45,
                      width: 45,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildListView() {
    if (JsonData == null ||
        JsonData["data"] == null ||
        JsonData["data"].isEmpty) {
      return Center(
        child: Text('No data available'),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        // itemCount: GalleryData.length,
        itemCount: JsonData["data"].length,
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 2,
        //   crossAxisSpacing: 0.0,
        //   mainAxisSpacing: 0.0,
        // ),
        itemBuilder: (BuildContext context, int index) {
          var post = JsonData["data"][index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return GalleryImageScreen(
                    postId: post['id'],
                    title: post['name'],
                    device: widget.device,
                  );
                }),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(

                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 2,
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // color: Colors.grey.shade200,
                          image: DecorationImage(
                            image: NetworkImage(
                              (post["icon"] != null)
                                  ? post["icon"]
                                  : 'Name not available',
                            ), // Provide the correct key for the image URL
                            fit: BoxFit
                                .contain, // Adjust this based on your requirements
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color:  Colors.orange.shade300,
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Colors.orange.shade300,
                          //     Colors.orange.shade300,
                          //     // Color(0xff4E89AE),
                          //     // Color(0xff4E89AE),
                          //   ],
                          //   begin: Alignment.centerLeft,
                          //   end: Alignment.centerRight,
                          // ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " ${(post["name"] != null) ? post["name"] : 'Name not available'}",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " (Items: ${(post["count"] != null) ? post["count"] : 'count not available'})",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    " ${(post["adddate"] != null) ? post["adddate"] : 'Name not available'}",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

//
// class Grid extends StatefulWidget {
//   const Grid({Key? key}) : super(key: key);
//
//   @override
//   State<Grid> createState() => _GridState();
// }
//
// class _GridState extends State<Grid> {
//   final List<String> data = [
//     "container1",
//     "container2",
//     "container3",
//     "container4",
//     "container4",
//     "container4",
//     "container4",
//     "container4",
//     "container4",
//     "container4",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Center(
//           child: Expanded(
//             child: SizedBox(
//               height: 800,
//               width: 300,
//               child: GridView.builder(
//                 itemCount: data.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // Number of columns
//                   crossAxisSpacing: 10.0,
//                   mainAxisSpacing: 10.0,
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     color: Colors.amber,
//                     child: Center(
//                       child: Text(data[index]),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
