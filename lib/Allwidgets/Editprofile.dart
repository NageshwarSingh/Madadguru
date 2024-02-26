// // import 'package:flutter/material.dart';
// //
// // class EditProfile extends StatefulWidget {
// //   final String device;
// //   const EditProfile({super.key, required this.device});
// //
// //   @override
// //   State<EditProfile> createState() => _EditProfileState();
// // }
// //
// // class _EditProfileState extends State<EditProfile> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //
// //     );
// //   }
// // }
// import 'dart:io';
// import 'dart:ui';
// import 'package:chips_choice/chips_choice.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:madadguru/Pages/EnquaryScreen.dart';
// import 'package:madadguru/Pages/SettingScreen.dart';
// import '../Allwidgets/AboutUs.dart';
// import '../Allwidgets/Account_JobPreference.dart';
// import '../Allwidgets/FaqScreen.dart';
// import '../Allwidgets/textForm_filed.dart';
//
// class EditProfile extends StatefulWidget {
//   final String device;
//   const EditProfile({
//     super.key,
//     required this.device,
//   });
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController _genderController = TextEditingController();
//   final TextEditingController _aboutController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _professionController = TextEditingController();
//   String selectedGender = '';
//   var Gender;
//   var gender = ["Male", "Female", "Other"];
//   File? imageFile;
//   bool isfieldsIn = false;
//   List<dynamic> Data = [];
//   List<dynamic> items = [
//     'hjfjg',
//     'bdbds',
//     'vdvsb',
//     'sndkj',
//     'jhbdh',
//   ];
//   var Language;
//   var language = ['Hindi', 'English', 'Marathi', 'Bengali'];
//   var Profession;
//   var profession = [
//     'Private',
//     'Gort Job',
//     'Business',
//     'Student',
//     'House Wife',
//     'Un-Employed',
//     'NGO Worker',
//     'Other',
//     '',
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Edit Profile',
//           style: GoogleFonts.roboto(
//             color: Colors.black,
//             fontWeight: FontWeight.w400,
//             fontSize: 14,
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: <Widget>[
//           Stack(children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               // height: 300,
//               // decoration: BoxDecoration(
//               //   color: Colors.orange.shade800,
//               //   borderRadius: BorderRadius.only(
//               //     bottomLeft: Radius.circular(32),
//               //     bottomRight: Radius.circular(32),
//               //   ),
//               //   ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(32),
//                   bottomRight: Radius.circular(32),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//
//                       const SizedBox(
//                         height: 20,
//                       ),
//
//                       Container(
//                         alignment: Alignment.center,
//                         // width: double.infinity,
//                         child: GestureDetector(
//                           onTap: () {
//                             showModalBottomSheet(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(25),
//                                     topLeft: Radius.circular(25),
//                                   ),
//                                 ),
//                                 context: context,
//                                 builder: (BuildContext bc) {
//                                   return StatefulBuilder(builder:
//                                       (BuildContext context,
//                                           StateSetter setState) {
//                                     return BackdropFilter(
//                                         filter: ImageFilter.blur(
//                                             sigmaX: 0.3, sigmaY: 0.3),
//                                         child: Container(
//                                           padding: const EdgeInsets.all(20),
//                                           child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () async {
//                                                     Navigator.pop(context);
//                                                     await _getFromCamera();
//                                                   },
//                                                   child: Row(children: [
//                                                     Icon(
//                                                       Icons.camera_alt_outlined,
//                                                       color: Colors.blue,
//                                                     ),
//                                                     // Image.asset(
//                                                     //   "assets/icons/photo-camera-interface-symbol-for-button.png",
//                                                     //   width: 25,
//                                                     //   color: Colors.black54,
//                                                     // ),
//                                                     const SizedBox(
//                                                       width: 20,
//                                                     ),
//                                                     Text(
//                                                       "Take Photo",
//                                                       style: GoogleFonts.roboto(
//                                                         textStyle:
//                                                             const TextStyle(
//                                                           color: Colors.black54,
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ]),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () async {
//                                                     Navigator.pop(context);
//                                                     await _getFromGallery();
//                                                   },
//                                                   child: Row(children: [
//                                                     Image.asset(
//                                                       "assets/images/gallery.png",
//                                                       width: 25,
//                                                       color: Colors.blue,
//                                                     ),
//                                                     const SizedBox(
//                                                       width: 20,
//                                                     ),
//                                                     Text(
//                                                       "Select from gallery",
//                                                       style: GoogleFonts.roboto(
//                                                         textStyle:
//                                                             const TextStyle(
//                                                           color: Colors.black54,
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ]),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                               ]),
//                                         ));
//                                   });
//                                 });
//                           },
//                           child: Stack(clipBehavior: Clip.none, children: [
//                             (imageFile == null)
//                                 ? CircleAvatar(
//                                     radius: 45,
//                                     child: ClipOval(
//                                       child: Image.asset(
//                                         'assets/images/people.webp',
//                                         fit: BoxFit.cover,
//                                         width: 90.0, // adjust width as needed
//                                         height: 90.0, // adjust height as needed
//                                       ),
//                                     ),
//                                   )
//                                 : CircleAvatar(
//                                     radius: 45,
//                                     child: ClipOval(
//                                       child: Image.asset(
//                                         'assets/images/people.webp',
//                                         fit: BoxFit.cover,
//                                         width: 90.0, // adjust width as needed
//                                         height: 90.0, // adjust height as needed
//                                       ),
//                                     ),
//                                   ),
//                             Positioned(
//                               bottom: 10,
//                               right: -5,
//                               child: CircleAvatar(
//                                 radius: 16,
//                                 backgroundColor:
//                                     Color(0xffFF9228).withOpacity(0.7),
//                                 child: Icon(
//                                   Icons.edit,
//
//                                   color: Colors.white,
//                                   // width: 16,
//                                 ),
//                               ),
//                             ),
//                           ]),
//                         ),
//                       ),
//
//                       // SizedBox(
//                       //   height: 10,
//                       // ),
//                       // Text('Rajesh Rajesh Rajesh',
//                       //     style: TextStyle(
//                       //         color: Colors.white,
//                       //         fontWeight: FontWeight.w500,
//                       //         fontSize: 14)),
//                       // SizedBox(
//                       //   height: 5,
//                       // ),
//                       // Text(
//                       //   '   Greater Noida',
//                       //   style: TextStyle(
//                       //       color: Colors.white,
//                       //       fontWeight: FontWeight.w500,
//                       //       fontSize: 14),
//                       // ),
//                       // SizedBox(
//                       //   height: 20,
//                       // ),
//                       // // SizedBox(height: 5,),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Name',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color(0xffFFF1E7),
//                   ),
//                   child: TextFormFieldWidget1(
//                     cursorColor: Color(0xffFF9228),
//                     controller: nameController,
//                     inputType: TextInputType.text,
//                     inputAction: TextInputAction.next,
//                     obscureText: false,
//                     hintText: "Enter your full name",
//                     // labeltext: 'Name',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Email',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color(0xffFFF1E7),
//                   ),
//                   child: TextFormFieldWidget1(
//                     cursorColor: Color(0xffFF9228),
//                     controller: phoneController,
//                     inputType: TextInputType.text,
//                     inputAction: TextInputAction.next,
//                     obscureText: false,
//                     // labeltext: "Gmail",
//                     hintText: "Enter your Gmail",
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Phone Number',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color(0xffFFF1E7),
//                   ),
//                   child: TextFormFieldWidget1(
//                     cursorColor: Color(0xffFF9228),
//                     controller: phoneController,
//                     inputType: TextInputType.number,
//                     inputAction: TextInputAction.next,
//                     obscureText: false,
//                     // labeltext: "Phone",
//                     hintText: "Enter your Phone",
//                   ),
//                 ),
//
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Date of Birth',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Color(0xffFFF1E7)),
//                   child: TextField(
//                     readOnly: true,
//                     cursorColor: Color(0xffFF9228),
//                     obscureText: false,
//                     controller: dobController,
//                     keyboardType: TextInputType.text,
//                     textInputAction: TextInputAction.done,
//                     decoration: InputDecoration(
//                       suffixIcon: IconButton(
//                           onPressed: () async {
//                             DateTime? pickedDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime(1950),
//                                 lastDate: DateTime(2100));
//                             setState(() {
//                               dobController.text = DateFormat('dd-MM-yyyy')
//                                   .format(DateTime.parse(pickedDate.toString()))
//                                   .toString();
//                             });
//                           },
//                           icon: const Icon(
//                             Icons.calendar_month,
//                             color: Colors.black45,
//                             size: 23,
//                           )),
//                           enabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                             width: 1.5, color: Color(0xffFFF1E7)),
//                         borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(width: 1.5, color: Colors.black45),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       // labelText: "Date of birth",
//                       // labelStyle: GoogleFonts.roboto(
//                       //     fontSize: 15,
//                       //     fontWeight: FontWeight.w400,
//                       //     color: Colors.black45),
//                       hintText: "Date of birth",
//                       hintStyle: GoogleFonts.roboto(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black45),
//                     ),
//                     style: GoogleFonts.roboto(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Gender',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(left: 7),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     // border: Border.all(width: 1.5, color: Colors.orange),
//     color: Color(0xffFFF1E7),
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: InputDecorator(
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                       ),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         style: GoogleFonts.roboto(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.orange),
//                         dropdownColor: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         value: Gender,
//                         isExpanded: true,
//                         icon: const Icon(
//                           Icons.keyboard_arrow_down,
//                           size: 30,
//                           color: Colors.black38,
//                         ),
//                         hint: Text(
//                           "Gender",
//                           style: GoogleFonts.roboto(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.black38),
//                         ),
//                         elevation: 1,
//                         underline: Container(height: 1, color: Colors.orange),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             Gender = newValue!;
//                             _genderController.text = newValue;
//                           });
//                         },
//                         items: gender
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: GoogleFonts.roboto(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Container(
//                 //       height: 50,
//                 //       width: 170,
//                 //       decoration: BoxDecoration(
//                 //           borderRadius: BorderRadius.circular(12),
//                 //           color: Color(0xffFFF1E7)),
//                 //       child: Center(
//                 //         child: RadioListTile(
//                 //           title: Text('Male'),
//                 //           value: 'male',
//                 //           groupValue: selectedGender,
//                 //           onChanged: (value) {
//                 //             setState(() {
//                 //               selectedGender = value!;
//                 //             });
//                 //           },
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     // Container(
//                 //     //   height: 50,
//                 //     //   width: 170,
//                 //     //   decoration: BoxDecoration(
//                 //     //       borderRadius: BorderRadius.circular(10),
//                 //     //       color: Color(0xffFFF1E7)),
//                 //     //   child: Center(
//                 //     //     child: RadioListTile(
//                 //     //       title: Text('Female'),
//                 //     //       value: 'female',
//                 //     //       groupValue: selectedGender,
//                 //     //       onChanged: (value) {
//                 //     //         setState(() {
//                 //     //           selectedGender = value!;
//                 //     //         });
//                 //     //       },
//                 //     //     ),
//                 //     //   ),
//                 //     // ),
//                 //     Container(
//                 //       padding: EdgeInsets.only(left: 7),
//                 //       alignment: Alignment.center,
//                 //       decoration: BoxDecoration(
//                 //         border: Border.all(width: 1.5, color: Colors.orange),
//                 //         color: Colors.transparent,
//                 //         borderRadius: BorderRadius.all(Radius.circular(10)),
//                 //       ),
//                 //       child: InputDecorator(
//                 //         decoration: const InputDecoration(
//                 //           border: InputBorder.none,
//                 //           contentPadding: EdgeInsets.symmetric(
//                 //             horizontal: 10,
//                 //           ),
//                 //         ),
//                 //         child: DropdownButtonHideUnderline(
//                 //           child: DropdownButton<String>(
//                 //             style: GoogleFonts.roboto(
//                 //                 fontSize: 12,
//                 //                 fontWeight: FontWeight.w400,
//                 //                 color: Colors.orange),
//                 //             dropdownColor: Colors.white,
//                 //             borderRadius: BorderRadius.circular(10),
//                 //             value: Gender,
//                 //             isExpanded: true,
//                 //             icon: const Icon(
//                 //               Icons.keyboard_arrow_down,
//                 //               size: 30,
//                 //               color: Colors.black38,
//                 //             ),
//                 //             hint: Text(
//                 //               "Gender",
//                 //               style: GoogleFonts.roboto(
//                 //                   fontSize: 12,
//                 //                   fontWeight: FontWeight.w400,
//                 //                   color: Colors.black38),
//                 //             ),
//                 //             elevation: 1,
//                 //             underline: Container(height: 1, color: Colors.orange),
//                 //             onChanged: (String? newValue) {
//                 //               setState(() {
//                 //                 Gender = newValue!;
//                 //                 _genderController.text = newValue;
//                 //               });
//                 //             },
//                 //             items: gender
//                 //                 .map<DropdownMenuItem<String>>((String value) {
//                 //               return DropdownMenuItem<String>(
//                 //                 value: value,
//                 //                 child: Text(
//                 //                   value,
//                 //                   style: GoogleFonts.roboto(
//                 //                       fontSize: 12,
//                 //                       fontWeight: FontWeight.w400,
//                 //                       color: Colors.black),
//                 //                 ),
//                 //               );
//                 //             }).toList(),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // SizedBox(height: 10),
//                 // Text(
//                 //   'Location',
//                 //   style: GoogleFonts.roboto(
//                 //     color: Colors.black,
//                 //     fontWeight: FontWeight.w400,
//                 //     fontSize: 14,
//                 //   ),
//                 // ),
//                 // SizedBox(height: 10),
//                 // Container(
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(10),
//                 //     color: Color(0xffFFF1E7),
//                 //   ),
//                 //   child: TextFormFieldWidget1(
//                 //     cursorColor: Color(0xffFF9228),
//                 //     controller: locationController,
//                 //     inputType: TextInputType.text,
//                 //     inputAction: TextInputAction.next,
//                 //     obscureText: false,
//                 //     labeltext: "Location",
//                 //     hintText: "Enter your Location",
//                 //   ),
//                 // ),
//                 SizedBox(
//                   height: 10,
//                 ),
//
//                 Text(
//                   'Profession',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//
//                 Container(
//                   padding: EdgeInsets.only(left: 15, right: 15),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     // border: Border.all(width: 1.5, color: Colors.orange),
//                     // color: Colors.transparent,
//                     color: Color(0xffFFF1E7),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   child: InputDecorator(
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                       ),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         style: GoogleFonts.roboto(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black38),
//                         dropdownColor: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         value: Profession,
//                         isExpanded: true,
//                         icon: const Icon(
//                           Icons.keyboard_arrow_down,
//                           size: 30,
//                           color: Colors.black38,
//                         ),
//                         hint: Text(
//                           "Profession",
//                           style: GoogleFonts.roboto(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.black38),
//                         ),
//                         elevation: 1,
//                         underline: Container(height: 1, color: Colors.black38),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             Profession = newValue!;
//                             _professionController.text = newValue;
//                           });
//                         },
//                         items: profession
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: GoogleFonts.roboto(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//
//
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'About',
//                   style: GoogleFonts.roboto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Color(0xffFFF1E7),
//                    ),
//                    child: TextField(
//                     maxLines: 2,
//                     controller: _aboutController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter the text here',
//                       // label: Text('About'),
//                       hintStyle: TextStyle(color: Colors.black38,fontSize: 12),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.transparent),
//                       ),
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.black38),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.black38),
//                       ),
//                       contentPadding: EdgeInsets.only(
//                           left: 10, right: 10, bottom: 10, top: 10),
//                     ),
//                     keyboardType: TextInputType.text,
//                     onChanged: (value) {
//                       // Handle text changes
//                     },
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 //
//                 // Text(
//                 //   'I want -',
//                 //   style: GoogleFonts.roboto(
//                 //     color: Colors.black,
//                 //     fontWeight: FontWeight.w400,
//                 //     fontSize: 14,
//                 //   ),
//                 // ),
//                 // // SizedBox(
//                 // //   height: 10,
//                 // // ),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 //
//                 // Container(
//                 //   height: 55,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     border: Border.all(width: 1, color: Colors.orange),
//                 //   ),
//                 //   child: Center(
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //       children: [
//                 //         Row(
//                 //           children: [
//                 //             Image.asset('assets/images/icon.png'),
//                 //             Text(
//                 //               'Personal Help',
//                 //               style: TextStyle(
//                 //                 fontSize: 17,
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //         Center(
//                 //           child: Switch(
//                 //             value: isSwitched,
//                 //             onChanged: (value) {
//                 //               setState(() {
//                 //                 isSwitched = value;
//                 //               });
//                 //             },
//                 //             activeTrackColor: Colors.lightGreenAccent,
//                 //             activeColor: Colors.green,
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   height: 20,
//                 // ),
//                 //
//                 // Container(
//                 //   height: 55,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     border: Border.all(width: 1, color: Colors.orange),
//                 //   ),
//                 //   child: Center(
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //       children: [
//                 //         Row(
//                 //           children: [
//                 //             Image.asset('assets/images/icon.png'),
//                 //             Text(
//                 //               'Legal Help',
//                 //               style: TextStyle(
//                 //                 fontSize: 17,
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //         Center(
//                 //           child: Switch(
//                 //             value: isSwitched1,
//                 //             onChanged: (value) {
//                 //               setState(() {
//                 //                 isSwitched1 = value;
//                 //               });
//                 //             },
//                 //             activeTrackColor: Colors.lightGreenAccent,
//                 //             activeColor: Colors.green,
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//                 //
//                 // SizedBox(
//                 //   height: 20,
//                 // ),
//                 //
//                 // Container(
//                 //   height: 55,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     border: Border.all(width: 1, color: Colors.orange),
//                 //   ),
//                 //   child: Center(
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //       children: [
//                 //         Row(
//                 //           children: [
//                 //             Image.asset('assets/images/icon.png'),
//                 //             Text(
//                 //               'Community Help',
//                 //               style: TextStyle(
//                 //                 fontSize: 17,
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //         Center(
//                 //           child: Switch(
//                 //             value: isSwitched2,
//                 //             onChanged: (value) {
//                 //               setState(() {
//                 //                 isSwitched2 = value;
//                 //               });
//                 //             },
//                 //             activeTrackColor: Colors.lightGreenAccent,
//                 //             activeColor: Colors.green,
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//                 //
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 // Text(
//                 //   "Need Help In:",
//                 //   // textAlign: TextAlign.center,
//                 //   style: GoogleFonts.roboto(
//                 //     color: Colors.black,
//                 //     fontWeight: FontWeight.w400,
//                 //     fontSize: 14,
//                 //   ),
//                 // ),
//                 //
//                 // ChipsChoice<dynamic>.multiple(
//                 //   choiceItems: C2Choice.listFrom<dynamic, dynamic>(
//                 //     source: DepartmentList,
//                 //     value: (index1, item) => DepartmentList[index1]['id'],
//                 //     label: (index1, item) =>
//                 //         DepartmentList[index1]['filterValue'],
//                 //   ),
//                 //   value: department,
//                 //   onChanged: (val) => setState(() => department = val),
//                 //   choiceCheckmark: true,
//                 //   choiceStyle: C2ChipStyle.outlined(
//                 //     color: Color(0xFFA2A09D),
//                 //     checkmarkColor: Colors.white,
//                 //     foregroundStyle:
//                 //         const TextStyle(color: Color(0xFF2F2924), fontSize: 14),
//                 //     selectedStyle: C2ChipStyle.filled(
//                 //       foregroundStyle:
//                 //           TextStyle(color: Colors.white, fontSize: 14),
//                 //       color: Color(0xff655D53),
//                 //       borderRadius: BorderRadius.all(
//                 //         Radius.circular(10),
//                 //       ),
//                 //     ),
//                 //   ),
//                 //   wrapped: true,
//                 // ),
//               ],
//              ),
//             ),
//
//           // Text('Need help In'),
//
//           // Padding(
//           //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//           //   child: Container(
//           //     height: 55,
//           //     width: MediaQuery.of(context).size.width,
//           //     decoration: BoxDecoration(
//           //       borderRadius: BorderRadius.circular(10),
//           //       border: Border.all(width: 1, color: Color(0xffEC7224)),
//           //     ),
//           //     child: Center(
//           //       child: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Row(
//           //             children: [
//           //               Padding(
//           //                 padding: const EdgeInsets.only(left: 10, right: 15),
//           //                 child: Icon(Icons.logout, color: Color(0xffEC7224)),
//           //               ),
//           //               Text(
//           //                 'Pan Card',
//           //                 style:
//           //                     TextStyle(fontSize: 16, color: Color(0xffEC7224)),
//           //               ),
//           //             ],
//           //           ),
//           //           Center(
//           //             child: Switch(
//           //               value: isSwitched,
//           //               onChanged: (value) {
//           //                 setState(() {
//           //                   isSwitched = value;
//           //                 });
//           //               },
//           //               // paintBorder()
//           //               // inactiveTrackColor: Colors.orange,
//           //               activeTrackColor: Colors.orange,
//           //               activeColor: Colors.orange.shade50,
//           //               inactiveThumbColor: Colors.orange,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           //
//           // Padding(
//           //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//           //   child: Container(
//           //     height: 55,
//           //     width: MediaQuery.of(context).size.width,
//           //     decoration: BoxDecoration(
//           //       borderRadius: BorderRadius.circular(12),
//           //       border: Border.all(width: 1, color: Color(0xffEC7224)),
//           //     ),
//           //     child: Center(
//           //       child: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Row(
//           //             children: [
//           //               Padding(
//           //                 padding: const EdgeInsets.only(left: 10, right: 15),
//           //                 child: Icon(Icons.logout, color: Color(0xffEC7224)),
//           //               ),
//           //               Text(
//           //                 'Aadhaar Card',
//           //                 style:
//           //                     TextStyle(fontSize: 16, color: Color(0xffEC7224)),
//           //               ),
//           //             ],
//           //           ),
//           //           Center(
//           //             child: Switch(
//           //               value: isSwitched1,
//           //               onChanged: (value) {
//           //                 setState(() {
//           //                   isSwitched1 = value;
//           //                 });
//           //               },
//           //               inactiveThumbColor: Colors.orange,
//           //               activeTrackColor: Colors.orange,
//           //               activeColor: Colors.orange.shade50,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           //
//           // Padding(
//           //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//           //   child: Container(
//           //     height: 55,
//           //     width: MediaQuery.of(context).size.width,
//           //     decoration: BoxDecoration(
//           //       borderRadius: BorderRadius.circular(12),
//           //       border: Border.all(width: 1, color: Color(0xffEC7224)),
//           //     ),
//           //     child: Center(
//           //       child: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Row(
//           //             children: [
//           //               Padding(
//           //                 padding: const EdgeInsets.only(left: 10, right: 15),
//           //                 child: Icon(Icons.logout, color: Color(0xffEC7224)),
//           //               ),
//           //
//           //               // Image.asset('assets/images/icon.png',color: Color(0xffEC7224)),
//           //               Text(
//           //                 'RC',
//           //                 style:
//           //                     TextStyle(fontSize: 16, color: Color(0xffEC7224)),
//           //               ),
//           //             ],
//           //           ),
//           //           Center(
//           //             child: Switch(
//           //               value: isSwitched2,
//           //               onChanged: (value) {
//           //                 setState(() {
//           //                   isSwitched2 = value;
//           //                 });
//           //               },
//           //               activeTrackColor: Colors.orange,
//           //               activeColor: Colors.orange.shade50,
//           //               inactiveThumbColor: Colors.orange,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           InkWell(
//             onTap: () {
//               Navigator.pop(context);
//
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(
//                   right: 40, left: 40, top: 20, bottom: 10),
//               child: Card(
//                 elevation: 2,
//                 child: Container(
//                   height: 45,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Color(0xffFBCD96)),
//                   child: Center(
//                     child: Text(
//                       'SAVE',
//                       style: TextStyle(
//                           color: Colors.orange,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16),
//                        ),
//                       ),
//                     ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 40,
//           ),
//         ]),
//       ),
//     );
//   }
//
//   _getFromGallery() async {
//     XFile? pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       File? img = File(pickedFile.path);
//       setState(() {
//         imageFile = img;
//       });
//     }
//   }
//
//   _getFromCamera() async {
//     XFile? pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.camera,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       File? img = File(pickedFile.path);
//       setState(() {
//         imageFile = img;
//       });
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:madadguru/Allwidgets/background_screen.dart';
import 'package:madadguru/Allwidgets/textForm_filed.dart';
import 'package:madadguru/Pages/LanguagePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final String device;
  EditProfile({
    super.key,
    required this.device,
  });
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobilController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  bool isSignningIn = false;
  bool isActivate = false;
  bool isActivate1 = true;
  File? imageFile;
  var Gender;
  var Profession;
  var profession = [
    'Private',
    'Gort Job',
    'Business',
    'Student',
    'House Wife',
    'Un-Employed',
    'NGO Worker',
    'Other',
  ];

  var gender = ["Male", "Female", "Other"];
  Map<String, dynamic> data = {};

  Future<void> ApiProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
      final Uri uri =
        Uri.parse("https://madadguru.webkype.net/api/updateProfile");
    var request = http.MultipartRequest('Post', uri);
    Map<String, String> headers = {
      "Accept": "multipart/form-data",
      "Authorization": 'Bearer $usertoken',
    };
    request.headers.addAll(headers);
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('profile', imageFile!.path));
    }

    request.fields['about'] = _aboutController.text;
    request.fields['gender'] = _genderController.text;
    request.fields['name'] = _nameController.text;

    request.fields['dob'] = _dobController.text;
    request.fields['email'] = _emailController.text;

    request.fields['profession'] = _professionController.text;
    request.fields['language'] = "";
    request.fields['i_want'] = "";
    request.fields['need_help_in'] = "";
    // try{
    //
    // }
