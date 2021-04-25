import 'package:flutter/material.dart';

Widget address(TextEditingController txtAddress){
  return TextFormField(
    controller:txtAddress,
    textCapitalization: TextCapitalization.words,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: "Adresi",
    ),
    validator: (value){
      if(value.isEmpty){
        return "Adres boş bırakılmaz";
      }
      return null;
    },
    textInputAction: TextInputAction.next,
  );
}