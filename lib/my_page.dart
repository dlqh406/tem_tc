
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_call/detail_info.dart';
import 'package:team_call/not-logged-in.dart';
import 'package:team_call/root.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';


class MyPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;
  final FirebaseUser user;
  var userData;
  MyPage(this.user,this.userData);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarBuild() ,
      body: _bodyBuilder(),
    );
  }
  // dsd
  Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(45.0),
          child: Container(
            child: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              title: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Image.asset('assets/text2.png',width: 135,),
                  )),
              actions: <Widget>[
              ],
            ),
          )
      );
  }
  Widget _bodyBuilder() {
    return ListView(
      children: [
        SizedBox(height: 15),
        _buildHeader(),
        SizedBox(height: 15),
        _buildOrderList(),
        SizedBox(height: 15),
        customerCenter(),
        SizedBox(height: 15),
        // like(),
        // SizedBox(height: 15),
        myInfoDetail(),
        SizedBox(height: 80),

      ],
    );
  }
  Widget myInfo() {
    return Container(

      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [

              _buildMyInFoElement()

            ],
          ),

        ],
      ),
    );
  }
  Widget _buildMyInFoElement() {
    return Column(
      children: [
        Row(
            children: [
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 13,),
                    Row (
                        children:[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text('${widget.userData['user']['group'] +" "+ widget.userData['user']['department']+" "+ widget.userData['user']['team']}')),
                        ]
                    ),

                    SizedBox(height: 8,),
                    Row (
                        children:[
                          Text('${widget.userData['user']['name']}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                          SizedBox(width: 6,),
                          Text('${widget.userData['user']['position']}',style: TextStyle(fontSize: 15),),
                          SizedBox(width: 6,),
                        ]
                    ),
                    SizedBox(height: 8,),
                    Text('${numberWithComma(widget.userData['user']['phoneNumber']) }',style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),

            ]
        ),

      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
            offset: Offset(10,23),
        blurRadius: 40,
        color: Colors.black12,
      ),
   ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
              child: Container(
                child: Column(
                  children: [
                    widget.userData['user']['state']?
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: Text("계정 활성화 상태",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text("정상적으로 계정이 활성화 되어있습니다.",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blue),),
                      ],
                    ):Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: Text("계정 비활성화 상태",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text("관리자에 의해 계정이 비활성 됐습니다",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.redAccent),),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('${widget.userData['user']['name']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                        Text('님 반갑습니다!',style: TextStyle(fontSize: 25, fontWeight: FontWeight.w100),),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    myInfo(),
                    SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*1,
                      child: RaisedButton(
                        color: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),),
                        child: Text("내 정보 수정하기",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        onPressed:(){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  DetailInfo(widget.user,widget.userData,widget.userData['user'])));

                        },
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
 }

  Widget _buildOrderList() {
    return Container();
  }


  Widget customerCenter() {
    return InkWell(
      onTap: (){
        launchURL() {
          launch('http://pf.kakao.com/_JxoxexnK/chat');
        }
        launchURL();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(10,23),
                blurRadius: 40,
                color: Colors.black12,
              ),
            ],
          ),
          child:
          Column(

            children: [
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child:
                Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Icon(Icons.access_alarms_sharp),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:12.0,left:10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1:1 채팅 고객센터',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('운영시간 09:00~18:00 (월~금,공휴일 휴무)',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Icon(Icons.arrow_forward_ios,size: 17,),
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget like() {
    return InkWell(
      onTap: (){
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context){
        //       return HeartPage(widget.user);
        //     }));

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(10,23),
                blurRadius: 40,
                color: Colors.black12,
              ),
            ],
          ),
          child:
          GestureDetector(
            onTap: (){
              //  북마크 삭제 작업
              scaffoldKey.currentState
                  .showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.white,
                      duration: const Duration(seconds: 10),
                      content:
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center,
                          children: [
                            Text('데이터 삭제중', style: TextStyle(
                                fontSize: 30,
                                color: Colors.black),),
                            SizedBox(height: 24,),
                            Center(
                                child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<
                                        Color>(Colors.blue)))
                          ],
                        ),
                      )));
              void delete_bookmark(){
                Firestore.instance
                    .collection('main_data')
                    .document(widget.userData['companyUid'])
                    .collection('main_collection')
                    .getDocuments().then((value) {
                  value.documents.forEach((element0) {
                    print('element0');
                    Firestore.instance
                        .collection('main_data')
                        .document(widget.userData['companyUid'])
                        .collection('main_collection')
                        .document(element0.documentID)
                        .collection('bookmark')
                        .getDocuments().then((value) {
                      value.documents.forEach((element1) {

                        if (element1.data['docID'] == widget.userData['docID']) {

                          print(element1.documentID);
                          Firestore.instance
                              .collection('main_data')
                              .document(
                              widget.userData['companyUid'])
                              .collection('main_collection')
                              .document(element0.documentID)
                              .collection('bookmark')
                              .document(element1.documentID)
                              .delete();
                        }
                      });

                    });
                  });
                  //
                  // print( 'doc삭제');
                });
              }
              void delete_doc(){
                Firestore.instance.collection('id_data').getDocuments().then((querySnapshot) {
                  querySnapshot.documents.forEach((element) {
                    if(element.data['uid'] == widget.userData['user']['uid']){
                      Firestore.instance.collection('id_data').document(element.documentID)
                          .delete().then((value) {


                        Firestore.instance.collection('main_data').document(widget.userData['companyUid'])
                            .collection('main_collection').document(widget.userData['docID']).delete().then((value) {

                          showTopSnackBar(
                            context,
                            CustomSnackBar.info(
                              message:
                              '팀콜 연결 끊기',
                            ),
                          );
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NotLoggedIn()), (route) => false);
                        });
                      });
                    }
                  });
                });
              }

              delete_bookmark();
              Future.delayed(Duration(milliseconds:2400), () => delete_doc());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child:
                  Row(
                    children: [
                      Icon(Icons.cancel,color:Colors.red),
                      SizedBox(width: 7),
                      Text("팀콜 연결 끊기",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,size: 17,),
                      SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 17,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget recent() {
    return Container();
  }

  Widget myInfoDetail() {
    return InkWell(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (BuildContext context) =>
                Root()), (route) => false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(10,23),
                blurRadius: 40,
                color: Colors.black12,
              ),
            ],
          ),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child:
                Row(
                  children: [
                    Text("로그아웃",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios,size: 17,),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  String numberWithComma(param){
    var phoneNum;
    if(param.length != 11){
      phoneNum=param;
    }else{
      phoneNum=  param.substring(0, 3) + "-" + param.substring(3, 7)+ "-" + param.substring(7, 11);
    }



    return phoneNum;
  }

  Widget opacityLine (){
    return Opacity(
        opacity: 0.15,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 1.0),
            child: Container(
              height: 1,
              color: Colors.black38,
            )));

  }



}

