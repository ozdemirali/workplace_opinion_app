
import 'package:flutter/material.dart';

showToAlert(BuildContext context,String error){
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Tamam"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Uyarı"),
    content: Text(error),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}