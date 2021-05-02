import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workplace_opinion_app/models/workplace.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

TextEditingController txtWorkplaceName=new TextEditingController();
TextEditingController txtPhone=new TextEditingController(text: "12345678");
TextEditingController txtAddress=new TextEditingController();
TextEditingController txtAuthorizedPerson=new TextEditingController();
TextEditingController txtExplanation=new TextEditingController();

var maskFormatter = new MaskTextInputFormatter(mask: '# (###) ### ## ##', filter: { "#": RegExp(r'[0-9]') });


String selectType;
String selectTeacher;
String selectBranch;
String _key;

final FirebaseDatabase _database=FirebaseDatabase.instance;

Widget showToForm(GlobalKey _formKey){
  return Form(
    key:_formKey,
    child:Column(
      children: <Widget>[
        workplaceName(txtWorkplaceName),
        //Teacher(),
        Type(),
        //Branch(),
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
          //print(teacher);
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
           //print(teacher);
            return CircularProgressIndicator();
          }
      },
    );
  }
}



//Get all Type of Workplace
class Type extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TypeState();
  }
}

class TypeState extends State<Type>{
  List<String> type=new List();

  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("type").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
          snapshot.value.forEach((value){
            if(value!=null){
              type.add(value["name"].trim());
            }
          });
    });

  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      type.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              value: selectType,
              items: type
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              )).toList(),
              onChanged: (value){
                setState(() {
                  selectType=value;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}

//Get all branc of Student
class Branch extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BranchState();
  }
}

class BranchState extends State<Branch>{
  List<String> branch=new List();

  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("branch").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
      snapshot.value.forEach((value){
        if(value!=null){
          branch.add(value["name"].trim());
        }
      });
    });

  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      branch.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              value: selectBranch,
              items: branch
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              )).toList(),
              onChanged: (value){
                setState(() {
                  selectBranch=value;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}

addWorkplace(){
  print("add Workplace");
  print("asd");
  Workplace workplace=new Workplace(txtWorkplaceName.text,selectType,txtPhone.text, txtAddress.text, txtAuthorizedPerson.text, txtExplanation.text);
  if(_key==null){
     print("add new data");
    _database.reference().child("workplace").push().set(workplace.toJson());
  }
  else{
    print("update data");
    _database.reference().child("workplace").child(_key).set(workplace.toJson());
  }

}

addNewWorkplace(){
  print(maskFormatter.getUnmaskedText()); // -> 01234567890
  // Workplace workplace=new Workplace(txtWorkplaceName.text,selectType,txtPhone.text, txtAddress.text, txtAuthorizedPerson.text, txtExplanation.text);
  // _database.reference().child("workplace").push().set(workplace.toJson());
}

updateWorkplace(Workplace data){
  // if(data!=null){
  //   _database.reference().child("workplace").child(data.key).set(data.toJson());
  // }
}