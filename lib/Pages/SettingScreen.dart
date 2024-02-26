import 'package:flutter/material.dart';
import '../Allwidgets/background_screen.dart';
import '../Allwidgets/textForm_filed.dart';

import 'Login.dart';


class UpdatePassword extends StatefulWidget {
  final String device;
  const UpdatePassword({
    super.key,
    required this.device,
  });

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          const Background(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    // InkWell(
                    //   onTap: () {
                    //     // Navigate to the second page
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => BottomNavBar(
                    //             device: widget.device,
                    //           )),
                    //       // BottomNavBar
                    //     );
                    //   },
                    //   child: Icon(Icons.arrow_back_ios_new_outlined,
                    //       color: Colors.black),
                    // ),
                    SizedBox(height: 60),
                    Text(
                      "Upload Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 70),
                    Text(
                      'Old Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
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
                        controller: newPasswordController,
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        obscureText: false,
                        hintText: "old password",
                        // labeltext: 'Enter your old password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      'New Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
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
                        controller: newPasswordController,
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        obscureText: false,
                        hintText: "new password",
                        // labeltext: 'Enter your new password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
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
                        controller: newPasswordController,
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        obscureText: false,
                        hintText: "Confirm password",
                        // labeltext: 'Enter your Confirm password',
                      ),
                    ),

                    // SizedBox(height: 20,),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Padding(
                    //
                    //     padding: EdgeInsets.only(left: 15,right: 15, bottom: 10),
                    //     child: TextField(
                    //
                    //       controller: _textEditingController,
                    //       decoration: InputDecoration(suffixIcon:Icon( Icons.call),
                    //           suffixIconColor: Colors.green.shade200,
                    //           label: Text('Mobile'),
                    //           labelStyle: TextStyle(color: Colors.orange),
                    //           enabledBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //             borderSide: BorderSide(color: Colors.orange),
                    //           ),
                    //           disabledBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //             borderSide: BorderSide(color: Colors.orange),
                    //           ),
                    //           focusedBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //             borderSide: BorderSide(color: Colors.orange),
                    //           ),
                    //           contentPadding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5)
                    //
                    //       ),
                    //       // contentPadding: EdgeInsets.symmetric(vertical: 10),
                    //       keyboardType: TextInputType.text,
                    //       onChanged: (value) {
                    //         // Handle text changes
                    //       },
                    //     ),
                    //   ),
                    // ),

                    SizedBox(
                      height: 120,
                    ),

                    InkWell(
                      // onWillPop:(){
                      //   Navigator.pop(
                      //           context
                      //   );return false;
                      // },
                      onTap: () {
                        // Navigate to the second page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login(
                                    device: widget.device,
                                  ),
                          ),
                          // BottomNavBar
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 80, left: 80),
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
                                'UPDATE',
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
                  ]),
            ),
            // Positioned(
            //   left: 0,
            //   top: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Image.asset(
            //         "assets/images/rectangle3.png",
            //         width: 180,
            //       ),
            //     ],
            //   ),
            // ),
            //
            //
            // Positioned(
            //   right: 0,
            //   bottom: 0,
            //   child: Image.asset(
            //     "assets/images/rectangle1.png",
            //     width: 180,
            //   ),
            // ),
          )
        ],
      ),
    );
  }
}
