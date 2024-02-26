import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AllWidgets/buttons.dart';
import 'package:http/http.dart' as http;

class MyPostDetail extends StatefulWidget {
  final String device;
  final int postId;
  const MyPostDetail({
    super.key,
    required this.device,
    required this.postId,
  });
  @override
  State<MyPostDetail> createState() => _MyPostDetailState();
}
class _MyPostDetailState extends State<MyPostDetail> {
  List<String> imagesDp = [
    'assets/images/dp1.png',
    'assets/images/dp2.jpeg',
    'assets/images/dp3.webp',
    'assets/images/dp4.jpeg',
    'assets/images/girl.png',
    'assets/images/dp3.webp',
    'assets/images/girl.png',
    'assets/images/dp3.webp',
    'assets/images/dp4.jpeg',
    'assets/images/people.webp',
  ];
  bool isLoading = false;
  Map Mydata = {};
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
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
          },
               body: {
                   'post_id': widget.postId.toString(),
               });

        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("object $responseData");
          if (responseData['success'] == true) {
            var userData = responseData['data'];
            setState(() {
              Mydata = userData;
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
      finally {
        setState(() {
          isLoading = false;
        });
      }
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
      body:

      SafeArea(
        child:isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(children: [
            Card(
              elevation: 2,
              // color: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
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
                                child: ClipOval(
                                  child: Mydata.containsKey('add_by_user_image')
                                      ? Image.network(
                                          Mydata['add_by_user_image'],
                                          fit: BoxFit.cover,
                                          width: 90.0, // adjust width as needed
                                          height: 90.0, // adjust height as needed
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey[400],
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   Mydata['data']['add_by_user_name'],
                                    //   // Mydata.containsKey('add_by_user_name')
                                    //   //     ? Image.network(
                                    //   //   Mydata['add_by_user_name'],
                                    //   style: GoogleFonts.roboto(
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    Text(
                                      (Mydata["add_by_user_name"] != null)
                                          ? Mydata["add_by_user_name"]
                                          : 'Name not available',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Type: ${(Mydata["add_by_user_type"] != null) ? Mydata["add_by_user_type"] : 'Name not available'}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),


                                  ]),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.black26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(child: Text('Paid')),
                              ),
                            )
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Text(
                        (Mydata["problem_statement"] != null)
                            ? Mydata["problem_statement"]
                            : 'Name not available',
                        // "Builder not helping in Possition",
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
                      child: Container(
                        color: Colors.black,
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          (Mydata["post_images"][0]["image"] != null)
                              ? Mydata["post_images"][0]["image"]
                              : 'Name not available',
                          // 'assets/images/building.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Party: ${(Mydata["second_party"] != null) ? Mydata["second_party"] : 'Name not available'}",
                            // 'Party : Supervisor',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        (Mydata["problem_desc"] != null)
                            ? Mydata["problem_desc"]
                            : 'Name not available',
                        // "Delivery drivers are responsible for transporting goods from distribution centers to customers. They follow a specified schedule and identify the most efficient routes to avoid delays. They also conduct regular vehicle check-ups and maintenance to keep company vehicles in good working condition.",
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 20),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select Category",
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              (Mydata["category_name"] != null)
                                  ? Mydata["category_name"]
                                  : 'not available',
                              // "Category",
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select Topic",
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              (Mydata["topic_name"] != null)
                                  ? Mydata["topic_name"]
                                  : 'Name not available',
                              // "Topics",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "2nd party (if Any)",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                  (Mydata["second_party"] != null)
                                      ? Mydata["second_party"]
                                      : 'Name not available',
                                  // "2nd party (if Any)",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Problem Statement",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                  (Mydata["problem_statement"] != null)
                                      ? Mydata["problem_statement"]
                                      : 'Name not available',
                                  // "Problems",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ]),

                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported From Madadguru",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                  (Mydata["already_reported"] != null)
                                      ? Mydata["already_reported"]
                                      : 'Name not available',
                                  // " Madadguru",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ]),

                        const SizedBox(
                          height: 10,
                        ),



                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Financial Status",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                  (Mydata["financial_status"] != null)
                                      ? Mydata["financial_status"]
                                      : 'Name not available',
                                  // " Status",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ]),

                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Problem Month/Year",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                  " ${(Mydata["problem_start_month"] != null) ? Mydata["problem_start_month"] : 'Name not available'}-${(Mydata["problem_start_year"] != null) ? Mydata["problem_start_year"] : 'Name not available'}",
                                  // "Hospitality",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Exp. Month/Year",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(" ${(Mydata["exp_solution_month"] != null) ? Mydata["exp_solution_month"] : 'Name not available'}-${(Mydata["exp_solution_year"] != null) ? Mydata["exp_solution_year"] : 'Name not available'}",

                                  // "Hospitality",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ]),
                      ]),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10.0),
                  child: Text(
                    'Contacts',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),


                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 6,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10, left: 10.0, top: 10, bottom: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: CircleAvatar(
                                          radius: 35,
                                          child: ClipOval(
                                            child: Image.asset(
                                              imagesDp[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),


                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.s,
                                        children: [
                                          Text(
                                            "Gajendra Singh ",
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "Lowyer",
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "Greater Noida",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // SizedBox(width: 100,),

                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // SizedBox(height: 5,),
                                      InkWell(
                                          onTap: () {
                                            showdialogueCall();
                                          },
                                          child: Icon(Icons.call,
                                              color: Colors.greenAccent)),

                                      InkWell(
                                        onTap: () {
                                          showdialogueWhatsapp();
                                        },
                                        child: Image.asset(
                                          'assets/images/whats.png',
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          // subtitle:
                        ),
                      );
                    }),
                InkWell(
                  onTap: () {
                    buildShowdialogue();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20, left: 20, top: 20, bottom: 20),
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
                            'Contact',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void buildShowdialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Your Request'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextField(
                    maxLines: 5,
                    // controller: _professionController,
                    decoration: InputDecoration(
                      hintText: 'Text here....',
                      // label: Text('/'),
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
                      contentPadding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
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
                    onTap: () {
                      Navigator.pop(context);
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

  void showdialogueWhatsapp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('WhatsApp'),
            content: Text('Are you sure you want to WhatsApp Message?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Perform the delete operation and close the dialog
                  // Add your delete logic here
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  void showdialogueCall() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Call'),
            content: Text('Are you sure you want to Call?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }
}
