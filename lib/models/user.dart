import 'package:firebase_database/firebase_database.dart';

///This class is defined as model
///This model is used, When data gets from user(like table) on Realtime Database
///Also it can be used, crud operations from user_workplace(like table) on Realtime Database

class User{
  String uid;
  String name;

  User(this.uid,this.name);

  //map data from json format to User format
  User.fromSnapshot(DataSnapshot snapshot) :
        uid=snapshot.value["uid"],
        name=snapshot.value["name"];


  //map the data back into json
  toJson(){
    return{
      "uid": uid,
      "name":name,
    };
  }
}