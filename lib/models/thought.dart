import 'package:firebase_database/firebase_database.dart';

class Thought{
  String key;
  String time;
  String notification;

  Thought(this.notification,this.time);

  Thought.fromSnapshot(DataSnapshot snapshot):
        key=snapshot.key,
        notification=snapshot.value["notification"],
        time=snapshot.value["time"];

  toJson(){
    return{
      "notification":notification,
      "time":time,
    };
  }
}