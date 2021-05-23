import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/dialogs/showToNotification.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';

class AllWorkplaceAppointed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllWorkplaceAppointedState();
  }
}

class AllWorkplaceAppointedState extends State<AllWorkplaceAppointed> {
  List<UserWorkplace> _appointedWorkplaceList;
  List<UserWorkplace> _foundWorkplace;
  Query _appointedQuery;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  StreamSubscription<Event> _onAppointedListAddedSubscription;
  StreamSubscription<Event> _onAppointedListChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appointedWorkplaceList = new List();
    _appointedQuery = _database.reference().child("user_workplace");

    _onAppointedListAddedSubscription =
        _appointedQuery.onChildAdded.listen(onEntryAdded);
    _onAppointedListChangedSubscription =
        _appointedQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    _onAppointedListAddedSubscription.cancel();
    _onAppointedListChangedSubscription.cancel();
    super.dispose();
  }

  onEntryAdded(Event event) {
    setState(() {
      _appointedWorkplaceList.add(UserWorkplace.fromSnapshot(event.snapshot));
      _foundWorkplace = _appointedWorkplaceList;
    });
  }

  onEntryChanged(Event event) {
    var oldEntry = _appointedWorkplaceList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _appointedWorkplaceList[_appointedWorkplaceList.indexOf(oldEntry)] =
          UserWorkplace.fromSnapshot(event.snapshot);
      _foundWorkplace = _appointedWorkplaceList;
    });
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      _foundWorkplace = _appointedWorkplaceList;
    } else {
      _foundWorkplace = _appointedWorkplaceList
          .where((a) =>
              a.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      print(_foundWorkplace.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    labelText: 'Ara', suffixIcon: Icon(Icons.search)),
                onChanged: (value) {
                  //print(value);
                  runFilter(value);
                },
              ),
              Expanded(
                child: _foundWorkplace != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _foundWorkplace.length,
                        itemBuilder: (BuildContext context, int position) {
                          return Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    _foundWorkplace[position].type ==
                                            "Alan Dışı"
                                        ? Colors.red
                                        : Colors.blue,
                                child: Text(""),
                              ),
                              title: Text(_foundWorkplace[position].name +" - "+_foundWorkplace[position].user.name),
                              subtitle: Text(_foundWorkplace[position].student +
                                  " (" +
                                  _foundWorkplace[position].branch +
                                  ") " +
                                  _foundWorkplace[position].period),
                              onTap: () {
                                //print("Seçildi");
                                showToNotification(context,_appointedWorkplaceList[position],0);
                              },
                            ),
                          );
                        })
                    : Text("Veri yok"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
