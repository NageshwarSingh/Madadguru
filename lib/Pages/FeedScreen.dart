import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:madadguru/Pages/NewPostScreen.dart';
import 'package:madadguru/Pages/publicPostProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Allwidgets/ContactsScreen.dart';
import 'FilterScreen.dart';
import 'MyProfileDetailScreen.dart';
import 'NotificationScreen.dart';
import 'SearchScreen.dart';
import 'feedScreenPost.dart';

class FeedScreen extends StatefulWidget {
  final String device;
  const FeedScreen({
    Key? key,
    required this.device,
  }) : super(key: key);
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int selectedValue = 0;
  bool isSelected = false;
  var selectIndex = "";

  // File? imageFile;
  List<String> exampleList = ["Incentives", " Benefits", "Bike"];
  List<String> text = [
    'Real State',
    'Loan',
    'Policy',
    'Banking',
    'other',
  ];

  List<String> imagesProfile1 = [
    'assets/images/enjoy.png',
    'assets/images/enjoy.png',
    'assets/images/enjoy.png',
    'assets/images/enjoy.png',
    'assets/images/enjoy.png',
  ];

  // File? imageFile;
  Map<String, dynamic> JsonData = {};
  bool isLoading = false;
  bool isActive = false;
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchMyProfile();
  }
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getPost");
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
                fetchDataCategory();
                print('API response: ${JsonData}');
              });
            }
            if (JsonData["data"] == null || JsonData["data"].isEmpty) {
              // Handle empty data case
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

  List<Map<String, dynamic>> DataList = [];
  String selectedCategoryId = "";
  Future<void> fetchDataCategory() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getCategory");
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
          if (DataList.isNotEmpty) {
            selectedCategoryId =
                DataList[0]['id'];
            // fetchDataTopic(selectedCategoryId);
          }
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
  Map<String, dynamic> myProfile = {};
  Future<void> fetchMyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/myProfile");
      try {
        final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $usertoken',
            },
            body:{

            }
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("object $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            setState(() {
              myProfile=userData;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 50,
          backgroundColor: Colors.white,
          leadingWidth: 0,
          elevation: 0,
          title: Text(
            "Madadguru Feed",
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchScreen(
                    device: widget.device,
                  );
                }));
              },
              icon: Icon(
                Icons.search_rounded,
                // width: 23,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NotificationScreen(
                      device: widget.device,
                    );
                  }),
                );
              },
              icon: Icon(
                Icons.notification_important,
                // width: 23,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return FilterScreen(
                      device: widget.device,
                    );
                  }),
                );
              },
              icon: Image.asset(
                "assets/images/arrows.png",
                width: 23,
                color: Colors.black,
              ),
            ),
          ]),
      backgroundColor: Colors.grey.shade200,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: DataList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectIndex = index.toString();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5.0),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              width: 80,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // CircleAvatar(
                                    //   radius: 20,
                                    //   backgroundColor: Colors.grey.shade200,
                                    //   backgroundImage:Image.asset(imagesProfile[index])
                                    //   // NetworkImage('imagesProfile  '
                                    //   //     // "https://upload.wikimedia.org/wikipedia/commons/7/75/Zomato_logo.png"
                                    //   // ),
                                    // ),
                                    CircleAvatar(
                                      radius: 20,
                                      child: ClipOval(
                                        child: Image.asset(
                                          imagesProfile1[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      DataList[index]['name'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: (selectIndex == index.toString())
                                            ? Color(0xff41BFFF)
                                            : Colors.black54,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return NewPostScreen(
                          device: widget.device,
                        );
                      }),
                    );
                  },
                  child: Container(
                    height: 60,
                    // color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(12),
                      // border: Border.all(width: 1, color: Colors.black26),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return MyProfileDetailScreen(
                                    device: widget.device,
                                  );
                                }),
                              );
                            },
                            child: CircleAvatar(
                              radius: 25,
                              child:
                              ClipOval(
                                child:
                                Image.network(
                                  myProfile['profile'] ?? '',
                                  fit: BoxFit.cover,
                                  width: 90.0, // adjust width as needed
                                  height: 90.0,
                                  errorBuilder: (context, error, stackTrace) {
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
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                ),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      // border: Border.all(width: 1,color: Colors.black26),
                                      color: Colors.grey.shade200),
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('I need help...'),
                                  ), //   child: TextFormField(
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    // onTap:
                                    // _pickImageFromGallery
                                    //    () async {
                                    //   Navigator.pop(context);
                                    //   await _getFromGallery();
                                    // },

                                    child: Image.asset(
                                      // images[index],
                                      'assets/images/gallery.png',
                                      height: 25,
                                      width: 25,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    'Photo',
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                buildListView(),
              ],
            ),
    );
  }

  Widget buildListView() {
    if (JsonData["data"] == null || JsonData["data"].isEmpty) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      print("myData: $JsonData");
      print("myData['data']: ${JsonData['data']}");
      return Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: JsonData["data"].length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              var post = JsonData['data'][index];
              if (post["post_images"] == null || post["post_images"].isEmpty) {
                // Handle case where post_images is null or empty
                return SizedBox(); // Return an empty SizedBox
              }
              return Stack(children: [
                GestureDetector(
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) {
                  //       return MyJobDetail(
                  //         device: widget.Device, Device: '',
                  //       );
                  //     }),
                  //   );
                  // },
                  child: Card(
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
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // 'Posted: 4 Days ago',
                                  " ${post['created_at']}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    // color: (selectIndex == index.toString())
                                    // ? Color(0xff41BFFF):
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            ),
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

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return PublicPostProfile(
                                            postId: post["user_id"],
                                            device: widget.device,
                                          );
                                        }),
                                      );
                                      },
                                       child: Center(
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: ClipOval(
                                          child:
                                          Image.network(
                                            post['add_by_user_image'] ?? '',
                                            fit: BoxFit.cover,
                                            width: 90.0, // adjust width as needed
                                            height: 90.0,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.grey[400],
                                              );
                                            },
                                          ),
                                          //     : Icon(
                                          //   Icons.person,
                                          //   size: 50,
                                          //   color: Colors.grey[400],
                                          // ),
                                          // post['profile'],
                                          // fit: BoxFit.cover,
                                          // width:
                                          // 90.0, // adjust width as needed
                                          // height:
                                          // 90.0, // adjust height as needed
                                          // )
                                          //     : Icon(
                                          //   Icons.person,
                                          //   size: 50,
                                          //   color: Colors.grey[400],
                                          // ),
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
                                            post['add_by_user_name'],
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "Type: ${(post["add_by_user_type"] != null) ? post["add_by_user_type"] : 'Name not available'}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                            // style: TextStyle(
                                            //   fontSize: 14,
                                            //   fontWeight: FontWeight.w500,
                                            //   color: Color(0xff150B3D),
                                            // ),
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
                                      child: Center(
                                          child: Text(
                                        post["is_paid"],
                                        style: TextStyle(fontSize: 12),
                                      )),
                                    ),
                                  )
                                  // Image.asset('assets/images/x.png',height: 10,width: 10,)
                                ]),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5),
                            child: Text(
                              post["problem_statement"],
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return feedScreenPost(
                                    postId: post["id"],
                                    device: widget.device,
                                  );
                                }),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Container(
                                color: Colors.black,
                                height: 220,
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  (post["post_images"][0]["image"] != null)
                                      ? post["post_images"][0]["image"]
                                      : 'Name not available',
                                  // 'assets/images/download.jpeg',
                                  fit: BoxFit.contain,
                                  // fit: BoxFit.contain,
                                ),
                                ),
                               ),
                              ),
                            Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Party: ${(post["second_party"] != null) ? post["second_party"] : 'Name not available'}",
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.person,
                                        color: Colors.black45, size: 15),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ContactsScreen(
                                              device: widget.device,
                                            );
                                          }),
                                        );
                                      },
                                      child: Text(
                                        "${(post["helper_contacted"] != null) ? post["helper_contacted"] : 'Name not available'} Contacts",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          // Divider()
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
            }),
      );
    }
  }

  // _getFromGallery() async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 50,
  //   );
  //   if (pickedFile != null) {
  //     File? img = File(pickedFile.path);
  //     setState(() {
  //       imageFile = img;
  //     });
  //   }
  // }
}
