// // import 'dart:convert';
// //
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import '../services/basicService.dart';
// // import 'blogdetail.dart';
// //
// // class Blogs extends StatefulWidget {
// //   const Blogs({Key? key}) : super(key: key);
// //
// //   @override
// //   State<Blogs> createState() => _BlogsState();
// // }
// //
// // class _BlogsState extends State<Blogs> {
// //   final BasicService _basicService =
// //       BasicService(); // Instantiate your BasicService
// //   dynamic page = 0;
// //   dynamic limit = 10;
// //   List<dynamic> _blogPosts = []; // List to hold fetched blog posts
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchBlogPosts();
// //      }
// //      Future<void> _fetchBlogPosts() async {
// //       try {
// //        final response = await _basicService.blogPosts(page, limit);
// //          if (response.statusCode == 200) {
// //            setState(() {
// //           _blogPosts = json.decode(response.body);
// //           print("the posts are:${_blogPosts}s");
// //         });
// //       } else {
// //         // Handle error
// //         print('Failed to fetch blog posts: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       // Handle error
// //       print('Exception while fetching blog posts: $e');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Blogs'),
// //         flexibleSpace: Container(
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.centerLeft,
// //               end: Alignment.centerRight,
// //               colors: <Color>[Color(0xff92cfae), Color(0xff249cb7)],
// //             ),
// //           ),
// //         ),
// //         elevation: 0.0,
// //       ),
// //       body: ListView.builder(
// //         itemCount: _blogPosts.length,
// //         itemBuilder: (context, index) {
// //           final post = _blogPosts[index];
// //           return GestureDetector(
// //             onTap: () {
// //               print("the post id ${post["id"] ?? 0}");
// //               // Get.toNamed("blogdetailed",
// //               //     arguments: {"id": post["id"]
// //               //     }
// //               //     );
// //               Get.to(blogDetails(post["id"]));
// //             },
// //             child: Card(
// //               margin: const EdgeInsets.all(8.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   post["featureImg"] == "" || post["featureImg"] == null
// //                       ? Image.asset(
// //                           "assets/images/noimageavailable.png",
// //                           height: 200.0,
// //                           width: double.infinity,
// //                           fit: BoxFit.contain,
// //                         )
// //                       : Image.network(
// //                           post["featureImg"],
// //                           height: 200.0,
// //                           width: double.infinity,
// //                           fit: BoxFit.fitWidth,
// //                         ),
// //                   Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Text(
// //                       post["title"] ?? "",
// //                       style: const TextStyle(fontSize: 16.0),
// //                     ),
// //                   ),
// //                   post["tags"] == null || post["tags"].length < 1
// //                       ? const SizedBox()
// //                       : Wrap(
// //                           children: post["tags"].map<Widget>((tag) {
// //                             return Container(
// //                               margin:
// //                                   const EdgeInsets.only(left: 10, bottom: 8),
// //                               // height: 20,
// //                               decoration: BoxDecoration(
// //                                 borderRadius: BorderRadius.circular(5),
// //                                 color: Colors.black12,
// //                               ),
// //                               child: Padding(
// //                                 padding: const EdgeInsets.all(8.0),
// //                                 child: Text(tag),
// //                               ),
// //                             );
// //                           }).toList(),
// //                         ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
//
// class MyWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> ndata;
//   final List<Map<String, dynamic>> pdata;
//
//   MyWidget({required this.ndata, required this.pdata});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: ndata.length,
//       itemBuilder: (BuildContext context, int index) {
//         // Check if ndata[index]["id"] matches to any pdata["id"]
//         bool isActive = pdata.any((element) => element["id"] == ndata[index]["id"]);
//
//         return Container(
//           padding: EdgeInsets.all(8.0),
//           margin: EdgeInsets.symmetric(vertical: 4.0),
//           decoration: BoxDecoration(
//             border: Border.all(color: isActive ? Colors.green : Colors.red), // Change border color based on isActive
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   ndata[index]["name"],
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//               ),
//               if (isActive)
//                 ElevatedButton(
//                   onPressed: () {
//                     // Do something when the button is pressed
//                     print("Button pressed for id: ${ndata[index]["id"]}");
//                   },
//                   child: Text("Active"),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text("ListView Builder Example"),
//       ),
//       body: MyWidget(
//         ndata: [
//           {"id": 1, "name": "Item 1"},
//           {"id": 2, "name": "Item 2"},
//           {"id": 3, "name": "Item 3"},
//         ],
//         pdata: [
//           {"id": 2, "name": "Item 2"},
//           {"id": 3, "name": "Item 3"},
//         ],
//       ),
//     ),
//   ));
// }
