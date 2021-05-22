import 'package:firebase_database/firebase_database.dart';

///This method is to save error as log on Realtime Database
///On Realtime Database,log is as jason
///Log file is log
FirebaseDatabase _database=FirebaseDatabase.instance;

saveToLog(String log) async{
  try{
    _database.reference().child("log").push().set({"error":log,"time":DateTime.now().toString()});
  }catch(error){
   // print("hata");
    _database.reference().child("log").push().set({"error":error.toString(),"time":DateTime.now().toString()});
  }



}