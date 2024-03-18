import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../AllWidgets/buttons.dart';
import 'GalleryImagesScreen.dart';

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
  bool showButton = true;
  bool contactButton = true;
  bool alreadyContacted = false;
  TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getPostDetails();
  }

  Future<void> getPostDetails() async {
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
              var myUserId = prefs.getString('userId');
              var addByUserId = jsonData['add_by_user_id'].toString();

              print('My User ID: $myUserId');
              print('Add By User ID: $addByUserId');

              if (addByUserId == myUserId) {
                showButton = false;
              }
              var myUsermobile = prefs.getString('userId');
              var addByUsermobile =
                  jsonData['post_contacts'][0]['id'].toString();
              if (myUsermobile == addByUsermobile) {
                contactButton = false;
              }
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
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
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
                                                    jsonData[
                                                        'add_by_user_image'],
                                                    fit: BoxFit.cover,
                                                    width: 90.0,
                                                    height: 90.0,
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
                                              (jsonData["category_name"] !=
                                                      null)
                                                  ? jsonData["category_name"]
                                                  : 'Name not available',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              (jsonData["topic_name"] != null)
                                                  ? jsonData["topic_name"]
                                                  : 'Name not available',
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
                                        child: Center(
                                          child: Text('Paid'),
                                        ),
                                      ),
                                    )
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
                              child:
                              // Container(
                              //   color: Colors.black,
                              //   height: 220,
                              //   width: MediaQuery.of(context).size.width,
                              //   child: Image.network(
                              //     (jsonData["post_images"][0]["image"] != null)
                              //         ? jsonData["post_images"][0]["image"]
                              //         : 'Name not available',
                              //     fit: BoxFit.contain,
                              //   ),
                              // ),
                              Container(
                                color: Colors.black,
                                height: 220,
                                width: MediaQuery.of(context).size.width,
                                child: PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: jsonData['post_images'].length,
                                  itemBuilder: (context, index) {
                                    String imageUrl = jsonData['post_images'][index]['image'];
                                    return InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                           MaterialPageRoute(
                                            builder: (context) => photoView(
                                            index: index,
                                            id: jsonData['post_images'][index]['id'],
                                            image: jsonData['post_images'],
                                            // image: galleryImages,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8.0),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              color: Colors.grey[400],
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Party: ${(jsonData["second_party"] != null) ? jsonData["second_party"] : 'Name not available'}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    (jsonData["created_at"] != null)
                                        ? jsonData["created_at"]
                                        : 'Name not available',
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
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
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
                                      "Category",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (jsonData["category_name"] != null)
                                          ? jsonData["category_name"]
                                          : 'not available',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54),
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
                                        " ${(jsonData["problem_start_month"] != null) ? jsonData["problem_start_month"] : 'Name not available'}-"
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
                                  height: 10,
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Text(
                            "Contacts",
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    jsonData == null || jsonData['post_contacts'] == null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Center(
                              child: CircularProgressIndicator(
                                // radius: 30,
                                color: Colors.indigo[900],
                              ),
                            ),
                          )
                        : jsonData['post_contacts'].length == 0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Center(
                                  child: Text(
                                    'No Contact Available',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: jsonData['post_contacts'].length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var post = jsonData['post_contacts'][index];
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 15,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                          left: 10.0,
                                          top: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          child: ClipOval(
                                                            child:
                                                                Image.network(
                                                              (post["profile"] !=
                                                                      null)
                                                                  ? post[
                                                                      "profile"]
                                                                  : 'profile not available',

                                                              fit: BoxFit.cover,
                                                              width:
                                                                  60.0, // adjust width as needed
                                                              height: 60.0,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Icon(
                                                                  Icons.person,
                                                                  size: 50,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            (post["name"] !=
                                                                    null)
                                                                ? post["name"]
                                                                : 'name not available',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            (post["profession"] !=
                                                                    null)
                                                                ? post[
                                                                    "profession"]
                                                                : 'profession not available',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            (post["location"] !=
                                                                    null)
                                                                ? post[
                                                                    "location"]
                                                                : 'location not available',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),

                                                          // Text(
                                                          //   (post["mobile"] !=
                                                          //           null)
                                                          //       ? post["mobile"]
                                                          //       : 'mobile not available',
                                                          //   style: GoogleFonts.roboto(
                                                          //       color: Colors
                                                          //           .black,
                                                          //       fontSize: 12,
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w400),
                                                          // ),
                                                          // SizedBox(
                                                          //   height: 3,
                                                          // ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Visibility(
                                                        visible: contactButton,
                                                        child: InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Call'),
                                                                    content: Text(
                                                                        'Are you sure you want to Call?'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            'No'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          var phoneNumber =
                                                                              post['mobile'] ?? '';
                                                                          var url =
                                                                              "tel:$phoneNumber";
                                                                          print(
                                                                              "Calling $phoneNumber");
                                                                          await launchUrl(
                                                                              Uri.parse(url));
                                                                        },
                                                                        child: Text(
                                                                            'Yes'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          child: Icon(
                                                              Icons.call,
                                                              color: Colors
                                                                  .greenAccent),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: contactButton,
                                                        child: InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'WhatsApp'),
                                                                    content: Text(
                                                                        'Are you sure you want to WhatsApp Message?'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            'No'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          var phoneNumber =
                                                                              post['mobile'] ?? '';
                                                                          var message =
                                                                              "Hello";
                                                                          var url =
                                                                              "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";
                                                                          print(
                                                                              "The URL is $url");
                                                                          await launchUrl(
                                                                              Uri.parse(url));
                                                                        },
                                                                        child: Text(
                                                                            'Yes'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          child: Image.asset(
                                                            'assets/images/whats.png',
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: showButton,
                      child: GestureDetector(
                        onTap: () {
                          _showdialogue(context);
                          setState(() {
                            alreadyContacted = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30.0, bottom: 20),
                          child: ButtonWidget(
                            text: alreadyContacted
                                ? "Already Contacted"
                                : "Contact",
                            color: Color(0xffFBCD96),
                            textColor: Colors.orange,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _showdialogue(BuildContext context) {
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
                    onChanged: (value) {},
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      addPostEnquiryPopUp(
                          widget.postId.toString(), _textController.text);
                      Navigator.pop(context);
                      await getPostDetails();
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
  }
}
