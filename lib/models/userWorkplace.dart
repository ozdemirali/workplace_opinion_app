import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:workplace_opinion_app/models/user.dart';

class UserWorkplace{
  String key;
  String workplace;
  String name;
  String year;
  String student;
  String branch;
  String studentPhone;
  User user;

  UserWorkplace(this.workplace,this.name,this.year,this.student,this.branch,this.studentPhone,this.user);

  UserWorkplace.fromSnapshot(DataSnapshot snapshot) :
        key=snapshot.key,
        workplace=snapshot.value["workplace"],
        name=snapshot.value["name"],
        year=snapshot.value["year"],
        student=snapshot.value["student"],
        branch=snapshot.value["branch"],
        studentPhone=snapshot.value["studentPhone"],
        user= User(snapshot.value["user"]["uid"],snapshot.value["user"]["name"]);
        //user= User(snapshot.value["user"]["uid"],snapshot.value["user"]["name"]);







  toJson(){
    return{
      "workplace":workplace,
      "name":name,
      "year":year,
      "student":student,
      "branch":branch,
      "studentPhone":studentPhone,
      "user":{
        "uid":user.uid,
        "name":user.name,
      }
    };
 }

}


