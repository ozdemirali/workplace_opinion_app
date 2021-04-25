import 'package:flutter/material.dart';

Widget workplaceName(TextEditingController txtWorkplaceName){
  return TextFormField(
    controller: txtWorkplaceName,
    textCapitalization: TextCapitalization.words,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: "İşyerinin Adı",
    ),
    validator: (value){
      if(value.isEmpty){
        return "İş yeri adı boş bırakılmaz";
      }
      return null;
    },
    textInputAction: TextInputAction.next,
  );
}