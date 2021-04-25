import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

Widget inputText(TextEditingController inputText,String label){
  return TextFormField(
    controller: inputText,
    textCapitalization: TextCapitalization.words,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: label,
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