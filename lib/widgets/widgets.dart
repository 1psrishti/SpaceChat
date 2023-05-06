import 'package:flutter/material.dart';
import 'package:space_chat/shared/constants.dart';

InputDecoration textInputDecoration = InputDecoration(
  labelStyle: const TextStyle(color: Color(0xff737373), fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().primaryColor, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().primaryColor, width: 2),
  ),
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
);

void nextScreen(context, page){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: const TextStyle(fontSize: 14)),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
  ));
}