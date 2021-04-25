import 'package:flutter/material.dart';

Widget explanation(TextEditingController txtExplanation){
  return TextFormField(
    controller:txtExplanation ,
    textCapitalization: TextCapitalization.words,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: "Açıklama",
    ),
    // validator: (value){
    //   if(value.isEmpty){
    //     return "Yetkili Kişi alanı boş bırakılmaz";
    //   }
    //   return null;
    // },
    textInputAction: TextInputAction.next,
  );
}