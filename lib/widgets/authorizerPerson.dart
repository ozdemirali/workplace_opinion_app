import 'package:flutter/material.dart';

Widget authorizedPerson(TextEditingController txtAuthorizedPerson){
  return TextFormField(
    controller:txtAuthorizedPerson ,
    textCapitalization: TextCapitalization.words,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: "Yetkili Kişi",
    ),
    validator: (value){
      if(value.isEmpty){
        return "Yetkili Kişi alanı boş bırakılmaz";
      }
      return null;
    },
    textInputAction: TextInputAction.next,
  );
}