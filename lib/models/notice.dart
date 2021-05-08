import 'package:firebase_database/firebase_database.dart';

class Notice{
  String key;
  String userWorkplace;
  String userName;
  String notification;
  String time;

  Notice(this.userWorkplace,this.userName,this.notification,this.time);

  //map data from json format to Notification format
  Notice.fromSnapshot(DataSnapshot snapshot):
        key=snapshot.key,
        userWorkplace=snapshot.value["userWorkplace"],
        userName=snapshot.value["userName"],
        notification=snapshot.value["notification"],
        time=snapshot.value["time"];


  //map the data back into json
  toJson(){
    return{
      "userWorkplace":userWorkplace,
      "userName":userName,
      "notification":notification,
      "time":time,
    };
  }

}