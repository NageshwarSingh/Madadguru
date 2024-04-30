import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EnquaryScreen extends StatefulWidget {
  final String device;
  const EnquaryScreen({
    super.key,
    required this.device,
  });
  @override
  State<EnquaryScreen> createState() => _EnquaryScreenState();
  }
   class _EnquaryScreenState extends State<EnquaryScreen> {
  bool isActive = false;
  List Notification = [];
  @override
  void initState() {
    super.initState();
    myEnquiry();
    setState(() {
      isActive = true;
    });
  }

  bool isLoading = false;
  Map<String, dynamic> JsonData = {};
  Future<void> myEnquiry() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/myEnquiry");
      try {
        final response = await http.post(uri, headers: {
          'Authorization': 'Bearer $usertoken',
        });
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("myEnquiry $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            if (userData is List) {
              setState(() {
                JsonData = {'data': List<Map<String, dynamic>>.from(userData)};
                print('API response: ${JsonData}');
              });
            }
            if (JsonData["data"] == null || JsonData["data"].isEmpty) {}
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
          backgroundColor: Colors.grey.shade200, title: Text('Quick Help')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15),
        child: JsonData == null || JsonData.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 250),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.indigo[900]),
                ),
              )
            : JsonData["data"].length == 0
                ? Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        'No Post Available',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: JsonData["data"].length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var post = JsonData["data"][index];
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    tileColor: Colors.white,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.purple.shade200,
                                      radius: 25,
                                      child: ClipOval(
                                        child: Image.network(
                                          post['icon'] ?? '',
                                          fit: BoxFit.cover,
                                          width: 50.0,
                                          height: 50.0,
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
                                      title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        children: [
                                        Text(
                                          post["category_name"] ??
                                              "Category not available",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          post["message"] ??
                                              'Message not available',
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        // Image.network(
                                        //   post['image'] ??
                                        //       'Not available image',
                                        //   height: 30,
                                        //   width: 30,
                                        // ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          post['created_at'] ??
                                              'Date not available',
                                          style: GoogleFonts.roboto(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _downloadImage(context,post['image'] ?? '');
                                          },
                                          child: Icon(Icons.download_outlined),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
      ),
    );
  }
}

void _downloadImage(BuildContext context,String imageUrl) async {
  try {
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // Save the image to the gallery
      final result = await ImageGallerySaver.saveImage(response.bodyBytes);
      if (result['isSuccess']) {
        print('Image downloaded and saved to gallery');
        // Show a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image downloaded and saved to gallery'),
          ),
        );
      } else {
        print('Failed to save image to gallery: ${result['errorMessage']}');
      }
    } else {
      print('Failed to download image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error downloading image: $e');
  }
}
//
// void _downloadImage(String imageUrl) async {
//   try {
//     var response = await http.get(Uri.parse(imageUrl));
//     if (response.statusCode == 200) {
//       // Save the image to the gallery
//       final result = await ImageGallerySaver.saveImage(response.bodyBytes);
//       if (result['isSuccess']) {
//         print('Image downloaded and saved to gallery');
//         _showSnackbar('Image downloaded and saved to gallery');
//       } else {
//         print('Failed to save image to gallery: ${result['errorMessage']}');
//         _showSnackbar('Failed to save image to gallery: ${result['errorMessage']}');
//       }
//     } else {
//       print('Failed to download image. Status code: ${response.statusCode}');
//       _showSnackbar('Failed to download image. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error downloading image: $e');
//     _showSnackbar('Error downloading image: $e');
//   }
// }
//
// void _showSnackbar(String message) {
//   ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//     SnackBar(
//       content: Text(message),
//     ),
//   );
// }
// void _downloadImage(String imageUrl) async {
//   try {
//     var response = await http.get(Uri.parse(imageUrl));
//     if (response.statusCode == 200) {
//       print('Image downloaded, length: ${response.bodyBytes.length} bytes');
//     } else {
//       print('Failed to download image. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error downloading image: $e');
//   }
// }
// void _downloadImage(String imageUrl) async {
//   try {
//     var response = await http.get(Uri.parse(imageUrl));
//     if (response.statusCode == 200) {
//       // Save the image to the gallery
//       final result = await ImageGallerySaver.saveImage(response.bodyBytes);
//       if (result['isSuccess']) {
//         print('Image downloaded and saved to gallery');
//       } else {
//         print('Failed to save image to gallery: ${result['errorMessage']}');
//       }
//     } else {
//       print('Failed to download image. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error downloading image: $e');
//   }
// }
// body: SingleChildScrollView(
//   child: Column(
//     children: [
//       ListView.builder(
//        shrinkWrap: true,
//        scrollDirection: Axis.vertical,
//        itemCount: JsonData['data'].length,
//        physics: NeverScrollableScrollPhysics(),
//        itemBuilder: (context, index) {
//          var post = JsonData['data'][index];
//          return Container(
//            height: 50,width: 100,
//            child: Text(
//                // 'data'
//                post["category_name"] ??  'Category not available', style: TextStyle(),
//            ),
//          );
//        })
//             ],
//           ),
// )
