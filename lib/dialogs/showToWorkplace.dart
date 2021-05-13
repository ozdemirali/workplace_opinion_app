
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workplace_opinion_app/models/workplace.dart';
import 'package:workplace_opinion_app/widgets/inputDigital.dart';
import 'package:workplace_opinion_app/widgets/inputText.dart';
import 'package:workplace_opinion_app/widgets/type.dart';

TextEditingController txtWorkplaceName=new TextEditingController();
TextEditingController txtPhone=new TextEditingController(text: "12345678");
TextEditingController txtAddress=new TextEditingController();
TextEditingController txtAuthorizedPerson=new TextEditingController();
TextEditingController txtExplanation=new TextEditingController();
TextEditingController txtSelectType=new TextEditingController();
var maskFormatter = new MaskTextInputFormatter(mask: '# (###) ### ## ##', filter: { "#": RegExp(r'[0-9]') });


final _formKey = GlobalKey<FormState>();
String _key;
String controlTxtWorkplaceName;

final FirebaseDatabase _database=FirebaseDatabase.instance;


showToWorkplace(BuildContext context,Workplace data) async{

  if(data!=null){
    _key=data.key;
    txtWorkplaceName.text=data.name;
    controlTxtWorkplaceName=data.name;
    txtSelectType.text=data.type;
    txtPhone.text=data.phone;
    txtAddress.text=data.address;
    txtAuthorizedPerson.text=data.authorizedPerson;
    txtExplanation.text=data.explanation;
  }
  else{
    _key=null;
    txtWorkplaceName.text="";
    //selectType="Web";
    txtSelectType.text="Web";
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
                  Form(
                    key: _formKey,
                    child:Column(
                      children: <Widget>[
                        inputText(txtWorkplaceName, "İşyerinin Adı"),
                        Type(
                          selectValue: txtSelectType,
                          database: _database,),
                        inputDigital(txtPhone, "0 (999) 999 99 99", "Telefonu", maskFormatter),
                        inputText(txtAddress, "Adresi"),
                        inputText(txtAuthorizedPerson, "Yetkili Kişi"),
                        inputText(txtExplanation, "Açıklama"),
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
                        //print(txtSelectType.text);
                       if(_formKey.currentState.validate()){
                         add();
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

add(){
  Workplace workplace=new Workplace(txtWorkplaceName.text,txtSelectType.text,txtPhone.text, txtAddress.text, txtAuthorizedPerson.text, txtExplanation.text);
  if(_key==null){
    _database.reference().child("workplace").push().set(workplace.toJson());
  }
  else{
   _database.reference().child("workplace").child(_key).set(workplace.toJson());

       if(_key!=null && txtWorkplaceName.text!=controlTxtWorkplaceName )
       _database.reference().child("user_workplace").orderByChild("workplace").equalTo(_key)
           .once()
           .then((DataSnapshot snapshot){
             snapshot.value.forEach((k,v){
               if(k!=null)
               _database.reference().child("user_workplace").child(k).child("name").set(txtWorkplaceName.text);
             });
       });
  }

}





