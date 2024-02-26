//
// import 'package:flutter/material.dart';
// import '../Allwidgets/textForm_filed.dart';
//
// class AddPostScreen extends StatefulWidget {
//   final String device;
//   const AddPostScreen({super.key, required bool back, required this.device});
//
//   @override
//   State<AddPostScreen> createState() => _AddPostScreenState();
// }
// class _AddPostScreenState extends State<AddPostScreen> {
//   TextEditingController categoryController = TextEditingController();
//   TextEditingController topicController = TextEditingController();
//   TextEditingController partyController = TextEditingController();
//   TextEditingController statementController = TextEditingController();
//   TextEditingController reportedController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController financialController = TextEditingController();
//   TextEditingController evidenceController = TextEditingController();
//   TextEditingController monthController = TextEditingController();
//   TextEditingController yearController = TextEditingController();
//   TextEditingController month1Controller = TextEditingController();
//   TextEditingController year1Controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       // appBar: AppBar(
//       //   automaticallyImplyLeading: false,
//       //   elevation: 0,
//       //   backgroundColor: Colors.grey.shade200,
//       // ),
//
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 15,right: 15),
//           child: Column(mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('I need help for:',
//                  style: TextStyle(fontWeight: FontWeight.bold,
//                     fontSize: 18,color: Colors.black),
//                      ),
//
//                 // SizedBox(height: 20),
//                   Text('Select Category',
//                      style: TextStyle(fontWeight: FontWeight.w500,
//                        fontSize: 16,color: Colors.black),
//
//
//
//               ),
//
//               SizedBox(height: 10,),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius:BorderRadius.circular(10),
//                   color: Colors.white,),
//                 child: TextFormFieldWidget2(
//                   maxLines: 1,
//                   cursorColor: Color(0xffFF9228),
//                   controller: categoryController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Select Category',
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Text('Select topic',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),
//
//
//               ),
//
//               SizedBox(height: 10,),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius:BorderRadius.circular(10),
//                   color: Colors.white,),
//                 child: TextFormFieldWidget2(
//                   maxLines: 1,
//                   cursorColor: Color(0xffFF9228),
//                   controller: topicController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Select topic',
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Text('2nd Party (if any)',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),
//
//
//               ),
//
//               SizedBox(height: 10,),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius:BorderRadius.circular(10),
//                   color: Colors.white,),
//                 child: TextFormFieldWidget2(
//                   maxLines: 1,
//                   cursorColor: Color(0xffFF9228),
//                   controller: partyController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Any Party',
//                 ),
//               ),
//               // SizedBox(height: 10,),
//               SizedBox(height: 10,),
//               Text('Problem Statement',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),
//
//
//               ),
//
//               SizedBox(height: 10,),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius:BorderRadius.circular(10),
//                   color: Colors.white,),
//                 child: TextFormFieldWidget2(
//                   maxLines: 1,
//                   cursorColor: Color(0xffFF9228),
//                   controller: statementController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Problem Statement',
//                 ),
//               ),
//               SizedBox(height: 10,),
//
//
//
//
//
//
//
//
//
//
//               Text('Problem Started State:',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),),
//                  SizedBox(height: 10,),
//
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                   Container(height: 50,
//
//                     width: 170,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.white),
// child: TextFormFieldWidget2(
//   maxLines: 1,
//   cursorColor: Color(0xffFF9228),
//   controller:monthController,
//   inputType: TextInputType.text,
//   inputAction: TextInputAction.next,
//   obscureText: false,
//   hintText: "",
//   labeltext: 'Month',
// ),          ),
//
//                   // SizedBox(width: 50,),
//                   // Container()
//                     Container(height: 50,
//                       // color: Colors.orange,
//                       width: 170,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.white),
//                       child: TextFormFieldWidget2(
//                         maxLines: 1,
//                         cursorColor: Color(0xffFF9228),
//                         controller:yearController,
//                         inputType: TextInputType.text,
//                         inputAction: TextInputAction.next,
//                         obscureText: false,
//                         hintText: "",
//                         labeltext: 'Year',
//                       ),
//                     ),
//                 ],),
//
//                 SizedBox(height: 10,),
//
//
//
//
//               Text('Expected Solution From Madadguru',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),
//
//
//               ),
//               SizedBox(height: 10,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(height: 50,
//
//                     width: 170,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.white),
//                     child: TextFormFieldWidget2(
//                       maxLines: 1,
//                       cursorColor: Color(0xffFF9228),
//                       controller:month1Controller,
//                       inputType: TextInputType.text,
//                       inputAction: TextInputAction.next,
//                       obscureText: false,
//                       hintText: "",
//                       labeltext: 'Month',
//                     ),          ),
//
//                   // SizedBox(width: 50,),
//                   // Container()
//                   Container(height: 50,
//                     // color: Colors.orange,
//                     width: 170,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.white),
//                     child: TextFormFieldWidget2(
//                       maxLines: 1,
//                       cursorColor: Color(0xffFF9228),
//                       controller:year1Controller,
//                       inputType: TextInputType.text,
//                       inputAction: TextInputAction.next,
//                       obscureText: false,
//                       hintText: "",
//                       labeltext: 'Year',
//                     ),
//                   ),
//                 ],),
//
//
//
//               SizedBox(height: 10,),
//               Text('Already Reported To:',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),
//
//
//               ),
//
//               SizedBox(height: 10,),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius:BorderRadius.circular(10),
//                   color: Colors.white,),
//                 child: TextFormFieldWidget2(
//                   maxLines: 1,
//                   cursorColor: Color(0xffFF9228),
//                   controller:reportedController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Reported',
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Text('Problem Description',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),
//
//
//               ),
//
//               SizedBox(height: 10,),
//
//               // Container(
//               //   height: 100,
//               //   decoration: BoxDecoration(
//               //     borderRadius:BorderRadius.circular(10),
//               //     color: Colors.white,),
//               //   child: TextFormFieldWidget2(
//               //     maxLines: 3,
//               //     cursorColor: Color(0xffFF9228),
//               //     controller: descriptionController,
//               //     inputType: TextInputType.text,
//               //     inputAction: TextInputAction.next,
//               //     obscureText: false,
//               //     hintText: "",
//               //     labeltext: 'Description',
//               //   ),
//               // ),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius:BorderRadius.circular(12),
//                   color: Colors.white,),
//
//                 // color: Colors.white,
//                  child: TextField(
//                   maxLines: 3,
//                   controller: descriptionController,
//                   decoration: InputDecoration(
//                       hintText: 'hxbcss dbxjhd',
//                       label: Text('Profession'),
//                       labelStyle: TextStyle(color: Colors.orange),
//                       enabledBorder: OutlineInputBorder(
//
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: BorderSide(color: Colors.orange),
//                       ),
//                       contentPadding: EdgeInsets.only(
//                           left: 10, right: 10, bottom: 10, top: 10)),
//                   keyboardType: TextInputType.text,
//                   onChanged: (value) {
//                     // Handle text changes
//                   },
//                 ),
//               ),
//
//
//               SizedBox(height: 10,),
//               Text('Financial Status',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),
//
//
//
//               ),
//
//               SizedBox(height: 10,),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius:BorderRadius.circular(10),
//                   color: Colors.white,),
//                 child: TextFormFieldWidget2(
//                   maxLines: 1,
//                   cursorColor: Color(0xffFF9228),
//                   controller: financialController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Financial Status',
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Text('Upload Proof & Evidence',
//                 style: TextStyle(fontWeight: FontWeight.w500,
//                     fontSize: 16,color: Colors.black),
//
//
//
//               ),
//
//               SizedBox(height: 10,),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius:BorderRadius.circular(10),
//                   color: Colors.white,),
//                 child: TextFormFieldWidget2(
//                   maxLines: 1,
//                   cursorColor: Color(0xffFF9228),
//                   controller: evidenceController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Upload Proof & Evidence',
//                 ),
//               ),
//
// SizedBox(height: 30,),
//
//
//               InkWell(
//                 onTap: () {
//                   // Navigate to the second page
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) =>
//
//                         // PostScreen(device:widget.device,)),
//                     // BottomNavBar
//                   // );
//                 },
//
//
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 80,left: 80,bottom: 10),
//                   child: Card(
//                     elevation: 2,
//                     child: Container(
//                       height: 45,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Color(0xffFBCD96)),
//                       child: Center(
//                         child: Text(
//                           'SAVE',
//                           style: TextStyle(
//                               color: Colors.orange,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 17),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//
//           ),
//         ),
//       ),
//       // body: SingleChildScrollView(
//       //   child: Padding(
//       //     padding: const EdgeInsets.all(15.0),
//       //     child: Column(mainAxisAlignment: MainAxisAlignment.start,
//       //       crossAxisAlignment: CrossAxisAlignment.start,
//       //       children: [
//       //         Text('Social Media Links',
//       //           style: TextStyle(fontWeight: FontWeight.w700,
//       //               fontSize: 18,color: Colors.black),
//       //
//       //
//       //         ),
//       //
//       //         SizedBox(height: 40,),
//       //         Text('facebook',
//       //           style: TextStyle(fontWeight: FontWeight.w500,
//       //               fontSize: 16,color: Colors.black),
//       //
//       //
//       //
//       //         ),
//       //
//       //         SizedBox(height: 10,),
//       //
//       //         Container(
//       //           decoration: BoxDecoration(
//       //             borderRadius:BorderRadius.circular(10),
//       //             color: Colors.white,),
//       //           child: TextFormFieldWidget2(
//       //             maxLines: 1,
//       //             cursorColor: Color(0xffFF9228),
//       //             controller: facebookController,
//       //             inputType: TextInputType.text,
//       //             inputAction: TextInputAction.next,
//       //             obscureText: false,
//       //             hintText: "",
//       //             labeltext: 'facebook Link',
//       //           ),
//       //         ),
//       //         SizedBox(height: 10,),
//       //         Text('Google+',
//       //           style: TextStyle(fontWeight: FontWeight.w500,
//       //               fontSize: 16,color: Colors.black),
//       //
//       //
//       //         ),
//       //
//       //         SizedBox(height: 10,),
//       //
//       //         Container(
//       //           decoration: BoxDecoration(
//       //             borderRadius:BorderRadius.circular(10),
//       //             color: Colors.white,),
//       //           child: TextFormFieldWidget2(
//       //             maxLines: 1,
//       //             cursorColor: Color(0xffFF9228),
//       //             controller: googleController,
//       //             inputType: TextInputType.text,
//       //             inputAction: TextInputAction.next,
//       //             obscureText: false,
//       //             hintText: "",
//       //             labeltext: 'Instagram Link',
//       //           ),
//       //         ),
//       //         SizedBox(height: 10,),
//       //         Text('Instagram',
//       //           style: TextStyle(fontWeight: FontWeight.w500,
//       //               fontSize: 16,color: Colors.black),
//       //
//       //
//       //         ),
//       //
//       //         SizedBox(height: 10,),
//       //
//       //         Container(
//       //           decoration: BoxDecoration(
//       //             borderRadius:BorderRadius.circular(10),
//       //             color: Colors.white,),
//       //           child: TextFormFieldWidget2(
//       //             maxLines: 1,
//       //             cursorColor: Color(0xffFF9228),
//       //             controller: instagramController,
//       //             inputType: TextInputType.text,
//       //             inputAction: TextInputAction.next,
//       //             obscureText: false,
//       //             hintText: "",
//       //             labeltext: 'Instagram Link',
//       //           ),
//       //         ),
//       //         // SizedBox(height: 10,),
//       //         SizedBox(height: 10,),
//       //         Text('LinkedIn',
//       //           style: TextStyle(fontWeight: FontWeight.w500,
//       //               fontSize: 16,color: Colors.black),
//       //
//       //
//       //         ),
//       //
//       //         SizedBox(height: 10,),
//       //
//       //         Container(
//       //           decoration: BoxDecoration(
//       //             borderRadius:BorderRadius.circular(10),
//       //             color: Colors.white,),
//       //           child: TextFormFieldWidget2(
//       //             maxLines: 1,
//       //             cursorColor: Color(0xffFF9228),
//       //             controller: linkedinController,
//       //             inputType: TextInputType.text,
//       //             inputAction: TextInputAction.next,
//       //             obscureText: false,
//       //             hintText: "",
//       //             labeltext: 'LinkedIn Link',
//       //           ),
//       //         ),
//       //
//       //         SizedBox(height: 10,),
//       //         Text('Twitter',
//       //           style: TextStyle(fontWeight: FontWeight.w500,
//       //               fontSize: 16,color: Colors.black),
//       //
//       //
//       //         ),
//       //
//       //         SizedBox(height: 10,),
//       //
//       //         Container(
//       //           decoration: BoxDecoration(
//       //             borderRadius:BorderRadius.circular(10),
//       //             color: Colors.white,),
//       //           child: TextFormFieldWidget2(
//       //             maxLines: 1,
//       //             cursorColor: Color(0xffFF9228),
//       //             controller: twitterPasswordController,
//       //             inputType: TextInputType.text,
//       //             inputAction: TextInputAction.next,
//       //             obscureText: false,
//       //             hintText: "",
//       //             labeltext: 'Twitter Link',
//       //           ),
//       //         ),
//       //         SizedBox(height: 70,),
//       //         // SizedBox(height: 120,),
//       //
//       //         InkWell(
//       //           onTap: () {
//       //             // Navigate to the second page
//       //             Navigator.push(
//       //               context,
//       //               MaterialPageRoute(builder: (context) =>
//       //
//       //                   PostScreen(device:widget.device, )),
//       //               // BottomNavBar
//       //             );
//       //           },
//       //
//       //
//       //           child: Padding(
//       //             padding: const EdgeInsets.only(right: 80,left: 80),
//       //             child: Card(
//       //               elevation: 2,
//       //               child: Container(
//       //                 height: 45,
//       //                 width: MediaQuery.of(context).size.width,
//       //                 decoration: BoxDecoration(
//       //                     borderRadius: BorderRadius.circular(12),
//       //                     color: Color(0xffFBCD96)),
//       //                 child: Center(
//       //                   child: Text(
//       //                     'SAVE',
//       //                     style: TextStyle(
//       //                         color: Colors.orange,
//       //                         fontWeight: FontWeight.bold,
//       //                         fontSize: 17),
//       //                   ),
//       //                 ),
//       //               ),
//       //             ),
//       //           ),
//       //         ),
//       //       ],
//       //
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
import 'dart:async';

