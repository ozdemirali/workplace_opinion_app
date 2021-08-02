import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


Widget inputDigital(TextEditingController txtDigital,String hinText,String label,MaskTextInputFormatter maskFormatter){
  return TextFormField(
    controller:txtDigital ,
    textCapitalization: TextCapitalization.words,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      maskFormatter,
    ],
    decoration: InputDecoration(
      hintText: hinText,
      hintStyle: TextStyle(fontSize:12),
      labelText: label,
    ),
    validator: (value){
      if(value.isEmpty){
        return "Bu alan boş bırakılamaz";
      }
      return null;
    },
    textInputAction: TextInputAction.next,
  );
}