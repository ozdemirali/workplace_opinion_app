import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

TextEditingController txtWorkplaceName=new TextEditingController();
TextEditingController txtPhone=new TextEditingController();
TextEditingController txtAddress=new TextEditingController();
TextEditingController txtAuthorizedPerson=new TextEditingController();
TextEditingController txtExplanation=new TextEditingController();

String selectType="İlgili";
String selectTeacher;

final FirebaseDatabase _database=FirebaseDatabase.instance;



Widget showToForm(GlobalKey _formKey){
  return Form(
    key:_formKey,
    child:Column(
      children: <Widget>[
        workplaceName(txtWorkplaceName),
        Teacher(),
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

//Get all teacher from Realtime Database in Firebase

class Teacher extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TeacherState();
  }
}

class TeacherState extends State<Teacher>{
  List<String> teacher=new List();
  List<String> test=["Ali","Veli"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print("---name");
    _database
        .reference()
        .child("user").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
          snapshot.value.forEach((value){
            if(value!=null){
              print(value["name"]);
              teacher.add(value["name"].trim()+" "+value["surname"].trim());
            }
          });
    });
  }
  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds: 1),()=>
      teacher.length.toString()
  );

  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<String>(
      future: callAsyncFetch(),
      builder: (context,AsyncSnapshot<String> snapshot){
        if(snapshot.data!="0"){
          print(teacher);
          return DropdownButtonFormField<String>(
            value: selectTeacher,
            items: teacher
                  .map((label)=>DropdownMenuItem(
              child: Text(label),
              value: label,
            )).toList(),
            onChanged: (value){
              setState(() {
                selectTeacher=value;
                print (selectTeacher);
              });
            },
          );
        }else
          {
            return CircularProgressIndicator();
          }
      },
    );
  }
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
  void initState(){
    super.initState();
    //print("---");

  }

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