// import 'package:example/overlay_example.dart';
import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

void main() {
  runApp(const ImageGalleryExampleApp());
}

class ImageGalleryExampleApp extends StatelessWidget {
  const ImageGalleryExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      const ImageGalleryExamplesPage(title: 'Image Gallery Demo Home Page'),
    );
  }
}

final urls = [
  'https://via.placeholder.com/400',
  'https://via.placeholder.com/800',
  'https://via.placeholder.com/900x350',
  'https://via.placeholder.com/1000',
  'https://via.placeholder.com/100',
];

final remoteImages = [
  Image.network('https://via.placeholder.com/400'),
  Image.network('https://via.placeholder.com/800'),
  Image.network('https://via.placeholder.com/900x350'),
  Image.network('https://via.placeholder.com/1000'),
  Image.network('https://via.placeholder.com/100'),
];

const assets = [
  Image(image: AssetImage('assets/1.jpeg')),
  Image(image: AssetImage('assets/2.jpeg')),
  Image(image: AssetImage('assets/3.jpeg')),
  Image(image: AssetImage('assets/4.jpeg')),
];

final widgets = [
  Container(
    color: Colors.white,
    child: const Center(
      child: Text('First Page', style: TextStyle(fontSize: 24.0)),
    ),
  ),
  Container(
    color: Colors.grey,
    child: const Center(
      child: Text('Second Page', style: TextStyle(fontSize: 24.0)),
    ),
  ),
];

