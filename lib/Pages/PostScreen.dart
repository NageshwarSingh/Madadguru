import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madadguru/Pages/NewPostScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyProfileDetailScreen.dart';
import 'Homedetails.dart';
import 'NotificationScreen.dart';
import 'PostContactEnquiry.dart';
import 'package:http/http.dart' as http;

class PostScreen extends StatefulWidget {
  final String device;
  const PostScreen({
    Key? key,
    required this.device,
    required bool back,
  }) : super(key: key);
  @override
  State<PostScreen> createState() => _PostScreenState();
}
class _PostScreenState extends State<PostScreen> {
  int selectedValue = 0;
  bool isSelected = false;
  var selectIndex = "";
  Map<String, dynamic> myProfile = {};
  Map<String, dynamic> myData = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchDataMyPost();
    fetchMyProfile();
  }
//============  fetchDataMyPost Api  =================
  Future<void> fetchDataMyPost() async {
    // isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getMyPost");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
             },
             );
              if (response.statusCode == 200) {
              // isLoading = false;
          var responseData = json.decode(response.body);
          print("object $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            if (userData is List) {
              setState(() {
                myData = {'data': List<Map<String, dynamic>>.from(userData)};
                print('API response: ${myData}');

              });
            }
            if (myData["data"] == null || myData["data"].isEmpty) {}
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
          // isLoading = false;
        });
      }
    }
  }

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
              // deletePost(selectIndex as int);
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
  Future<void> deletePost(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/deletePost");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
          body: {
            'post_id': myData['data'][index]['id'].toString(), // Convert id to string
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print('response deletePost ${responseData}');
          if (responseData['success'] == true) {
            setState(() {
              myData['data'].removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Post deleted successfully"),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Failed to delete post"),
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to delete post"),
          ));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error deleting post: $error"),
        ));
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
          title: Text("My Posts",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
             actions: [

            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NotificationScreen(
                      device: widget.device,
                    );
                  }));
                },
                icon: Icon(
                  Icons.notification_important,
                  // width: 23,
                  color: Colors.black,
                ),
            ),

          ]),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {

              },
              child: Container(
                height: 60,
                // color: Colors.white,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
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
                          child:ClipOval(
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
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return NewPostScreen(
                                      device: widget.device,
                                    );
                                  }),
                                ).whenComplete(() =>  fetchDataMyPost());
                                },
                                 child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    // border: Border.all(width: 1,color: Colors.black26),
                                    color: Colors.grey.shade200),
                                width: MediaQuery.of(context).size.width * .7,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    ' I need help...',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                    ),
                                 ),
                                ),
                               ),
                               ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/gallery.png',
                                height: 25,
                                width: 25,
                                color: Colors.blue.shade700,
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

            buildListView(),
          ],
        ),
      ),
      );
     }

    Widget buildListView() {
    return myData.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 250),
            child: Center(
                child: CircularProgressIndicator(
              // radius: 30,
              color: Colors.indigo[900],
            ),
            ),
          )
          : myData["data"].length == 0
            ? Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Center(
                    child: Text(
                  'No Post Available',
                  style: TextStyle(fontSize: 25),
                ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: myData["data"].length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var post = myData['data'][index];
                      // if (post["post_images"] == null || post["post_images"].isEmpty)
                      if (post == null || post.isEmpty) {
                        return SizedBox();
                      }

                      return Stack(children: [
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
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        " ${post['created_at']}",
                                        // 'Posted: 4 Days ago',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.more_horiz),
                                          onPressed: () {
                                            // When the icon is tapped, show a SnackBar
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Delete'),
                                                    content: Text(
                                                        'Are you sure you want to delete?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                                  context)
                                                              .pop();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {

                                                          deletePost(index);

                                                        },
                                                        child: Text('Delete'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }),
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
                                // Divider(),
                                // Divider(),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                         children: [
                                          Center(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return MyProfileDetailScreen(
                                                    device: widget.device,
                                                  );
                                                }),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 26,
                                              backgroundColor: Colors.black38,
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
                                                  // myData['data'][index]['add_by_user_name'],
                                                  post['add_by_user_name'],
                                                  // "Rajesh Rajesh Rajesh ",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  // post["category_name"],
                                                  "${(post["category_name"] != null) ? post["category_name"] : 'Name not available'}",
                                                  // "Type: ${post['add_by_user_type']} ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    color: Color(0xff150B3D),
                                                  ),
                                                ),

                                                Text(
                                                  // post["category_name"],
                                                  "${(post["topic_name"] != null) ? post["topic_name"] : 'Name not available'}",
                                                  // "Type: ${post['add_by_user_type']} ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: Color(0xff150B3D),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          //   height: 40,
                                          // width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(5.0),
                                            child: Center(
                                              child: Text(
                                                post["is_paid"],
                                                // 'Paid',
                                                style:
                                                    TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        )
                                        // Image.asset('assets/images/x.png',height: 10,width: 10,)
                                      ]),
                                       ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  child: Text(
                                    (post["problem_statement"] != null) ? post["problem_statement"] : 'Name not available',

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
                                        return MyPostDetail(
                                          device: widget.device,
                                          postId: post["id"],
                                        );
                                      }),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Container(
                                      color: Colors.black,
                                      height: 220,
                                      width:
                                          MediaQuery.of(context).size.width,
                                      child:
                                      Image.network(
                                        post['post_images'][0]["image"] ?? '',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return
                                            Icon(
                                              Icons.person,
                                              color: Colors.grey[400],
                                            );
                                        },
                                       ),

                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Party: ${(post["second_party"] != null) ? post["second_party"] : 'Name not available'}",
                                        // 'Party : ${post["second_party"]}',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return PostContactEnquiry(
                                                  id: post["id"],
                                                  device: widget.device);
                                            }),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.person,
                                                color: Colors.black45,
                                                size: 15),
                                            SizedBox(
                                              width: 5,
                                               ),
                                            Text(
                                              "${(post["helper_contacted"] ?? 0)} Contacts",
                                              style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                ),
                                               ),


                                          ],
                                        ),
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
                      ]);
                    }),
              );
  }
}
