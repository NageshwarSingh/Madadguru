// import 'package:flutter/material.dart';
//
// import '../Allwidgets/textForm_filed.dart';
//
//
// class AddSocialScreen extends StatefulWidget {
//   final String device;
//   const AddSocialScreen({super.key, required this.device,});
//
//   @override
//   State<AddSocialScreen> createState() => _AddSocialScreenState();
// }
//
// class _AddSocialScreenState extends State<AddSocialScreen> {
//   TextEditingController facebookController = TextEditingController();
//   TextEditingController googleController = TextEditingController();
//   TextEditingController instagramController = TextEditingController();
//   TextEditingController linkedinController = TextEditingController();
//   TextEditingController twitterPasswordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.grey.shade200,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Social Media Links',
//                 style: TextStyle(fontWeight: FontWeight.w700,
//                     fontSize: 18,color: Colors.black),
//
//
//               ),
//
//               SizedBox(height: 40,),
//               Text('facebook',
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
//                   controller: facebookController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'facebook Link',
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Text('Google+',
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
//                   controller: googleController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Instagram Link',
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Text('Instagram',
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
//                   controller: instagramController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Instagram Link',
//                 ),
//               ),
//               // SizedBox(height: 10,),
//               SizedBox(height: 10,),
//               Text('LinkedIn',
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
//                   controller: linkedinController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'LinkedIn Link',
//                 ),
//               ),
//
//               SizedBox(height: 10,),
//               Text('Twitter',
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
//                   controller: twitterPasswordController,
//                   inputType: TextInputType.text,
//                   inputAction: TextInputAction.next,
//                   obscureText: false,
//                   hintText: "",
//                   labeltext: 'Twitter Link',
//                 ),
//               ),
//               SizedBox(height: 70,),
//               // SizedBox(height: 120,),
//
//               InkWell(
//                 onTap: () {
//                   // Navigate to the second page
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) =>
//                   //
//                   //       PostScreen(device:widget.device, )),
//                   //   // BottomNavBar
//                   // );
//                 },
//
//
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 80,left: 80),
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
//
//
//
//     );
//   }
// }
