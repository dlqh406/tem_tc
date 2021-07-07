import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_call/phoneCertification/models/Iamport_certification.dart';
import 'package:team_call/phoneCertification/screens/certification_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_call/phoneCertification/models/certification_data.dart';
import 'package:team_call/root.dart';




class Certification extends StatelessWidget {
  final FirebaseUser user;
  var carrier,name,phone,YYMMDD;
  static const String userCode = 'imp10391932';
  var data;
  var registerData;
  var from;
  Certification(this.user,this.carrier,this.name,this.phone,this.YYMMDD,this.data,this.from);

  @override
  Widget build(BuildContext context) {
    var userData ={
      'carrier' : carrier,
      'name': name,
      'phone': phone,
      'YYMMDD' : YYMMDD,
    };
    return IamportCertification(
      appBar: new AppBar(
        title: new Text('아임포트 본인인증'),
      ),
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/images/iamport-logo.png'),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      userCode: userCode,
      data: CertificationData.fromJson({
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        'company': '(주)쿠디',                                            // 회사명 또는 URL
        'carrier': carrier,                                               // 통신사
        'name': name,                                                 // 이름
        'phone': phone,                                         // 전화번호
      }),
      callback: (Map<String, String> result) {

        if(result['success'] == "true"){
          // from createHost_process
          if( from == 'c'){


            var _data0 ={
              'access' : "super",
              'inviteDate' : new DateTime.now(),
              'uid': data['uid'],
              'registerDate' :new DateTime.now(),
              'state' : true,
              'inviter' : data['inviter'],
              'landlineNum' : data['landlineNum'],
              'group' : data['group'],
              'department' : data['department'],
              'team' : data['team'],
              'name' : data['name'],
              'position' : data['position'],
              'phoneNumber' : data['phoneNumber'],
            };


            Firestore.instance.collection("main_data")
                  .document('${data['companyID']}')
                  .collection('main_collection')
                  .add(_data0).then((value) {

                  var data0 ={
                    'email' : user.email,
                    'uid' : user.uid,
                    'phoneNumber' : phone ,
                    'name' :name
                  };

                  var data1 ={
                    'uid' : user.uid,
                    'companyID': data['companyID'],
                    'docID' : value.documentID,
                    'name' : name,
                    'phoneNumber' : phone
                  };

                  Firestore.instance.collection("id_data")
                      .add(data1)
                      .then((value) {

                    Firestore.instance.collection("user_data")
                        .document(user.uid)
                        .setData(data0)
                        .then((value) {

                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) =>
                              Root()));

                    });


                  });



              });




          }
          else{
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
                var data0 ={
                  'email' : user.email,
                  'uid' : user.uid,
                  'phoneNumber' : phone ,
                  'name' :name
                };

                var data1 ={
                  'uid' : user.uid,
                };

                Firestore.instance.collection("id_data")
                    .document(id)
                    .updateData(data1)
                    .then((value) {

                  Firestore.instance.collection("user_data")
                      .document(user.uid)
                      .setData(data0)
                      .then((value) {


                    // Root에 파라미터를 넣어서 root 맨아래있는 스플래시 뷰가 안보이게 처리하자
                    // home에도 파라미터를 넣어서 처음 접속자는 welcome문자 넣기

                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) =>
                            Root()));

                  });


                });

              });
            });
          }


        }
        else{
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  CertificationResult(result,user,userData)));
        }

      },
    );
  }
  var receiver_number; // 수신자 연락처
  var receiver_name; // 수신자 성함
  var group; // 회사 명

  send_message(receiver_number, receiver_name, group){

    // receiver_number 문자 발송

    // 메세지 내용 -----------
    // ${receiver_name}님
    // 초대 그룹 : ${group}
    // 팀콜에 초대되었습니다.
    // --------------------
  }


}