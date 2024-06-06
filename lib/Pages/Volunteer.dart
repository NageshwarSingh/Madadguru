import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madadguru/Pages/publicPostProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'VolunteerProfileDetail.dart';
import 'package:http/http.dart' as http;

  class VolunteerScreen extends StatefulWidget {
   final String device;
    const VolunteerScreen({
     super.key,
      required this.device,
     });
  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
  }
  class _VolunteerScreenState extends State<VolunteerScreen> {
  @override
  Widget build(BuildContext context) {
    // searchController

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: buildAppBar(),
      body: Body(
        device: '',
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Madadguru'),backgroundColor: Colors.grey.shade200,);

  }
}

class Body extends StatefulWidget {
  final String device;
  const Body({super.key, required this.device});
  @override
  State<Body> createState() => _BodyState();
}
  class _BodyState extends State<Body> with TickerProviderStateMixin {
  var value = 0;
int Count=0;
  int Count1=0;
  bool isdataLoading = false;
  late TabController _mainTabController;
  late TabController _tabController;
  Map<dynamic, dynamic> QuizList = {};
  @override
  void initState() {
    super.initState();
    fetchData();
    _tabController = TabController(length: 7, vsync: this);
    _mainTabController = TabController(
      length: 2,
      vsync: this,
    );
  }
  bool isLoading = false;
   Map jsonData = {};
    Future<void> fetchData() async {
     setState(() {
      isLoading = true;
      });
    SharedPreferences prefs = await SharedPreferences.getInstance();
     var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getVolunteer");
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
            // Handle map response
            setState(() {
              jsonData = responseData;
              Count1 =responseData['count'];
            });
            fetchDataVolunteer();
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

  Map jsonDataVolunteer = {};
  Future<void> fetchDataVolunteer() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri =
          Uri.parse("https://madadguru.webkype.net/api/getUser");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
        );
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("User $responseData");
          if (responseData is List) {
            setState(() {
              jsonDataVolunteer = {"data": responseData};
            });
          } else if (responseData is Map && responseData.containsKey('data')) {

            setState(() {
              jsonDataVolunteer = responseData;
              Count = responseData['count'];
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
      }finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        // top: 10,
      ),
      child: Column(children: [

        _buildMainTabBar(),
        Expanded(child: _buildMainTabBarView()),
      ]),
    );
  }

     Widget _buildMainTabBar() {
    return Card(
      color: Colors.grey.shade300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0), // Border radius of the card
      ),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: TabBar(
              dividerColor: Colors.transparent,
              splashBorderRadius: BorderRadius.circular(25),
              controller: _mainTabController,
              indicatorColor: Colors.transparent,
              indicator: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              tabs: [
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 40),
                  child: Tab(
                    text: 'User',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 40.0),
                  child: Tab(text: 'Volunteer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

        Widget _buildMainTabBarView() {
        return SafeArea(
        child: isLoading
        ? Center(child: CircularProgressIndicator())
        :
        Container(
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: TabBarView(
          controller: _mainTabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildMainTabContentUser("Main Tab Content 1"),
            _buildMainTabContentVolunteer("Main Tab Content 2"),
          ],
        ),
      ),
     );
    }

    Widget _buildMainTabContentUser(String s) {
    if(isLoading){
      return Center(child: CircularProgressIndicator());
    } else if (jsonDataVolunteer == null || jsonDataVolunteer["data"] == null || jsonDataVolunteer["data"].isEmpty) {
      return Center(child: Text("Not available data"));
    }
      else
    {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Users (${Count})", // Replace "Your Text Here" with your desired text
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 20, top: 5),
            itemCount: jsonDataVolunteer != null && jsonDataVolunteer["data"] != null
                ? jsonDataVolunteer["data"].length
                : 0,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              var post = jsonDataVolunteer['data'][index];
              if (post == null || post.isEmpty) {
                return SizedBox();
                 }
                 return InkWell(
                  onTap: () {
                   Navigator.push(
                    context,
                       MaterialPageRoute(
                       // builder: (context) => ProfileDetailScreen(
                       builder: (context) => PublicPostProfile(
                        device: widget.device,
                        postId: post["id"],
                        ),
                       ),
                     );
                    },
                   child: Card(
                   elevation: 1,
                    child: Container(
                     padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                           ),
                          Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border:
                                  Border.all(width: 1, color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: CircleAvatar(
                              radius: 35,
                              child: ClipOval(
                                child:
                                    Image.network(
                                  post['profile'] ?? '',
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
                          height: 5,
                        ),
                        Text(
                          (post["name"] != null) ? post["name"] : 'Name not available',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                           ),
                          SizedBox(
                          height: 3,
                             ),
                           Text(
                              (post["profession"] != null) ? post["profession"] : 'profession not available',
                             style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                                 ),
          
                            SizedBox(
                          height: 3,
                          ),
          
                         Text(
                          (post["location"] != null) ? post["location"] : 'location not available',
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ],
                      ),
                    ),
                   ),
                  );
                 },
                ),
        ),
      ],
    );
          }}

      Widget _buildMainTabContentVolunteer(String s) {
      if (isLoading) {
        return Center(child: CircularProgressIndicator());
         } else if (jsonData == null || jsonData["data"] == null || jsonData["data"].isEmpty) {
          return Center(child: Text("Not available data"));
            }
           else {
            return Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Volunteer (${Count1})", // Replace "Your Text Here" with your desired text
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              ),
              ),
              Expanded(
              child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 20, top: 5),
              itemCount: jsonData["data"].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                   mainAxisSpacing: 15.0,
                     ),
                       itemBuilder: (BuildContext context, int index) {
                      var post = jsonData['data'][index];
                      if (post == null || post.isEmpty){
                      return SizedBox();
                      }
                      return InkWell(
                          onTap: () {
                          Navigator.push(
                          context,
                            MaterialPageRoute(
                             builder: (context) =>
                             VolunteerProfileDetailScreen(
                             device: widget.device,
                            postId: post['id'],
                            ),
                            ),
                          );
                         },
                       child: Card(
                         elevation: 1,
                          child: Container(
                           padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                             color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                          ),
                        child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          SizedBox(height: 10),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                                ),
                               child: Center(
                                child: CircleAvatar(
                                radius: 35,
                                child: ClipOval(
                                  child: Image.network(
                                    post['profile'] ?? '',
                                    fit: BoxFit.cover,
                                    width: 90.0,
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
                          SizedBox(height: 5),
                          Text(
                            post["name"] != null ? post["name"] : 'Name not available',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            post["profession"] != null
                                ? post["profession"]
                                : 'Profession not available',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black38,
                            ),
                            ),

                            SizedBox(height: 3),
                            Text(
                              post["location"] != null
                                ? post["location"]
                                : 'Location not available',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}

// Widget _buildMainTabContentVolunteer(String s) {
//   return GridView.builder(
//     padding: const EdgeInsets.only(bottom: 20, top: 15),
//     itemCount: jsonDataVolunteer != null && jsonDataVolunteer["data"] != null
//         ? jsonDataVolunteer["data"].length
//         : 0,
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2,
//       crossAxisSpacing: 15.0,
//       mainAxisSpacing: 15.0,
//     ),
//     itemBuilder: (BuildContext context, int index) {
//       var post = jsonDataVolunteer['data'][index];
//       if (post == null || post.isEmpty) {
//         return SizedBox();
//       }
//       return InkWell(
//
//         onTap: () {
//           // Navigate to the second page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => VolunteerProfileDetailScreen(
//                       device: widget.device,
//                     postId:post['id']
//                     )),
//           );
//         },
//         child: Card(
//           elevation: 1,
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(12)),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   height: 60,
//                   width: 60,
//                   decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       // border: Border.all(w, color: Colors.grey.shade200),
//                       borderRadius: BorderRadius.circular(30),
//                      ),
//                      child: Center(
//                       child: CircleAvatar(
//                       radius: 35,
//                       child: ClipOval(
//                         child: Image.network(
//                           post['profile'] ?? '',
//                           fit: BoxFit.cover,
//                           width: 90.0, // adjust width as needed
//                           height: 90.0,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(
//                               Icons.person,
//                               size: 50,
//                               color: Colors.grey[400],
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     ),
//                   ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   (post["name"] != null) ? post["name"] : 'Name not available',
//                   // post['name'] ?? '',
//                   style: GoogleFonts.roboto(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 Text(
//                   (post["profession"] != null) ? post["profession"] : 'profession not available',
//                   // post['profession'] ?? '',
//                   style: GoogleFonts.roboto(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black38),
//                 ),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 Text(
//                   (post["location"] != null) ? post["location"] : 'location not available',
//                   // post['location'] ?? '',
//                   style: GoogleFonts.roboto(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black38),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }