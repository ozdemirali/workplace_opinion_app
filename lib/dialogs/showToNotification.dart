


import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/models/notice.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';
import 'package:workplace_opinion_app/widgets/inputText.dart';



TextEditingController txtNotification=new TextEditingController();

final _formKey = GlobalKey<FormState>();


final FirebaseDatabase _database=FirebaseDatabase.instance;


showToNotification(BuildContext context,UserWorkplace userWorkplace) async{
  txtNotification.text="";

  await showDialog<String>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          title: Center(
            child:  Form(
              key: _formKey,
              child:Column(
                children: <Widget>[
                  inputText(txtNotification, "Bildiriminiz"),
                ],
              ) ,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          content: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  // Form(
                  //   key: _formKey,
                  //   child:Column(
                  //     children: <Widget>[
                  //       inputText(txtNotification, "Bildiriminiz"),
                  //     ],
                  //   ) ,
                  // ),
                  listNotification(userWorkplace.key),
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
                          add(userWorkplace.key,userWorkplace.user.name,txtNotification.text);
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

Widget listNotification(String userWorkplaceKey){
  List<Notice> notification=new List();
  _database.reference().child("notification")
      .orderByChild("userWorkplace")
      .equalTo(userWorkplaceKey)
      .once().then((DataSnapshot snapshot){
    if(snapshot.value!=null){
      Map<dynamic, dynamic> values=snapshot.value;
      values.forEach((k,v) {
        notification.add(Notice(v["userWorkplace"],v["userName"],v["notification"],v["time"]));
      });
    }

  });

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      notification.length.toString()
  );

  return FutureBuilder<String>(
      future: callAsyncFetch(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        print(snapshot.data);
        if (snapshot.data!="0") {
          return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: notification.length,
              itemBuilder: (BuildContext context,int position){
                return ListTile(
                  title: Text(notification[position].notification),
                  subtitle: Text(notification[position].userName + " - "+notification[position].time ,style: TextStyle(fontSize: 12),),
                );

              });
        } else {
          return ListTile(
            subtitle: Text("Heni bildirim yapmadınız.",style:TextStyle(fontSize: 12) ,),
          );
        }
      });


}






add(String userWorkplaceKey,String userName,String not){

  String time=DateTime.now().day.toString() +"/"+DateTime.now().month.toString()+ "/"+ DateTime.now().year.toString();
  Notice notification=new Notice(userWorkplaceKey, userName, not, time);

  _database.reference().child("notification").push().set(notification.toJson());


}