class ImageGalleryExamplesPage extends StatefulWidget {
  const ImageGalleryExamplesPage({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<ImageGalleryExamplesPage> createState() =>
      _ImageGalleryExamplesPageState();
}

class _ImageGalleryExamplesPageState extends State<ImageGalleryExamplesPage> {
  final heroProperties = [
    const ImageGalleryHeroProperties(tag: 'imageId1'),
    const ImageGalleryHeroProperties(tag: 'imageId2'),
  ];
  ImageGalleryController galleryController =
  ImageGalleryController(initialPage: 2);
  StreamController<Widget> overlayController =
  StreamController<Widget>.broadcast();

  @override
  void dispose() {
    overlayController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                await SwipeImageGallery(
                  context: context,
                  children: remoteImages,
                  // onSwipe: (index) {
                  //   overlayController.add(OverlayExample(
                  //     title: '${index + 1}/${remoteImages.length}',
                  //   ));
                  // },
                  overlayController: overlayController,
                  // initialOverlay: OverlayExample(
                  //   title: '1/${remoteImages.length}',
                  // ),
                  backgroundOpacity: 0.5,
                ).show();

                print('DOOONE');
              },
              child: const Text('Open Gallery With Overlay'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                children: remoteImages,
                initialIndex: 2,
              ).show(),
              child: const Text('Open Gallery With URLs'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                children: widgets,
              ).show(),
              child: const Text('Open Gallery With Widgets'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                children: assets,
              ).show(),
              child: const Text('Open Gallery With Assets'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                children: assets,
                controller: galleryController,
              ).show(),
              child: const Text('Open Gallery With Controller'),
            ),
            ElevatedButton(
              onPressed: () => SwipeImageGallery(
                context: context,
                itemBuilder: (context, index) {
                  return Image.network(urls[index]);
                },
                itemCount: urls.length,
                // ignore: avoid_print
                onSwipe: (index) => print(index),
              ).show(),
              child: const Text('Open Gallery With Builder'),
            ),
            const Text('Hero Animation Example'),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => SwipeImageGallery(
                      context: context,
                      children: [assets[0], assets[1]],
                      heroProperties: heroProperties,
                    ).show(),
                    child: const Hero(
                      tag: 'imageId1',
                      child: Image(
                        image: AssetImage('assets/1.jpeg'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => SwipeImageGallery(
                      context: context,
                      children: [assets[0], assets[1]],
                      initialIndex: 1,
                      heroProperties: heroProperties,
                    ).show(),
                    child: const Hero(
                      tag: 'imageId2',
                      child: Image(
                        image: AssetImage('assets/2.jpeg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}