// "userotp": widget.userotp,
//         "mobile": widget.mobile,
//         "about": _aboutController.text.toString(),
//         "gender": _genderController.text.toString(),
//         "name": _nameController.text.toString(),
//         "dob": _dobController.text.toString(),
//         "email": _emailController.text.toString(),
//         "profession": _professionController.text.toString(),
//         "language": "",
//         "i_want": "",
//         "need_help_in": "",
//         "profile": "",
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          data = responseData;
        });
        print(responseData);

        // responseData.forEach((key, value) {
        //   print('$key: $value');
        // });
        Navigator.pop(context);
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => LanguageScreen(
        //         device: widget.device,
        //       ),
        //     ),
        //     (route) => false);
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making HTTP request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              topLeft: Radius.circular(25),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext bc) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await _getFromCamera();
                                          },
                                          child: Row(children: [
                                            Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.blue,
                                            ),
                                            // Image.asset(
                                            //   "assets/icons/photo-camera-interface-symbol-for-button.png",
                                            //   width: 25,
                                            //   color: Colors.black54,
                                            // ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Take Photo",
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await _getFromGallery();
                                          },
                                          child: Row(children: [
                                            Image.asset(
                                              "assets/images/gallery.png",
                                              width: 25,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Select from gallery",
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ]),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ]),
                                ),
                              );
                            });
                          });
                    },
                    child: Stack(clipBehavior: Clip.none, children: [
                      (imageFile == null)
                          ? CircleAvatar(
                              radius: 45,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/people.webp',
                                  fit: BoxFit.cover,
                                  width: 90.0, // adjust width as needed
                                  height: 90.0, // adjust height as needed
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 45,
                              child: ClipOval(
                                child: Image.file(
                                  imageFile!,
                                  // 'assets/images/people.webp',
                                  fit: BoxFit.cover,
                                  width: 90.0, // adjust width as needed
                                  height: 90.0, // adjust height as needed
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 10,
                        right: -5,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xffFF9228).withOpacity(0.7),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            // width: 16,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFEADD),
                  ),
                  child: TextFormFieldWidget1(
                    cursorColor: Color(0xffFF9228),
                    controller: _nameController,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    obscureText: false,
                    hintText: "Enter Name",
                    // labeltext: 'Enter your old password',
                  ),
                ),


                SizedBox(
                  height: 10,
                ),

                Text(
                  "Mobile",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFEADD),
                  ),
                  child: TextFormFieldWidget1(
                    cursorColor: Color(0xffFF9228),
                    controller: _mobilController,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    obscureText: false,
                    hintText: "Enter Mobile",
                    // labeltext: 'Enter your old password',
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFEADD),
                  ),
                  child: TextFormFieldWidget1(
                    cursorColor: Color(0xffFF9228),
                    controller: _emailController,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    obscureText: false,
                    hintText: "Enter Email",
                    // labeltext: 'Enter your old password',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Gender",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // border: Border.all(width: 1.5, color: Colors.orange),
                    color: Color(0xffFFEADD),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.orange),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        value: Gender,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                          color: Colors.black38,
                        ),
                        hint: Text(
                          "Gender",
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black38),
                        ),
                        elevation: 1,
                        underline: Container(height: 1, color: Colors.orange),
                        onChanged: (String? newValue) {
                          setState(() {
                            Gender = newValue!;
                            _genderController.text = newValue;
                          });
                        },
                        items: gender
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Text(
                  "Date Of Birth",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffFFEADD),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    readOnly: true,
                    cursorColor: Color(0xffFF9228),
                    obscureText: false,
                    controller: _dobController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));
                          setState(() {
                            _dobController.text = DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(pickedDate.toString()))
                                .toString();
                          });
                        },
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.black38,
                          size: 23,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1.5, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1.5, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      hintText: "Date Of Birth",
                      hintStyle: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black38),
                    ),
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Profession",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // border: Border.all(width: 1.5, color: Colors.orange),
                    color: Color(0xffFFEADD),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.orange),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        value: Profession,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                          color: Colors.black38,
                        ),
                        hint: Text(
                          "Profession",
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black38),
                        ),
                        elevation: 1,
                        underline: Container(height: 1, color: Colors.orange),
                        onChanged: (String? newValue) {
                          setState(() {
                            Profession = newValue!;
                            _professionController.text = newValue;
                          });
                        },
                        items: profession
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Text(
                  "About",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffFFEADD),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    style: TextStyle(fontSize: 12),
                    maxLines: 3,
                    controller: _aboutController,
                    decoration: InputDecoration(
                      hintText: 'Enter the text here',hintStyle: TextStyle(fontSize: 12,color: Colors.black38),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      // Handle text changes
                    },
                  ),
                ),

                SizedBox(
                  height: 40,
                ),

                InkWell(
                  onTap: () {
                    ApiProfile();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50.0),
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
                            'Save',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ]),
        ),
      ),
    );
  }

  // _getFromCamera() async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 50,
  //   );
  //   if (pickedFile != null) {
  //     File? img = File(pickedFile.path);
  //     setState(() {
  //       imageFile = img;
  //     });
  //   }
  // }
  //
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      File? img = File(pickedFile.path);
      setState(() {
        imageFile = img;
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      File? img = File(pickedFile.path);
      setState(() {
        imageFile = img;
      });
    }
  }
}

// multipart ke through
//documents Send
// image path
