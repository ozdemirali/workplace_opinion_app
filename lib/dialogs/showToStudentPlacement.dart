
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workplace_opinion_app/dialogs/showToAlert.dart';
import 'package:workplace_opinion_app/models/user.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';
import 'package:workplace_opinion_app/widgets/inputDigital.dart';
import 'package:workplace_opinion_app/widgets/inputText.dart';
import 'package:workplace_opinion_app/widgets/teacher.dart';
import 'package:workplace_opinion_app/widgets/type.dart';
import 'package:workplace_opinion_app/widgets/workplaceList.dart';
import 'package:workplace_opinion_app/widgets/academicYear.dart';

TextEditingController txtWorkplace=new TextEditingController();
TextEditingController txtWorkplaceName=new TextEditingController();
TextEditingController txtWorkplaceType=new TextEditingController();
TextEditingController txtStudentName=new TextEditingController();
TextEditingController txtStudentPhone=new TextEditingController();
TextEditingController txtTeacherName=new TextEditingController();
TextEditingController txtTeacherUid=new TextEditingController();
TextEditingController txtPeriod=new TextEditingController();
TextEditingController txtYear=new TextEditingController();
TextEditingController txtBranch=new TextEditingController();

var maskFormatter = new MaskTextInputFormatter(mask: '# (###) ### ## ##', filter: { "#": RegExp(r'[0-9]') });

final _formKey = GlobalKey<FormState>();

String selectType;
String _key;

final FirebaseDatabase _database=FirebaseDatabase.instance;


showToStudentPlacement(BuildContext context,UserWorkplace data) async{
  if(data!=null){
    _key=data.key;
    txtWorkplace.text=data.workplace;
    txtWorkplaceName.text=data.name;
    txtWorkplaceType.text=data.type;
    txtTeacherUid.text=data.user.uid;
    txtTeacherName.text=data.user.name;
    txtStudentName.text=data.student;
    txtStudentPhone.text=data.studentPhone;
    txtBranch.text=data.branch;
    selectType=data.type;
    txtPeriod.text=data.period;
    txtYear.text=data.period.substring(0,4);
  }
  else{
    _key=null;
    txtStudentName.text="";
    txtStudentPhone.text="";
    txtWorkplace.text="";
    txtTeacherUid.text="";
    txtPeriod.text="";
  }

  add(){
    String uidYear;
    uidYear=txtTeacherUid.text+"_"+txtYear.text;
    UserWorkplace userWorkplace=new UserWorkplace(txtWorkplace.text, txtWorkplaceName.text,txtWorkplaceType.text,uidYear, txtPeriod.text, txtStudentName.text, txtBranch.text, txtStudentPhone.text,User(txtTeacherUid.text,txtTeacherName.text));
    // print(userWorkplace.toJson());
    if(_key==null){
      _database.reference().child("user_workplace").push().set(userWorkplace.toJson());
    }
    else{
      _database.reference().child("user_workplace").child(_key).set(userWorkplace.toJson()).then((_){
        //print("Başarılı");
      }).catchError((error){
        print(error.message);
        showToAlert(context,error.message);

      });
    }

  }


  await showDialog<String>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          title: Center(
            child: Text("Stajer Atama"),
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
                        //WorkplaceList(),
                        WorkplaceList(
                          database: _database,
                          workplace: txtWorkplace,
                          workplaceName: txtWorkplaceName,
                          workplaceType: txtWorkplaceType,),
                        Teacher(database: _database,teacherUid: txtTeacherUid, teacherName: txtTeacherName,),
                        inputText(txtStudentName,"Öğrenin Adı"),
                        AcademicYear(
                          database: _database,
                          period: txtPeriod,
                          year:txtYear,
                        ),
                        Type(
                          database: _database,
                          selectValue: txtBranch,
                          select: "branch",
                        ),
                        inputDigital(txtStudentPhone, "0 (999) 999 99 99", "Öğrencinin Telefonu", maskFormatter),
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
                          add();
                          //showToAlert(context);
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

