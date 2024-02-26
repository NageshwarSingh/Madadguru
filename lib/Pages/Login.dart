import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Allwidgets/BottomNavBar.dart';
import '../Allwidgets/background_screen.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  final String device;
  const Login({
    super.key,
    required this.device,
  });
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  void LoginApi() async {
    var res = await http
        .post(Uri.parse("https://madadguru.webkype.net/api/userLogin"), body: {
      "mobile": _mobileController.text.toString(),
      "userotp": "",
    });
    if (res.statusCode == 200) {
      print('response${res.body}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => otpScreen(
            device: widget.device,
            mobile: _mobileController.text.toString(),
          ),
        ),
      );
      var jsonData = jsonDecode(res.body);
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _checkButtonEnabled() {
    setState(() {
      _isButtonEnabled = _mobileController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 250),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Text(
                      "Verify Me",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: TextFormField(
                        controller: _mobileController,
                        onChanged: (value) {
                          _checkButtonEnabled();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.call),
                          suffixIconColor: Colors.green.shade200,
                          label: Text('Mobile'),
                          labelStyle: TextStyle(color: Colors.black38),
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
                              left: 10, right: 10, bottom: 5, top: 5),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[0-9]*$'),
                          ), // Allows only numeric input
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: _isButtonEnabled
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              LoginApi();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => otpScreen(
                              //       device: widget.device,
                              //       mobile: _mobileController.text.toString(),
                              //     ),
                              //   ),
                              // );
                            }
                          }
                        : null,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 50, right: 50, top: 20.0),
                      child: Card(
                        elevation: 2,
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xffFFEADD)),
                          child: Center(
                            child: Text(
                              'Send OTP',
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

                  // Positioned.fill(child: Background()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class otpScreen extends StatefulWidget {
  final String device;
  final String mobile;
  const otpScreen({
    super.key,
    required this.device,
    required this.mobile,
  });

  @override
  State<otpScreen> createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  void OtpApi() async {
    var res = await http
        .post(Uri.parse("https://madadguru.webkype.net/api/userLogin"), body: {
      "mobile": widget.mobile, // Add this line to include the mobile number
      "userotp": _pinController.text.toString(),
    });
    if (res.statusCode == 200) {
      print('Response: ${res.body}');
      var Data = jsonDecode(res.body);
      if (Data['status'] == 200 && Data['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          "token",
          Data['data']['token'],
        );
        await prefs.setBool("isLoggedIn", true);
        await prefs.setString("userId", Data["data"]["id"].toString());
        // await prefs.setString("userOtp", _pinController.text.toString());
        if (Data['data']['is_profile_comp'] == "1") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MySplashScreen(
                device: widget.device,
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignUpScreen(
                device: widget.device,
                mobile: widget.mobile,
                userid: Data["data"]["id"].toString(),
                userotp: _pinController.text.toString(),
              ),
            ),
          );
        }
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => SignUpScreen(
        //         device: widget.device,
        //         mobile: widget.mobile,
        //         userid: Data["data"]["id"].toString(),
        //         userotp: _pinController.text.toString(),
        //       ),
        //     ),
        //     (route) => false);
        print('OTP verification Success: ${Data['message']}');
      } else {
        print('OTP verification failed');
      }
    } else {
      print('API request failed with status code: ${res.statusCode}');
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _checkButtonEnabled() {
    setState(() {
      _isButtonEnabled = _pinController.text.isNotEmpty;
    });
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  late PinTheme focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: Colors.orange, width: 1),
    borderRadius: BorderRadius.circular(8),
  );

  late PinTheme submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: Color.fromRGBO(234, 239, 246, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 250),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Text(
                      "OTP Verification",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Pinput(
                        length: 4,
                        keyboardType: TextInputType.number,
                        controller: _pinController,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        onChanged: (value) {
                          _checkButtonEnabled();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        showCursor: true,
                        onCompleted: null,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: _isButtonEnabled
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              OtpApi();

                              // Navigator.of(
                              //   context,
                              //
                              //     MaterialPageRoute(
                              //       builder: (context) => SignUpScreen(
                              //       device: widget.device,
                              //       mobile:widget.mobile,
                              //       userotp: _pinController.text.toString(),
                              //     ),
                              //   ),
                              // );
                            }
                          }
                        : null,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 50, right: 50, top: 20.0),
                      child: Card(
                        elevation: 2,
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xffFFEADD)),
                          child: Center(
                            child: Text(
                              'Verify',
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

                  // Positioned.fill(child: Background()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
