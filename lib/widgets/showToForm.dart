
import 'package:flutter/material.dart';

TextEditingController txtWorkplaceName=new TextEditingController();
TextEditingController txtPhone=new TextEditingController();
TextEditingController txtAddress=new TextEditingController();
TextEditingController txtAuthorizedPerson=new TextEditingController();
TextEditingController txtExplanation=new TextEditingController();

String selectType="İlgili";




Widget showToForm(GlobalKey _formKey){
  return Form(
    key:_formKey,
    child:Column(
      children: <Widget>[
        workplaceName(txtWorkplaceName),
        Type(),
        phone(txtPhone),
        address(txtAddress),
        authorizedPerson(txtAuthorizedPerson),
        explanation(txtExplanation),

      ],
    ) ,
  );
}

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

Widget phone(TextEditingController txtPhone){
  return TextFormField(
    controller:txtPhone ,
    textCapitalization: TextCapitalization.words,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: "Telefonu",
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

class Type extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TypeState();
  }
}

class TypeState extends State<Type>{
  List<String> type=["İlgili","İlgisiz"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButtonFormField<String>(
      value: selectType,
      items: type.map((label)=>DropdownMenuItem(
        child: Text(label),
        value: label,
      )).toList(),
      onChanged: (value){
        setState(() {
          selectType=value;
          print(selectType);
        });
      },
    );
  }

}
