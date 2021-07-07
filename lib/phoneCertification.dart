import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_call/phoneCertification/screens/certification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PhoneCertification extends StatefulWidget {
  int paymentValue = 1;
  final FirebaseUser user;
  PhoneCertification(this.user);

  @override
  _PhoneCertificationState createState() => _PhoneCertificationState();
}
class _PhoneCertificationState extends State<PhoneCertification> {
  final myControllerName = TextEditingController();
  final myControllerBirth = TextEditingController();
  final myControllerPhone = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(preferredSize: Size.fromHeight(40.0),
          child:
          AppBar(
            titleSpacing: 6.0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 00.0),
              child: Container(
                child: GestureDetector(
                    child: Icon(Icons.arrow_back_ios, size: 18,),

                    onTap: () {
                      Navigator.pop(context);
                    }),
              ),
            ),

          )),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 10, right: 30),
      child: ListView(

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('본인', style: TextStyle(fontSize: 35),),
              Text(' 인증',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
              SizedBox(width: 10,),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text('성함'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              controller: myControllerName,
              decoration: new InputDecoration(
                  hintText: "고객님의 성함을 입력해주세요",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.blueAccent
                      )
                  )
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text('생년월일 (8자리)'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: myControllerBirth,
              decoration: new InputDecoration(
                  hintText: "예) 19941031",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.blueAccent
                      )
                  )
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),

          Row(
            children: [
              Text('휴대폰 번호'),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Container(
                  child: DropdownButton(
                      value: widget.paymentValue,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            "SKT", style: TextStyle(fontWeight: FontWeight
                              .bold),),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "KT", style: TextStyle(fontWeight: FontWeight
                              .bold),),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "LGU+", style: TextStyle(fontWeight: FontWeight
                              .bold),),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "알뜰폰", style: TextStyle(fontWeight: FontWeight
                              .bold),),
                          value: 4,
                        ),

                      ],
                      onChanged: (value) {
                        setState(() {
                          widget.paymentValue = value;
                        });
                      }
                  ),
                ),
              ),

            ],
          ),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: SizedBox(
              height: 35,
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                controller: myControllerPhone,
                decoration: new InputDecoration(
                    hintText: "- 없이 번호만 입력해주세요",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.blueAccent
                        )
                    )
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                  height: 46,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 1,
                  child: RaisedButton(
                      child: const Text('사용자 인증',
                          style: TextStyle(color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),),
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (myControllerName.text == "" ||
                            myControllerPhone.text == "" ||
                            myControllerBirth.text == "") {
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message:
                              "모든 정보를 입력해주세요.",
                            ),
                          );
                        } else {
                          if (myControllerBirth.text.length == 8) {
                            var date = new DateTime.now().toString();
                            var dateParse = DateTime.parse(date);
                            var formattedDate = dateParse.year.toString();
                            var userBirth = myControllerBirth.text;
                            var currentY = formattedDate;
                            var equalY = int.parse(currentY) - int.parse(
                                userBirth[0] + userBirth[1] + userBirth[2] +
                                    userBirth[3]);
                            var currentM = dateParse.month.toString();
                            var currentD = dateParse.day.toString();
                            var userMM = userBirth[4] + userBirth[5];
                            var userDD = userBirth[6] + userBirth[7];
                            if (int.parse(currentM) - int.parse(userMM) > 0 ==
                                false) {
                              if (int.parse(currentD) - int.parse(userDD) > 0 ==
                                  false) {
                                equalY = equalY - 1;
                              }
                            }
                            print(equalY);

                            if (equalY >= 14) {

                              Firestore.instance
                                  .collection("id_data")
                                  .where('phoneNumber',
                                  isEqualTo: '${myControllerPhone.text}')
                                  .where(
                                  'name', isEqualTo: '${myControllerName.text}')
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
                                    _showAlert(result);
                                  });
                                }
                              });


                            }
                            else {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message:
                                  "만 14세 미만 아동은 법정대리인의 동의서가 필요함으로 자세한 사항은 고객센터 문의 바랍니다.",
                                ),
                              );
                            }
                          } else {
                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message:
                                "생년 월일을 8자리로 입력해주세요 \n예시)19941031",
                              ),
                            );

                          }
                        }



                      }


                  ))
          ),

        ],
      ),
    );
  }




  Widget _showAlert(var data) {
    var doc = data.data;
    print(widget.user.uid);
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
                                "" + " " + _snapshot.data.data['position'] ??
                                ""}', style: TextStyle(
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
                    onTap: () async {
                      var carrier;
                      if (widget.paymentValue == 1) {
                        carrier = "SKT";
                      }
                      else if (widget.paymentValue == 2) {
                        carrier = "KTF";
                      }
                      else if (widget.paymentValue == 3) {
                        carrier = "LGT";
                      }
                      else {
                        carrier = "MVNO";
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              Certification(
                                widget.user,carrier,myControllerName.text,myControllerPhone.text,myControllerBirth.text,data,'a'
                              )));

                    },
                    child: new Container(
                      padding: new EdgeInsets.all(16.0),
                      decoration: new BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: new Text(
                        '초대 수락 후 본인 인증 진행',
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


