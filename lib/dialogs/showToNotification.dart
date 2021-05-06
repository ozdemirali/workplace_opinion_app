

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/models/thought.dart';
import 'package:workplace_opinion_app/widgets/inputText.dart';



TextEditingController txtNotification=new TextEditingController();

final _formKey = GlobalKey<FormState>();

String selectWorkplace;
String selectWorkplaceName;
String selectWorkplaceType;
String selectTeacherName;
String selectTeacherUid;
String selectBranch;
String selectType;
String _key;

final FirebaseDatabase _database=FirebaseDatabase.instance;


showToNotification(BuildContext context,String key) async{
  print(key);
  // if(data!=null){
  //   _key=data.key;
  //   selectWorkplaceName=data.name;
  //   selectWorkplaceType=data.type;
  //   selectTeacherUid=data.user.uid;
  //   selectTeacherName=data.user.name;
  //   txtStudentName.text=data.student;
  //   txtStudentPhone.text=data.studentPhone;
  //   selectBranch=data.branch;
  //   selectType=data.type;
  // }
  // else{
  //   _key=null;
  //   txtStudentName.text="";
  //   txtStudentPhone.text="";
  // }
  //


  await showDialog<String>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          title: Center(
            child: Text("Bildirim"),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          content: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  //showToForm(_formKey),
                  Form(
                    key: _formKey,
                    child:Column(
                      children: <Widget>[
                        inputText(txtNotification, "Bildiriminiz"),
                      ],
                    ) ,
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              alignment:Alignment.center,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new FlatButton(
                      child:const Text('İptal'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                      child:const Text('Kayıt'),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          add(key);
                          Navigator.pop(context);
                        }

                      }),
                ],
              ),
            ),
          ],
        );
      }
  );
}








add(String _key){

  String time=DateTime.now().day.toString() +"/"+DateTime.now().month.toString()+ "/"+ DateTime.now().year.toString();
  Thought thought=new Thought(txtNotification.text, time);

  _database.reference().child("user_workplace").child(_key).child("tohougts").push().set(thought.toJson());


}