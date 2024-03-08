import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final Color cursorColor;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool obscureText;
  final String labeltext;
  final String hintText;
  const TextFormFieldWidget({
    super.key,
    required this.cursorColor,
    required this.controller,
    required this.inputType,
    required this.inputAction,
    required this.obscureText,
    required this.labeltext,
    required this.hintText,
    required Function(dynamic value) validator,
  });
  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
        cursorColor: widget.cursorColor,
        obscureText: widget.obscureText,
        controller: widget.controller,
        keyboardType: widget.inputType,
        textInputAction: widget.inputAction,
        validator: widget.labeltext
            == "Name"
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Name';
                }
                return null;
              }
                : widget.labeltext == "Email"
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  }
                : null,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Colors.orange),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Colors.orange),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Colors.orange),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Colors.orange),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          labelText: widget.labeltext,
          labelStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black38),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black38),
        ),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      );
}

class TextFormFieldWidget1 extends StatefulWidget {
  final Color cursorColor;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool obscureText;
  // final String labeltext;
  final String hintText;
  const TextFormFieldWidget1({
    super.key,
    required this.cursorColor,
    required this.controller,
    required this.inputType,
    required this.inputAction,
    required this.obscureText,
    // required this.labeltext,
    required this.hintText,
  });

  @override
  State<TextFormFieldWidget1> createState() => _TextFormFieldWidget1State();
}

class _TextFormFieldWidget1State extends State<TextFormFieldWidget1> {
  @override
  Widget build(BuildContext context) => TextField(
        cursorColor: widget.cursorColor,
        obscureText: widget.obscureText,
        controller: widget.controller,
        keyboardType: widget.inputType,
        textInputAction: widget.inputAction,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.5,
              color: Color(0xffFFF1E7),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Colors.black45),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // labelText: widget.labeltext,
          labelStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black45),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black45),
        ),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      );
}

class TextFormFieldWidget2 extends StatefulWidget {
  final Color cursorColor;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool obscureText;
  final int maxLines;
  final String labeltext;
  final String hintText;
  const TextFormFieldWidget2({
    super.key,
    required this.cursorColor,
    required this.controller,
    required this.inputType,
    required this.inputAction,
    required this.obscureText,
    required this.labeltext,
    required this.hintText,
    required this.maxLines,
  });

  @override
  _TextFormFieldWidget2State createState() => _TextFormFieldWidget2State();
}

class _TextFormFieldWidget2State extends State<TextFormFieldWidget2> {
  @override
  Widget build(BuildContext context) => TextField(
        cursorColor: widget.cursorColor,
        obscureText: widget.obscureText,
        controller: widget.controller,
        keyboardType: widget.inputType,
        textInputAction: widget.inputAction,
// maxLines: widget.inputLines,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Colors.orange),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          labelText: widget.labeltext,
          labelStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black45),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black45),
        ),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      );
}
