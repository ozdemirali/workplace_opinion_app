import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workplace_opinion_app/models/data.dart';
import 'package:workplace_opinion_app/models/user.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';
import 'package:workplace_opinion_app/widgets/inputDigital.dart';
import 'package:workplace_opinion_app/widgets/inputText.dart';

final _formKey = GlobalKey<FormState>();
final FirebaseDatabase _database=FirebaseDatabase.instance;

TextEditingController txtStudentName=new TextEditingController();
TextEditingController txtStudentPhone=new TextEditingController();
TextEditingController txtExplanation=new TextEditingController();

var maskFormatter = new MaskTextInputFormatter(mask: '# (###) ### ## ##', filter: { "#": RegExp(r'[0-9]') });

String selectWorkplace;
String selectWorkplaceName;
String selectWorkplaceType;
String selectTeacher;
String selectBranch;
String selectType;

Widget studentToWorkplace(){
  return Form(
    key:_formKey,
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Workplace(),
        Teacher(),
        inputText(txtStudentName,"Öğrenin Adı"),
        Branch(),
        inputDigital(txtStudentPhone, "0 (999) 999 99 99", "Öğrencinin Telefonu", maskFormatter),
        inputText(txtExplanation,"Açıklama"),
        saveButton(),
      ],
    ) ,
  );
}

class Workplace extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WorkplaceState();
  }
}

class WorkplaceState extends State<Workplace>{
  List<Data> workplace=new List();


  @override
  void initState(){
    super.initState();
     _database
        .reference()
        .child("workplace")
        .once()
         .then((DataSnapshot snapshot){
           Map<dynamic, dynamic> values=snapshot.value;
           values.forEach((k,v) {
             workplace.add(Data(k,v["name"],v["type"]));

           });
     });
  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      workplace.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //print("Widget ");
    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            //print(data);
            return DropdownButtonFormField<String>(
              hint: Text("İş Yeri Seçiniz"),
              value: selectWorkplace,
              items: workplace
                  .map((label) => DropdownMenuItem(
                child: Text(label.name),
                value: label.key,
              )).toList(),
              onChanged: (value){
                setState(() {
                  selectWorkplace=value;
                  print(value);
                  workplace.forEach((f){
                    if(f.key==value){
                       print(f.name);
                       print(f.type);
                      selectWorkplaceName=f.name;
                      selectWorkplaceType=f.type;

                    }
                  });
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
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
  List<String> type=new List();

  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("type").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
          print(snapshot);
      snapshot.value.forEach((value){

        if(value!=null){
          print(value);
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
    //print("Widget ");
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
          //print(value["name"]);
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
            hint: Text("Öğretmen Ata"),
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
              hint: Text("Dalını seçiniz"),
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


Widget saveButton(){
  return FlatButton(
    color: Colors.teal,
    child: Text("Kaydet",
        style:new TextStyle(color: Colors.white)),
    onPressed: (){
      if(_formKey.currentState.validate()){
          _database.reference().child("user_workplace").push().set(UserWorkplace(selectWorkplace, selectWorkplaceName,selectWorkplaceType, "year", txtStudentName.text, selectBranch, txtStudentPhone.text,User("dasd",selectTeacher)).toJson());
        //addWorkplace();
        //Navigator.pop(context);
        _formKey.currentState.reset();
      }
    },
  );

}