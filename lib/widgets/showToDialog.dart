
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/widgets/showToForm.dart';

final _formKey = GlobalKey<FormState>();

showToDialog(BuildContext context) async{

  await showDialog<String>(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        contentPadding: EdgeInsets.only(left: 5,right: 5),
        title: Center(
          child: Text("Alert Box"),
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
                showToForm(_formKey),
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