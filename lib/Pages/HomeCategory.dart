// import 'package:chips_choice/chips_choice.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../AllWidgets/buttons.dart';
// import '../Allwidgets/BottomNavBar.dart';
// import 'Login.dart';
//
// class HomeCategory extends StatefulWidget {
//   final String device;
//   const HomeCategory({
//     super.key,
//     required this.device,
//   });
//   @override
//   State<HomeCategory> createState() => _HomeCategoryState();
// }
// class _HomeCategoryState extends State<HomeCategory> {
//
//   late double Lat = 28.627344508586173;
//   late double Long = 77.20657331779607;
//   int segmentedControlValue = 0;
//   bool isActive = false;
//   Map JobDetail = {};
//   List<dynamic> department = [];
//   List DepartmentList = [
//     {
//       "id": 29,
//       "filterValue": "Property",
//     },
//     {
//       "id": 30,
//       "filterValue": "Loan",
//     },
//     {
//       "id": 31,
//       "filterValue": "Family",
//     },
//     {
//       "id": 32,
//       "filterValue": "Legal Case",
//     },
//     {
//       "id": 33,
//       "filterValue": "Marriage",
//     },
//     {
//       "id": 34,
//       "filterValue": "Relation",
//     },
//     {
//       "id": 35,
//       "filterValue": "Divorce",
//     },
//     {
//       "id": 36,
//       "filterValue": "Labour Law",
//     },
//     {
//       "id": 37,
//       "filterValue": "Ministry",
//     },
//
//   ];
//
//   final TextEditingController _textController = TextEditingController();
//   final TextEditingController _professionController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//                 children: [
//               Container(color: Colors.grey.shade100,
//                 padding: const EdgeInsets.only(left: 15),
//                 alignment: Alignment.centerLeft,
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back_ios,
//                     color: Color(0xcd000000),
//                   ),
//                 ),
//               ),
//               Column(
//                   children: [
//                 Container(
//                   color: Colors.grey.shade100,
//                   child: Column(
//                     children: [
//                       Center(
//                         child: CircleAvatar(
//                           radius: 45,
//                           child: ClipOval(
//                             child: Image.asset(
//                               'assets/images/download.jpeg',
//                               fit: BoxFit.cover,
//                               width: 90.0, // adjust width as needed
//                               height: 90.0, // adjust height as needed
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20,),
//                       Text("Rajesh Rajesh Rajesh",
//                           style: GoogleFonts.roboto(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           )),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text("Type: personal/community/ social",
//                           style: GoogleFonts.roboto(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black,
//                           )),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text("Builder not helping in possition",
//                           style: GoogleFonts.roboto(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black,
//                           ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ]),
//               // Positioned(
//               //   top: -40,
//               //   left: MediaQuery.of(context).size.width / 2.7,
//               //   child: CircleAvatar(
//               //     radius: 46.5,
//               //     backgroundColor: Colors.black,
//               //     child: Center(
//               //       child: CircleAvatar(
//               //         radius: 45,
//               //         child: ClipOval(
//               //           child: Image.asset(
//               //             'assets/images/download.jpeg',
//               //             fit: BoxFit.cover,
//               //             width: 90.0, // adjust width as needed
//               //             height: 90.0, // adjust height as needed
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //     //   CircleAvatar(
//               //     //     radius: 45,
//               //     //     backgroundColor: Colors.white,
//               //     //     backgroundImage: NetworkImage(
//               //     //         "https://upload.wikimedia.org/wikipedia/commons/7/75/Zomato_logo.png"),
//               //     //   ),
//               //   ),
//               // ),
//
//               SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10,left: 10, right: 10),
//                   child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                     ChipsChoice<dynamic>.multiple(
//                       choiceItems: C2Choice.listFrom<dynamic, dynamic>(
//                         source: DepartmentList,
//                         value: (index1, item) => DepartmentList[index1]['id'],
//                         label: (index1, item) =>
//                             DepartmentList[index1]['filterValue'],
//                       ),
//                       value: department,
//                       onChanged: (val) => setState(() => department = val),
//                       choiceCheckmark: true,
//                       choiceStyle: C2ChipStyle.outlined(
//                         color: Color(0xFFA2A09D),
//                         checkmarkColor: Colors.white,
//                         foregroundStyle: const TextStyle(
//                             color: Color(0xFF2F2924), fontSize: 14),
//                         selectedStyle: C2ChipStyle.filled(
//                           foregroundStyle:
//                               TextStyle(color: Colors.white, fontSize: 14),
//                           color: Color(0xff655D53),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//                       ),
//                       wrapped: true,
//                     ),
//
//                     SizedBox(height: 20),
//                     Text('Description',
//                         style: GoogleFonts.roboto(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black,
//                     )),
//                     SizedBox(height: 10,),
//                     TextField(
//                       maxLines: 3,
//                       controller: _professionController,
//                       decoration: InputDecoration(
//                         hintText: 'Text here....',
//                         // label: Text('/'),
//                         labelStyle: TextStyle(color: Colors.orange),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.orange),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.orange),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.orange),
//                         ),
//                         contentPadding: EdgeInsets.only(
//                             left: 10, right: 10, bottom: 10, top: 10),
//                       ),
//                       keyboardType: TextInputType.text,
//                       onChanged: (value) {
//                         // Handle text changes
//                       },
//                     ),
//                     SizedBox(height: 20),
//
//                     TextField(
//                       maxLines: 2,
//                       controller: _textController,
//                       decoration: InputDecoration(
//                         hintText: 'Text  Here.....',
//                         // label: Text('/'),
//                         labelStyle: TextStyle(color: Colors.orange),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.orange),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.orange),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.orange),
//                         ),
//                         contentPadding: EdgeInsets.only(
//                             left: 10, right: 10, bottom: 10, top: 10),
//                       ),
//                       keyboardType: TextInputType.text,
//                       onChanged: (value) {
//                         // Handle text changes
//                       },
//                     ),
//
//                     SizedBox(height: 40),
//
//                     // Padding(
//                     //   padding: const EdgeInsets.only(top:15, bottom: 5),
//                     //   child: Container(
//                     //     height: 220,
//                     //     width: MediaQuery.of(context).size.width,
//                     //     child: Image.asset(
//                     //       'assets/images/download.jpeg',
//                     //       fit: BoxFit.fill,
//                     //     ),
//                     //   ),
//                     // ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) {
//                             return BottomNavBar(device: widget.device);
//                           }),
//                         );
//                       },
//                       child: ButtonWidget(
//                         text: "Save",
//                         color: const Color(0xffFF9228),
//                         textColor: Colors.white,
//                         width: MediaQuery.of(context).size.width,
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//
//               SizedBox(
//                 height: (widget.device == "IOS") ? 80 : 30,
//               ),
//             ]),
//           ),
//         ));
//   }
//
//
//
// }
