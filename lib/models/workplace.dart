import 'package:firebase_database/firebase_database.dart';

///This class is defined as model
///This model uses when a workplace will be added to Realtime Database
///On Realtime Database, Every record is added to  workplace(like table) as Json

class Workplace{
  String key;
  String name;
  String type;
  String phone;
  String address;
  String authorizedPerson;
  String explanation;

  Workplace(this.name,this.type,this.phone,this.address,this.authorizedPerson,this.explanation);

  //map data from json format to Workplace format
  Workplace.fromSnapshot(DataSnapshot snapshot) :
      key=snapshot.key,
      name=snapshot.value["name"],
      type=snapshot.value["type"],
      phone=snapshot.value["phone"],
      address=snapshot.value["address"],
      authorizedPerson=snapshot.value["authorizedPerson"],
      explanation=snapshot.value["explanation"];

  //map the data back into json
  toJson(){
    return{
      "name":name,
      "type":type,
      "phone":phone,
      "address":address,
      "authorizedPerson":authorizedPerson,
      "explanation":explanation,
    };
  }

}