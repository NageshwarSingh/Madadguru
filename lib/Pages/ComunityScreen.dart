// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// //
// // class CommunityScreen extends StatefulWidget {
// //   final String device;
// //   const CommunityScreen({
// //     Key? key,
// //     required this.device,
// //   }) : super(key: key);
// //   @override
// //   State<CommunityScreen> createState() => _CommunityScreenState();
// // }
// //
// // class _CommunityScreenState extends State<CommunityScreen> {
// //   int selectedValue = 0;
// //   bool isSelected = false;
// //   var selectIndex = "";
// //   List<String> exampleList = ["Incentives", " Benefits", "Bike"];
// //   List<String> images = [
// //     'assets/images/building.jpg',
// //     'assets/images/lalkila.webp',
// //     'assets/images/roads.jpg',
// //     'assets/images/socialImage.jpeg',
// //     'assets/images/building.jpg',
// //     'assets/images/lalkila.webp',
// //     'assets/images/roads.jpg',
// //     'assets/images/socialImage.jpeg',
// //   ];
// //   List<String> imagesProfile = [
// //     'assets/images/people.jpg',
// //     'assets/images/people.webp',
// //     'assets/images/enjoy.png',
// //     'assets/images/people.jpg',
// //     'assets/images/people.webp',
// //     'assets/images/people.jpg',
// //     'assets/images/people.webp',
// //     'assets/images/people.jpg',
// //   ];
// //
// //   List<String> imagesProfile1 = [
// //     'assets/images/enjoy.png',
// //     'assets/images/enjoy.png',
// //     'assets/images/enjoy.png',
// //     'assets/images/enjoy.png',
// //     'assets/images/enjoy.png',
// //   ];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         title: Text(
// //           "Community",
// //           style: GoogleFonts.roboto(
// //             fontSize: 20,
// //             fontWeight: FontWeight.w500,
// //             color: Colors.black,
// //           ),
// //         ),
// //        ),
// //       backgroundColor: Colors.white,
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             color:Colors.white,
// //             child: Padding(
// //               padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
// //               // all(15.0),
// //               child: Column(
// //                 children: [
// //                   Text(
// //                     'Madadguru Support Community',
// //                     style: GoogleFonts.roboto(
// //                       fontSize: 25,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   Text(
// //                     'Find answer. Akk question. Connect with Madadguru customers around the world.',
// //                     textAlign: TextAlign.center,
// //                     style: GoogleFonts.roboto(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w400,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   SizedBox(
// //                     height: 25,
// //                   ),
// //                   Container(
// //                     height: 40,
// //                     alignment: Alignment.center,
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xffffffff),
// //                       border: Border.all(color: Colors.black38, width: 1.5),
// //                       borderRadius: const BorderRadius.all(Radius.circular(10)),
// //                     ),
// //                     child: TextField(
// //                         autofocus: false,
// //                         // controller: searchController,
// //                         keyboardType: TextInputType.text,
// //                         textInputAction: TextInputAction.search,
// //                         decoration: InputDecoration(
// //                             prefixIcon: Icon(
// //                               Icons.search,
// //                               color: Color(0xff7a7979),
// //                               size: 25,
// //                             ),
// //                             suffixIcon: const Icon(
// //                               Icons.cancel,
// //                               color: Color(0xff7a7979),
// //                               size: 25,
// //                             ),
// //                             contentPadding: EdgeInsets.only(left: 5, right: 5),
// //                             // const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
// //                             border: InputBorder.none,
// //                             hintText: "Search or ask a question",
// //                             hintStyle: TextStyle(
// //                               color: const Color(0xff7a7979),
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w500,
// //                             )),
// //                         onSubmitted: (_) {}),
// //                   ),
// //                 ],
// //                ),
// //               ),
// //              ),
// //              SizedBox(
// //             height: 10,
// //           ),
// //           buildListView(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget buildListView() {
// //     return Expanded(
// //       // child: Text('data'),
// //       child: ListView.builder(
// //           scrollDirection: Axis.vertical,
// //           itemCount: 8,
// //           shrinkWrap: true,
// //           padding: EdgeInsets.zero,
// //           itemBuilder: (context, index) {
// //             return Stack(children: [
// //               GestureDetector(
// //                 // onTap: () {
// //                 //   Navigator.push(
// //                 //     context,
// //                 //     MaterialPageRoute(builder: (context) {
// //                 //       return FeedDetailScreen(
// //                 //         device: widget.device, Device: '',
// //                 //       );
// //                 //     }),
// //                 //   );
// //                 // },
// //                 child: Container(
// //                   color: Colors.white,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Padding(
// //                         padding: const EdgeInsets.only(left: 15, top: 10),
// //                         child: Row(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Row( crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 CircleAvatar(
// //                                   radius: 25,
// //                                   child: ClipOval(
// //                                     child: Image.asset(
// //                                       imagesProfile[index],
// //                                       // 'assets/images/download.jpeg',
// //                                       fit: BoxFit.cover,
// //                                       width: 60.0, // adjust width as needed
// //                                       height: 60.0, // adjust height as needed
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(
// //                                   width: 20,
// //                                 ),
// //                                 Column(crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     // Text(
// //                                     //   "@roshni rosi",
// //                                     //   style: GoogleFonts.roboto(
// //                                     //       fontSize: 12,
// //                                     //       fontWeight: FontWeight.bold,
// //                                     //       color: Colors.black),
// //                                     // ),
// //                                     // SizedBox(height: 5,),
// //                                      Text(
// //                                       'How does Madadguru work ?',
// //                                         style: GoogleFonts.roboto(
// //                                           fontSize: 12,
// //                                           fontWeight: FontWeight.bold,
// //                                           color: Colors.black),
// //                                     ),
// //                                     SizedBox(height: 7,),
// //                                     Text(
// //                                       'Madadguru nonate as per your wish to help \n supply ready to eat..',
// //                                       style: GoogleFonts.roboto(
// //                                           fontSize: 12,
// //                                           fontWeight: FontWeight.w400,
// //                                           color: Colors.black),
// //                                     ),
// //                                     SizedBox(height: 7,),
// //                                     Row(
// //                                       children: [
// //                                         Text('Asked by',style: GoogleFonts.roboto(
// //                                             fontSize: 10,
// //                                             fontWeight: FontWeight.w400,
// //                                             color: Colors.blue),),
// //                                         SizedBox(width: 3,),
// //                                         Text('jmsalor',style: GoogleFonts.roboto(
// //                                             fontSize: 10,
// //                                             fontWeight: FontWeight.w400,
// //                                             color: Colors.black),),
// //                                         SizedBox(width: 3,),
// //                                         Text('one month ago',style: GoogleFonts.roboto(
// //                                             fontSize: 10,
// //                                             fontWeight: FontWeight.w400,
// //                                             color: Colors.blue),),
// //                                       ],
// //                                     ),
// //                                     Row(
// //                                       children: [
// //                                         Text('Latest by',style: GoogleFonts.roboto(
// //                                             fontSize: 10,
// //                                             fontWeight: FontWeight.w400,
// //                                             color: Colors.blue),),
// //                                         SizedBox(width: 3,),
// //                                         Text('sravan',style: GoogleFonts.roboto(
// //                                             fontSize: 10,
// //                                             fontWeight: FontWeight.w400,
// //                                             color: Colors.black),),
// //                                         SizedBox(width: 3,),
// //                                         Text('20 days ago',style: GoogleFonts.roboto(
// //                                             fontSize: 10,
// //                                             fontWeight: FontWeight.w400,
// //                                             color: Colors.blue),),
// //                                       ],
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ],
// //                               ),
// //                             // Text('reply')
// //
// //                             // IconButton(
// //                             //     icon: Icon(Icons.more_horiz),
// //                             //     onPressed: () {
// //                             //       // When the icon is tapped, show a SnackBar
// //                             //       showDialog(
// //                             //           context: context,
// //                             //           builder: (BuildContext context) {
// //                             //             return AlertDialog(
// //                             //               title: Text('Delete'),
// //                             //               content: Text(
// //                             //                   'Are you sure you want to delete?'),
// //                             //               actions: [
// //                             //                 TextButton(
// //                             //                   onPressed: () {
// //                             //                     // Close the dialog
// //                             //                     Navigator.of(context).pop();
// //                             //                   },
// //                             //                   child: Text('Cancel'),
// //                             //                 ),
// //                             //                 TextButton(
// //                             //                   onPressed: () {
// //                             //                     // Perform the delete operation and close the dialog
// //                             //                     // Add your delete logic here
// //                             //                     Navigator.of(context).pop();
// //                             //                   },
// //                             //                   child: Text('Delete'),
// //                             //                 ),
// //                             //               ],
// //                             //             );
// //                             //           });
// //                             //     }),
// //                             ],
// //                           ),
// //                          ),
// //
// //
// //
// //                       SizedBox(
// //                         height: 20,
// //                       ),
// //                       // Divider()
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ]);
// //           }),
// //     );
// //   }
// // }
//  import 'package:flutter/material.dart';
//
//
// class CommunityScreen extends StatefulWidget {
//   final String device;
//    const CommunityScreen({super.key, required this.device, });
//
//    @override
//    State<CommunityScreen> createState() => _CommunityScreenState();
//  }
//
//  class _CommunityScreenState extends State<CommunityScreen> {
//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        backgroundColor: Colors.white,
//        appBar:AppBar(
//          title: Text('Community'),
//           ),
//           body:SingleChildScrollView(
//            child:Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: [
//                SizedBox(height: 100,),
//                // Image.asset('assets/images/images.jpg'),
//
//                Card(
//                  elevation: 1,
//                  child: Container(
//                    width: MediaQuery.of(context).size.width,
//                    height: 300,
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(32),
//                        bottomRight: Radius.circular(12),
//                      ),
//                    ),
//                    child: ClipRRect(
//                      borderRadius: BorderRadius.circular(12
//                        // bottomLeft: Radius.circular(32),
//                        // bottomRight: Radius.circular(32),
//                      ),
//                      child:
//                      // Image.network('')
//                      Image.asset(
//                        'assets/images/images.jpg',
//                        fit: BoxFit.fill,
//                      ),
//                    ),
//                    ),
//                  ),
//
//                SizedBox(height: 30,),
//                Padding(
//                  padding: const EdgeInsets.only(
//                      right: 60, left: 60, top: 10, bottom: 10),
//                  child: Card(
//                    elevation: 2,
//                    child: Container(
//                      height: 45,
//                      width: MediaQuery.of(context).size.width,
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(12),
//                          color: Color(0xffFBCD96)),
//                      child: Center(
//                        child: Text(
//                          'Join Commit',
//                          style: TextStyle(
//                              color: Colors.orange,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 15),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//
//              ],
//            ),
//           ),
//      );
//    }
//
//  }
