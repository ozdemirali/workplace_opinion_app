
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
  //String selectTeacherUid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print("---name");
    widget.database
          .reference()
          .child("user").orderByKey()
          .once()
          .then((DataSnapshot snapshot){
      snapshot.value.forEach((value){
        if(value!=null){
          //print(value["name"]);
          teacher.add(User(value["uid"], value["name"].trim()+" "+value["surname"].trim()));
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
            value: widget.teacherUid.text,
            items: teacher
                .map((label)=>DropdownMenuItem(
              child: Text(label.name),
              value: label.uid,
            )).toList(),
            onChanged: (value){
              setState(() {
                teacher.forEach((f){
                  if(f.uid==value){
                    widget.teacherUid.text=f.uid;
                    widget.teacherName.text=f.name;
                    // selectTeacherUid=f.uid;
                    // selectTeacherName=f.name;
                  }
                  //print(selectTeacherUid);
                  //print(selectTeacherName);

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