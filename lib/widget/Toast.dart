import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Taoast {
  toast(String text){
   return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}