
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workplace_opinion_app/models/data.dart';
import 'package:workplace_opinion_app/models/user.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';
import 'package:workplace_opinion_app/widgets/inputDigital.dart';
import 'package:workplace_opinion_app/widgets/inputText.dart';



TextEditingController txtStudentName=new TextEditingController();
TextEditingController txtStudentPhone=new TextEditingController();
var maskFormatter = new MaskTextInputFormatter(mask: '# (###) ### ## ##', filter: { "#": RegExp(r'[0-9]') });

final _formKey = GlobalKey<FormState>();

String selectWorkplace;
String selectWorkplaceName;
String selectWorkplaceType;
String selectTeacherName;
String selectTeacherUid;
String selectBranch;
String selectType;
String _key;

final FirebaseDatabase _database=FirebaseDatabase.instance;


showToStudentAssignment(BuildContext context,UserWorkplace data) async{

  if(data!=null){
    _key=data.key;
    selectWorkplace=data.workplace;
    selectWorkplaceType=data.type;
    selectTeacherUid=data.user.uid;
    selectTeacherName=data.user.name;
    txtStudentName.text=data.student;
    txtStudentPhone.text=data.studentPhone;
    selectBranch=data.branch;
    selectType=data.type;
  }
  else{
    //selectWorkplace=;
    //selectWorkplaceType=data.type;
    //selectTeacherUid=data.user.uid;
    //selectTeacherName=data.user.name;
    txtStudentName.text="";
    txtStudentPhone.text="";
    //selectBranch=data.branch;
    //selectType=data.type;
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
                        WorkplaceList(),
                        Teacher(),
                        inputText(txtStudentName,"Öğrenin Adı"),
                        Branch(),
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

class WorkplaceList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WorkplaceListState();
  }
}

class WorkplaceListState extends State<WorkplaceList>{
  List<Data> workplace=new List();


  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("workplace")
        .once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      values.forEach((k,v) {
        workplace.add(Data(k,v["name"],v["type"]));

      });
    });
  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      workplace.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //print("Widget ");
    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            //print(data);
            return DropdownButtonFormField<String>(
              hint: Text("İş Yeri Seçiniz"),
              value: selectWorkplace,
              items: workplace
                  .map((label) => DropdownMenuItem(
                child: Text(label.name),
                value: label.key,
              )).toList(),
              onChanged: (value){
                setState(() {
                  selectWorkplace=value;
                  print(value);
                  workplace.forEach((f){
                    if(f.key==value){
                      print(f.name);
                      print(f.type);
                      selectWorkplaceName=f.name;
                      selectWorkplaceType=f.type;

                    }
                  });
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}

class Teacher extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TeacherState();
  }
}

class TeacherState extends State<Teacher>{
  List<User> teacher=new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print("---name");
    _database
        .reference()
        .child("user").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
      snapshot.value.forEach((value){
        if(value!=null){
          //print(value["name"]);
          teacher.add(User(value["uid"], value["name"].trim()+" "+value["surname"].trim()));
        }
      });
    });
  }
  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds: 1),()=>
      teacher.length.toString()
  );


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<String>(
      future: callAsyncFetch(),
      builder: (context,AsyncSnapshot<String> snapshot){
        if(snapshot.data!="0"){
          //print(teacher);
          return DropdownButtonFormField<String>(
            hint: Text("Öğretmen Ata"),
            value: selectTeacherUid,
            items: teacher
                .map((label)=>DropdownMenuItem(
              child: Text(label.name),
              value: label.uid,
            )).toList(),
            onChanged: (value){
              setState(() {
                teacher.forEach((f){
                  if(f.uid==value){
                    selectTeacherUid=f.uid;
                    selectTeacherName=f.name;
                  }
                  //print(selectTeacherUid);
                  //print(selectTeacherName);

                });
              });
            },
          );
        }else
        {
          //print(teacher);
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class Branch extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BranchState();
  }
}

class BranchState extends State<Branch>{
  List<String> branch=new List();

  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("branch").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
      snapshot.value.forEach((value){
        if(value!=null){
          branch.add(value["name"].trim());
        }
      });
    });

  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      branch.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              hint: Text("Dalını seçiniz"),
              value: selectBranch,
              items: branch
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              )).toList(),
              onChanged: (value){
                setState(() {
                  selectBranch=value;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}




add(){
  print("add Workplace");
  print("asd");
  //_database.reference().child("user_workplace").push().set(UserWorkplace(selectWorkplace, selectWorkplaceName,selectWorkplaceType, "year", txtStudentName.text, selectBranch, txtStudentPhone.text,User(selectTeacherUid,selectTeacherName)).toJson());
  UserWorkplace userWorkplace=new UserWorkplace(selectWorkplace, selectWorkplaceName,selectWorkplaceType, "year", txtStudentName.text, selectBranch, txtStudentPhone.text,User(selectTeacherUid,selectTeacherName));
  //Workplace workplace=new Workplace(txtWorkplaceName.text,selectType,txtPhone.text, txtAddress.text, txtAuthorizedPerson.text, txtExplanation.text);
  if(_key==null){
    print("add new data");
    _database.reference().child("user_workplace").push().set(userWorkplace.toJson());
  }
  else{
    print("update data");
    _database.reference().child("user_workplace").child(_key).set(userWorkplace.toJson());
  }

}