import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Pages/GalleryImagesScreen.dart';

// count Data
// Text(
// 'Total Gallery Categories: ${GalleryData.length}',
// style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// ),
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

  // Future<void> getGalleryCategory() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var usertoken = prefs.getString('token');
  //   if (usertoken != null) {
  //     final Uri uri =
  //         Uri.parse("https://madadguru.webkype.net/api/getGalleryCategory");
  //       try {
  //       final response = await http.post(
  //         uri,
  //         headers: {
  //           'Authorization': 'Bearer $usertoken',
  //         },
  //       );
  //       if (response.statusCode == 200) {
  //         var responseData = json.decode(response.body);
  //         List<dynamic> data = responseData['data'] ?? [];
  //         setState(() {
  //           // GalleryData = data.map((item) {
  //           //   return {
  //           //     'id': item['id']?.toString() ?? '', // Use null-aware and null-coalescing operators
  //           //     'name': item['name'] ?? '',
  //           //     'icon': item['icon'] ?? '',
  //           //     'count': item['count'] ?? 0, // Provide default value for count
  //           //     'adddate': item['adddate'] ?? '', // Provide default value for adddate
  //           //   };
  //           // }).toList();
  //
  //           GalleryData = data
  //               .map((item) => {
  //                     'id': item['id'].toString(),
  //                     'name': item['name'],
  //             'adddate': item['adddate'],
  //             'count': item['count'],
  //             'icon': item['icon'],
  //                   })
  //               .toList();
  //         });
  //         print('DepartmentList: $GalleryData');
  //         print('Data fetched successfully');
  //         print(response.body);
  //
  //         print('Data fetched successfully');
  //       } else {
  //         print('Failed to fetch data. Status code: ${response.statusCode}');
  //       }
  //     } catch (error) {
  //       print('Error fetching data: $error');
  //     } finally {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }
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
          title: Text('Gallery'),
          actions: [
            PopupMenuButton<String>(
              color: Colors.white,
              icon: Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                switch (value) {
                  case 'Video editor':
                    break;
                  case 'Collage':
                    break;
                  case 'Clip':
                    break;
                  case 'Free up space':
                    break;
                  case 'Sort and view':
                    break;
                  case 'Create an album':
                    break;
                  case 'Settings':
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'Video editor',
                  child: Text('Video editor'),
                ),
                PopupMenuItem<String>(
                  value: 'Collage',
                  child: Text('Collage'),
                ),
                PopupMenuItem<String>(
                  value: 'Clip',
                  child: Text('Clip'),
                ),
                PopupMenuItem<String>(
                  value: 'Free up space',
                  child: Text('Free up space'),
                ),
                PopupMenuItem<String>(
                  value: 'Sort and view',
                  child: Text('Sort and view'),
                ),
                PopupMenuItem<String>(
                  value: 'Create an album',
                  child: Text('Create an album'),
                ),
                PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
              ],
            ),
          ]),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    if (JsonData == null ||
        JsonData["data"] == null ||
        JsonData["data"].isEmpty) {
      // Return a widget indicating no data available
      return Center(
        child: Text('No data available'),
      );
    }
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        // itemCount: GalleryData.length,
        itemCount: JsonData["data"].length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
        ),
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
                    // postId: GalleryData[index]["id"],
                    // title:GalleryData[index]['name'],
                    device: widget.device,
                  );
                }),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: 155,
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
                              .fill, // Adjust this based on your requirements
                            ),
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
                      // child: Column(
                      //   children: [
                      //     // Image.network(
                      //     //   (post["icon"]!= null)
                      //     //       ? post["icon"]
                      //     //       : 'Name not available',
                      //     //   // 'assets/images/download.jpeg',
                      //     //   fit: BoxFit.fill,
                      //     // ),
                      //     // Text(
                      //     //   " ${(post["name"] != null) ? post["name"] : 'Name not available'}",
                      //     //
                      //     //   style: TextStyle(
                      //     //     color: Colors.white,
                      //     //     fontSize: 14,
                      //     //     fontWeight: FontWeight.w400,
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
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

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  final List<String> data = [
    "container1",
    "container2",
    "container3",
    "container4",
    "container4",
    "container4",
    "container4",
    "container4",
    "container4",
    "container4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Expanded(
            child: SizedBox(
              height: 800,
              width: 300,
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.amber,
                    child: Center(
                      child: Text(data[index]),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
