
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/models/user.dart';


// ignore: must_be_immutable
class Teacher extends StatefulWidget{
  Teacher({this.database,this.teacherUid,this.teacherName});

  TextEditingController teacherUid;
  TextEditingController teacherName;
  FirebaseDatabase database;

  @override
  State<StatefulWidget> createState() {
    return TeacherState();
  }
}

class TeacherState extends State<Teacher>{
  List<User> teacher=new List();
  String _selectValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        if(widget.teacherUid.text!=""){
          _selectValue=widget.teacherUid.text;
        }

    widget.database
          .reference()
          .child("user").orderByKey()
          .once()
          .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      values.forEach((k,v) {
        teacher.add(User(k,v["name"].trim()+" "+v["surname"].trim()));
      });
      // snapshot.value.forEach((value){
      //   if(value!=null){
      //     teacher.add(User(value["uid"], value["name"].trim()+" "+value["surname"].trim()));
      //   }
      // });
    });
  }
  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds: 1),()=>
      teacher.length.toString()
  );


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: callAsyncFetch(),
      builder: (context,AsyncSnapshot<String> snapshot){
        if(snapshot.data!="0"){
          return DropdownButtonFormField<String>(
            hint: Text("Öğretmen Ata"),
            value: _selectValue,
            items: teacher
                .map((label)=>DropdownMenuItem(
              child: Text(label.name),
              value: label.uid,
            )).toList(),
            onChanged: (value){
              setState(() {
                _selectValue=value;
                teacher.forEach((f){
                  if(f.uid==value){
                    widget.teacherUid.text=f.uid;
                    widget.teacherName.text=f.name;
                  }

                });
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