import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/dialogs/showToAlert.dart';
import 'package:workplace_opinion_app/dialogs/showToStudentPlacement.dart';
import 'package:workplace_opinion_app/method/saveToLog.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';

class StudentPlacement extends StatefulWidget{
  StudentPlacement({this.year});
  final year;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StudentPlacementState();
  }

}

class StudentPlacementState extends State<StudentPlacement> {

  List<UserWorkplace> _userWorkplaceList;
  Query _userWorkplaceQuery;
  final FirebaseDatabase _database=FirebaseDatabase.instance;

  StreamSubscription<Event> _onUserWorkplaceAddedSubscription;
  StreamSubscription<Event> _onUserWorkplaceChangedSubscription;
  StreamSubscription<Event> _onUserWorkplaceRemovedSubscription;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userWorkplaceList=new List();
    _userWorkplaceQuery=_database.reference()
                                  .child("user_workplace")
                                  .orderByChild("period").equalTo(widget.year);

    _onUserWorkplaceAddedSubscription=_userWorkplaceQuery.onChildAdded.listen(onEntryAdded);
    _onUserWorkplaceChangedSubscription=_userWorkplaceQuery.onChildChanged.listen(onEntryChanged);
    _onUserWorkplaceRemovedSubscription=_userWorkplaceQuery.onChildRemoved.listen(onEntryRemoved);
  }

  @override
  void dispose(){
    _onUserWorkplaceAddedSubscription.cancel();
    _onUserWorkplaceChangedSubscription.cancel();
    _onUserWorkplaceRemovedSubscription.cancel();
    super.dispose();
  }

  onEntryAdded(Event event){
    setState(() {
      _userWorkplaceList.add(UserWorkplace.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event){
    var oldEntry=_userWorkplaceList.singleWhere((entry){
      return entry.key==event.snapshot.key;
    });
    setState(() {
      _userWorkplaceList[_userWorkplaceList.indexOf(oldEntry)]=
          UserWorkplace.fromSnapshot(event.snapshot);
    });
  }

  onEntryRemoved(Event event){
    var oldEntry=_userWorkplaceList.singleWhere((entry){
      return entry.key==event.snapshot.key;
    });
    setState(() {
      _userWorkplaceList.remove(oldEntry);
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
          //child:studentToWorkplace(),
          child:ListView.builder(
            shrinkWrap: true,
            itemCount: _userWorkplaceList.length,
            itemBuilder: (BuildContext context,int position){
              return Dismissible(
                key: Key(_userWorkplaceList[position].key),
                //background: Container(color:Colors.red),
                onDismissed: (direction) async{
                  //print("Dismission work");
                  deleteUserWorkplace(_userWorkplaceList[position].key);
                },
                secondaryBackground: Container(
                  child: Center(
                    child: Text("Sil",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white),),
                  ),
                  color: Colors.red,
                ),
                background: Container(),
                child: Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _userWorkplaceList[position].type=="Alan D??????"?Colors.red:Colors.blue,
                      child: Text("",),
                    ),
                    title: Text(_userWorkplaceList[position].name +" - "+ _userWorkplaceList[position].user.name),
                    subtitle: Text(_userWorkplaceList[position].student +"  ("+ _userWorkplaceList[position].branch+") "+ _userWorkplaceList[position].studentPhone
                    ),
                    onTap: (){
                      //print("Se??ildi");
                      //print(_userWorkplaceList[position]);
                       showToStudentPlacement(context, _userWorkplaceList[position]);
                    },
                  ),
                ),
              );
            },
          ) ,
        ),
      ],
    );
  }

  /// This function deletes the item of userWorkplace list  from the Realtime Database.
  /// deletes according to [key]
  deleteUserWorkplace(String key) {
    try{
      _database.reference().child("user_workplace").child(key).remove().then((_){})
          .catchError((error){
        showToAlert(context, error.toString());
      });
    }catch(error){
      saveToLog(error.toString());
    }

  }
}