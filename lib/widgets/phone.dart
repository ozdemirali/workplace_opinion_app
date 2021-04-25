import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/widgets/showToForm.dart';

Widget phone(TextEditingController txtPhone){
  return TextFormField(
    controller:txtPhone ,
    textCapitalization: TextCapitalization.words,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      maskFormatter,
    ],
    decoration: InputDecoration(
      hintText: "0 (999) 999 99 99",
      hintStyle: TextStyle(fontSize:12),
      labelText: "Telefon",
    ),
    validator: (value){
      if(value.isEmpty){
        return "Telefon boş bırakılmaz";
      }
      return null;
    },
    textInputAction: TextInputAction.next,
  );
}