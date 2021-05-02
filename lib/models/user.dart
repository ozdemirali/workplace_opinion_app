import 'package:firebase_database/firebase_database.dart';
class User{
  String uid;
  String name;

  User(this.uid,this.name);

  User.fromSnapshot(DataSnapshot snapshot) :
        uid=snapshot.value["uid"],
        name=snapshot.value["name"];

   

  toJson(){
    return{
      "uid": uid,
      "name":name,
    };
  }
}