
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/models/workplace.dart';
import 'package:workplace_opinion_app/widgets/address.dart';
import 'package:workplace_opinion_app/widgets/authorizerPerson.dart';
import 'package:workplace_opinion_app/widgets/explanation.dart';
import 'package:workplace_opinion_app/widgets/phone.dart';
import 'package:workplace_opinion_app/widgets/workplaceName.dart';

TextEditingController txtWorkplaceName=new TextEditingController();
TextEditingController txtPhone=new TextEditingController(text: "12345678");
TextEditingController txtAddress=new TextEditingController();
TextEditingController txtAuthorizedPerson=new TextEditingController();
TextEditingController txtExplanation=new TextEditingController();


final _formKey = GlobalKey<FormState>();
String selectType;
String _key;

final FirebaseDatabase _database=FirebaseDatabase.instance;


showToDialog(BuildContext context,Workplace data) async{

  if(data!=null){
    _key=data.key;
    txtWorkplaceName.text=data.name;
    selectType=data.type;
    txtPhone.text=data.phone;
    txtAddress.text=data.address;
    txtAuthorizedPerson.text=data.authorizedPerson;
    txtExplanation.text=data.explanation;
  }
  else{
    txtWorkplaceName.text="";
    selectType="Web";
    txtPhone.text="";
    txtAddress.text="";
    txtAuthorizedPerson.text="";
    txtExplanation.text="";
  }



  await showDialog<String>(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        contentPadding: EdgeInsets.only(left: 5,right: 5),
        title: Center(
          child: Text("Yeni işyeri Ekle"),
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
                      workplaceName(txtWorkplaceName),
                      Type(),
                      phone(txtPhone),
                      address(txtAddress),
                      authorizedPerson(txtAuthorizedPerson),
                      explanation(txtExplanation),
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
                          addWorkplace();
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


class Type extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TypeState();
  }
}

class TypeState extends State<Type>{
  List<String> type=new List();

  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("type").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
      snapshot.value.forEach((value){
        if(value!=null){
          type.add(value["name"].trim());
        }
      });
    });


  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      type.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   //print("Widget ");
    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              value: selectType,
              items: type
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              )).toList(),
              onChanged: (value){
                setState(() {
                  selectType=value;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}


addWorkplace(){
  print("add Workplace");
  print("asd");
  Workplace workplace=new Workplace(txtWorkplaceName.text,selectType,txtPhone.text, txtAddress.text, txtAuthorizedPerson.text, txtExplanation.text);
  if(_key==null){
    print("add new data");
    _database.reference().child("workplace").push().set(workplace.toJson());
  }
  else{
    print("update data");
    _database.reference().child("workplace").child(_key).set(workplace.toJson());
  }

}