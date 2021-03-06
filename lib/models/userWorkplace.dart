import 'package:firebase_database/firebase_database.dart';
import 'package:workplace_opinion_app/models/user.dart';


///This class is defined as model
///This model uses when matched student and workplace will be added to Realtime Database
///On Realtime Database, Every record is added to user_workplace(like table) as Json

class UserWorkplace{
  String key;
  String workplace;
  String name;
  String type;
  String uidYear;
  String period;
  String student;
  String branch;
  String studentPhone;
  User user;

  UserWorkplace(this.workplace,this.name,this.type,this.uidYear,this.period,this.student,this.branch,this.studentPhone,this.user);


  //map data from json format to userWorkplace format
  UserWorkplace.fromSnapshot(DataSnapshot snapshot) :
        key=snapshot.key,
        workplace=snapshot.value["workplace"],
        name=snapshot.value["name"],
        type=snapshot.value["type"],
        period=snapshot.value["period"],
        student=snapshot.value["student"],
        branch=snapshot.value["branch"],
        studentPhone=snapshot.value["studentPhone"],
        user= User(snapshot.value["user"]["uid"],snapshot.value["user"]["name"]);


  //map the data back into json
  toJson(){
    return{
      "workplace":workplace,
      "name":name,
      "type":type,
      "uid_year":uidYear,
      "period":period,
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


