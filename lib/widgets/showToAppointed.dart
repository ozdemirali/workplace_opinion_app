import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';
import 'package:workplace_opinion_app/widgets/studentToWorkplace.dart';

showToAppointed(BuildContext context,UserWorkplace appointedWorkplace) async {

  await showDialog<String>(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        contentPadding: EdgeInsets.only(left: 5,right: 5),
        title: Center(
          child: Text("Atanmış İşyerleri"),
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
                studentToWorkplace(),
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
              children: <Widget>[
                new FlatButton(
                    child:const Text('İptal'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child:const Text('Kayıt'),
                    onPressed: () {
                      //if(_formKey.currentState.validate()){
                      //  addWorkplace();
                        Navigator.pop(context);
                      //}
                    }),
              ],
            ),
          )
        ],
      );
    }
  );
}