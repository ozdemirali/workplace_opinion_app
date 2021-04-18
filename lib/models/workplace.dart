import 'package:firebase_database/firebase_database.dart';

class Workplace{
  String key;
  String name;
  String type;
  String phone;
  String address;
  String authorizedPerson;
  String explanation;

  Workplace(this.name,this.type,this.phone,this.address,this.authorizedPerson,this.explanation);

  Workplace.fromSnapshot(DataSnapshot snapshot) :
      key=snapshot.key,
      name=snapshot.value["name"],
      type=snapshot.value["type"],
      phone=snapshot.value["phone"],
      address=snapshot.value["address"],
      authorizedPerson=snapshot.value["authorizedPerson"],
      explanation=snapshot.value["explanation"];

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