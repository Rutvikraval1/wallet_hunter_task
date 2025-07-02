
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlutterToastMes {
  void errorMessage(String Message,{String error_color='' }) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: error_color==''?Colors.red:Colors.green,
        textColor: Colors.white,
        webBgColor: "#505050",
        webPosition: "center",
        webShowClose: false,
        fontSize: 16.0);
  }
}
