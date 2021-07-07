import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_call/phoneCertification.dart';
import 'package:team_call/root.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  final myControllerEmail = TextEditingController();
  final myControllerPW = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login Page") ,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new TextField(
                controller: myControllerEmail,
                decoration: new InputDecoration(
                    hintText:  '이메일',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.blueAccent
                        )
                    )
                ),
              ),
              new TextField(
                obscureText: true,
                controller: myControllerPW,
                decoration: new InputDecoration(
                    hintText:  '패스워드',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.blueAccent
                        )
                    )
                ),
              ),
              RaisedButton(
                onPressed: () => {
                  logIn()
                },
                child: Text('로그인'),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Future<FirebaseUser> logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myControllerEmail.text,
          password: myControllerPW.text
      ).then((value) {

        Firestore.instance.collection("user_data")
            .document(value.user.uid)
            .get().then((docs){
              if(docs.exists){
                Firestore.instance
                    .collection("id_data")
                    .where('phoneNumber',
                    isEqualTo: '${docs.data['phoneNumber']}')
                    .where(
                    'name', isEqualTo: '${docs.data['name']}')
                    .getDocuments().then((querySnapshot) {
                  if (querySnapshot.documents.length == 0) {
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "고객님 정보로 초대된 정보가 없습니다.",
                      ),
                    );
                  }
                  else {
                    querySnapshot.documents.forEach((result) {
                      _showAlert(result,value.user,docs.data['phoneNumber'],docs.data['name']);
                    });
                  }
                });


              }else{
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        PhoneCertification (value.user)
                    ));
              }

        });


      });
    } catch (e) {
      print(e.code);
      if (e.code == 'ERROR_USER_NOT_FOUND') {

        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "등록되지 않은 계정입니다",
          ),
        );
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "잘못된 패스워드입니다",
          ),
        );
      }
    }

  }
  Widget _showAlert(var data,user,phoneNumber,name) {
    var doc = data.data;

    print(data.documentID);
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 350.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          children: <Widget>[
            // dialog top
            new Row(
              children: <Widget>[
                new Container(
                  // padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: new Text(
                    '초대 그룹 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {

                      Navigator.pop(context, true);
                    },
                    child: Icon(Icons.clear))
              ],
            ),
            // dialog centre
            SizedBox(
              height: 20,
            ),
            Spacer(),
            StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('main_data')
                    .document('${doc['companyID']}').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection('main_data')
                          .document('${doc['companyID']}').collection(
                          'main_collection')
                          .document('${doc['docID']}')
                          .snapshots(),
                      builder: (context, _snapshot) {
                        if (!_snapshot.hasData) {
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('그룹명', style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),),
                            SizedBox(
                              height: 3,
                            ),
                            Text('${snapshot.data.data['name'] ?? "" }'),
                            SizedBox(
                              height: 9,
                            ),
                            Text('소속', style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),),
                            SizedBox(
                              height: 3,
                            ),
                            Text('${_snapshot.data.data['group'] ??
                                "" + " " + _snapshot.data.data['department'] ??
                                "" + " " + _snapshot.data.data['team'] ??
                                "" }'),
                            SizedBox(
                              height: 13,
                            ),
                            Text('${_snapshot.data.data['name'] ??
                                "" + " " + _snapshot.data.data['position']??""}', style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),),
                          ],
                        );
                      }
                  );
                }
            ),
            Spacer(),
            // dialog bottom
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: ()  {
                      print('aa');

                      var doc = data.data;
                      var id = data.documentID;
                      Firestore.instance.collection("main_data").document('${doc['companyID']}').collection('main_collection')
                          .document('${doc['docID']}').get().then((value){

                        var data ={
                          'uid' : user.uid,
                          'registerDate' : DateTime.now(),
                          'state' : true
                        };
                        Firestore.instance.collection("main_data").document('${doc['companyID']}')
                            .collection('main_collection')
                            .document('${doc['docID']}').updateData(data).then((value) {

                          var data1 ={
                            'uid' : user.uid,
                          };

                          Firestore.instance.collection("id_data")
                              .document(id)
                              .updateData(data1)
                              .then((value) {


                              // Root에 파라미터를 넣어서 root 맨아래있는 스플래시 뷰가 안보이게 처리하자
                              // home에도 파라미터를 넣어서 처음 접속자는 welcome문자 넣기

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) =>
                                      Root()));




                          });

                        });
                      });

                    },
                    child: new Container(
                      padding: new EdgeInsets.all(16.0),
                      decoration: new BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: new Text(
                        '초대 수락',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // ignore: missing_return
          return dialog;
        });
  }
}
