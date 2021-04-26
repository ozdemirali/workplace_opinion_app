import 'package:firebase_database/firebase_database.dart';

class Thought{
  String key;
  String time;
  String notification;

  Thought(this.time,this.notification);

  Thought.fromSnapshot(DataSnapshot snapshot):
        key=snapshot.key,
        time=snapshot.value["time"],
        notification=snapshot.value["notification"];

  toJson(){
    return{
      "time":time,
      "notification":notification,
    };
  }
}