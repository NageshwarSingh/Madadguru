// import 'package:flutter/material.dart';
// class UpdatePassword extends StatefulWidget {
//   final String device;
//   const UpdatePassword({super.key, required this.device});
//
//   @override
//   State<UpdatePassword> createState() => _UpdatePasswordState();
// }
//
// class _UpdatePasswordState extends State<UpdatePassword> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madadguru/Allwidgets/textForm_filed.dart';
import 'background_screen.dart';
import 'buttons.dart';
class UpdatePassword extends StatefulWidget {
  final String device;
  const UpdatePassword({super.key, required this.device});
  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}
class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        const Background(),
        SingleChildScrollView(
          padding:
          const EdgeInsets.only(top: 200, left: 15, right: 15, bottom: 15),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Update Password",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Colors.black,
                )),
            const SizedBox(
              height: 40,
            ),
            TextFormFieldWidget(
              cursorColor: Color(0xffFF9228),
              controller: phoneController,
              inputType: TextInputType.visiblePassword,
              inputAction: TextInputAction.next,
              obscureText: false,
              labeltext: "Old Password",
              hintText: "**********",
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            ),
            const SizedBox(
              height: 20,
            ),
              TextFormFieldWidget(
              cursorColor: Color(0xffFF9228),
              controller: phoneController,
              inputType: TextInputType.visiblePassword,
              inputAction: TextInputAction.next,
              obscureText: false,
              labeltext: "New Password",
              hintText: "**********", validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormFieldWidget(
              cursorColor: Color(0xffFF9228),
              controller: phoneController,
              inputType: TextInputType.visiblePassword,
              inputAction: TextInputAction.done,
              obscureText: false,
              labeltext: "Confirm Password",
              hintText: "**********", validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {},
              child: ButtonWidget(
                text: "LogIn",
                color: const Color(0xffFBCD96),
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
        Positioned(
            top: 60,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ))
      ]),
    );
  }
}
