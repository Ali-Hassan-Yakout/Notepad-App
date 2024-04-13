import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void displayToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_LONG,
    textColor: Colors.white,
  );
}