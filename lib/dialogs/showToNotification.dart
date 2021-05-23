import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/dialogs/showToAlert.dart';
import 'package:workplace_opinion_app/method/saveToLog.dart';
import 'package:workplace_opinion_app/models/notice.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';
import 'package:workplace_opinion_app/widgets/inputText.dart';

TextEditingController txtNotification = new TextEditingController();
final _formKey = GlobalKey<FormState>();
final FirebaseDatabase _database = FirebaseDatabase.instance;

///This method is for sent notification.
/// [context] is for Alert Dialog,
/// [userWorkplace] is data, which comes workplaceAppointed and allWorkplaceAppointed
/// chose is optional.
///chose parameter comes only from allWorkplaceAppointed. It can be any number
showToNotification(BuildContext context, UserWorkplace userWorkplace,[int chose]) async {
  txtNotification.text = "";

  await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 5, right: 5),
          title: Center(
            child: chose == null
                ? Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        inputText(txtNotification, "Bildiriminiz"),
                      ],
                    ),
                  )
                : Text("Bildirimler"),
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
                  listNotification(userWorkplace.key),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new FlatButton(
                      child: const Text('İptal'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Visibility(
                    visible: chose==null?true:false,
                    child:new FlatButton(
                        child: const Text('Kayıt'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            add(context, userWorkplace.key,
                                userWorkplace.user.name, txtNotification.text);
                            Navigator.pop(context);
                          }
                        }),
                  ),

                ],
              ),
            ),
          ],
        );
      });
}

Widget listNotification(String userWorkplaceKey) {
  List<Notice> notification = new List();
  _database
      .reference()
      .child("notification")
      .orderByChild("userWorkplace")
      .equalTo(userWorkplaceKey)
      .once()
      .then((DataSnapshot snapshot) {
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((k, v) {
        notification.add(Notice(
            v["userWorkplace"], v["userName"], v["notification"], v["time"]));
      });
    }
  });

  Future<String> callAsyncFetch() => Future.delayed(
      Duration(seconds: 1), () => notification.length.toString());

  return FutureBuilder<String>(
      future: callAsyncFetch(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        //print(snapshot.data);
        if (snapshot.data != "0") {
          return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: notification.length,
              itemBuilder: (BuildContext context, int position) {
                return ListTile(
                  title: Text(notification[position].notification),
                  subtitle: Text(
                    notification[position].userName +
                        " - " +
                        notification[position].time,
                    style: TextStyle(fontSize: 12),
                  ),
                );
              });
        } else {
          return ListTile(
            subtitle: Text(
              "Henüz bildirimde bulunmadınız.",
              style: TextStyle(fontSize: 12),
            ),
          );
        }
      });
}

///Save notification
///userWorkPlace add to Notification as Key on Realtime Database
add(BuildContext context, String userWorkplaceKey, String userName,
    String not) {
  try {
    String time = DateTime.now().day.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();
    Notice notification = new Notice(userWorkplaceKey, userName, not, time);
    _database
        .reference()
        .child("notification")
        .push()
        .set(notification.toJson())
        .then((_) {})
        .catchError((error) {
      showToAlert(context, error.toString());
    });
  } catch (error) {
    saveToLog(error.toString());
  }
}
