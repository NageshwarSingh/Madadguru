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
    bool isLoading = false;
      void LoginApi() async {
       setState(() {
       isLoading = true;
         });
         try {
         var res = await http.post(
          Uri.parse("https://madadguru.webkype.net/api/userLogin"),
          body: {
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
        _showToast(context, 'Otp verification Success: 1234');
        } else {
        _showToast(context, 'Invalid OTP: 1234');
        }
        } catch (e) {
        print('Error occurred: $e');
        _showToast(context, 'Error occurred: $e');
        } finally {
        setState(() {
        isLoading = false;
      });
    }
     }
    void _showToast(BuildContext context, String message) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
         backgroundColor: Colors.black,
        content: Text(message),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
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
          SafeArea(
            child: isLoading
                 ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
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
                                 padding: EdgeInsets.only(
                                     left: 15, right: 15, bottom: 10),
                                child: TextFormField(
                                controller: _mobileController,
                                 onChanged: (value) {
                                  _checkButtonEnabled();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter username';
                                  } else if (value.length < 10) {
                                    return 'Mobile number must be at least 10 digits';
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
                                    borderSide:
                                        BorderSide(color: Colors.orange),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.orange),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .red),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.orange),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.orange),
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
                                  const SizedBox(
                                  height: 20,
                                  ),
                                  InkWell(
                                  onTap: _isButtonEnabled
                                  ? () {
                                    if (_formKey.currentState!.validate()) {
                                      LoginApi();
                                    }
                                  }
                                  : null,
                                  child: Padding(
                                  padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 20.0),
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
                        ],
                      ),
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
  bool isLoading = false;
  void OtpApi() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await http.post(
          Uri.parse("https://madadguru.webkype.net/api/userLogin"),
          body: {
            "mobile": widget.mobile,
            "userotp": _pinController.text.toString(),
          });
      if (res.statusCode == 200) {
        print('Response: ${res.body}');
        var Data = jsonDecode(res.body);
        if (Data['status'] == 200 && Data['success'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", Data['data']['token']);
          await prefs.setBool("isLoggedIn", true);
          await prefs.setString(
            "userId",
            Data["data"]["id"].toString(),
          );
          if (Data['data']['is_profile_comp'] == "1") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BottomNavBar(
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
             print('OTP verification Success: ${Data['message']}');
             _showToast(context, 'OTP verification Success: ${Data['message']}',
              Colors.blue);
              } else {
          print('OTP verification failed');
          _showToast(context, 'OTP verification failed', Colors.red);
        }
      } else {
        print('API request failed with status code: ${res.statusCode}');
        _showToast(
            context,
            'API request failed with status code: ${res.statusCode}',
            Colors.blue);
      }
    } catch (e) {
      print('Error occurred: $e');
      _showToast(context, 'Error occurred: $e', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showToast(BuildContext context, String message, MaterialColor red) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(message),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
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
          SafeArea(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
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
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                              right: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Phone number- ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "${widget.mobile}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
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
                               padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 20.0),
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
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
