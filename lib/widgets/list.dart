import 'package:flutter/material.dart';

Widget Listeleme(){
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
        child:ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (BuildContext context,int position){
            return Dismissible(
              key: Key("1"),
              //background: Container(color:Colors.red),
              onDismissed: (direction) async{
                print("Dismission work");
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
                    backgroundColor: Colors.blue,
                    child: Text(""),
                  ),
                  title: Text("Tek Bilgisayar"),
                  subtitle: Text("Adem Ece - 0 505 365 39 88"),
                  onTap: (){
                    print("Seçildi");
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