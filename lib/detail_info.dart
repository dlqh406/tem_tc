import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_call/home.dart';
import 'package:team_call/root2.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailInfo extends StatefulWidget {

  int stateValue;
  int accessValue;
  final FirebaseUser user;
  var userData;
  var doc;
  DetailInfo(this.user,this.userData,this.doc);


  @override
  _DetailInfoState createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  final myControllerName = TextEditingController();
  final myControllerPosition = TextEditingController();
  final myControllerGroup0 = TextEditingController();
  final myControllerGroup1 = TextEditingController();
  final myControllerGroup2 = TextEditingController();
  final myControllerPhoneNumber = TextEditingController();
  final myControllerLandlineNum = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print( widget.doc.documentID);
    if (widget.doc['state'] == true) {
      setState(() {
        widget.stateValue = 1;
      });
    } else if (widget.doc['state'] == false) {
      setState(() {
        widget.stateValue = 2;
      });
    }
    if (widget.doc['access'] == 'super') {
      setState(() {
        widget.accessValue = 1;
      });
    } else if (widget.doc['access'] == 'manager') {
      setState(() {
        widget.accessValue = 2;
      });
    } else {
      setState(() {
        widget.accessValue = 3;
      });
    }


    myControllerName.text = widget.doc['name'];
    myControllerPosition.text = widget.doc['position'];
    myControllerGroup0.text = widget.doc['group'];
    myControllerGroup1.text = widget.doc['department'];
    myControllerGroup2.text = widget.doc['team'];
    myControllerPhoneNumber.text = numberWithComma(widget.doc['phoneNumber']);
    myControllerLandlineNum.text = numberWithLandline(widget.doc['landlineNum']);


    super.initState();
  }

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
              padding: const EdgeInsets.only(left: 0.0),
              child: Container(
                child: GestureDetector(
                    child: Icon(Icons.arrow_back_ios, size: 18,),

                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    }),
              ),
            ),
            actions: [
              Row(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: StreamBuilder(
                        stream: Firestore.instance.collection('main_data')
                            .document("${widget.userData['companyUid']}")
                            .collection('main_collection').document(
                            '${widget.userData['user'].documentID}')
                            .collection('bookmark').where(
                            'docID', isEqualTo: widget.doc.documentID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          var bookmarkState = false;
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white)));
                          }

                          if (snapshot.data.documents.length == 0) {
                            bookmarkState = false;
                          } else {
                            bookmarkState = true;
                          }
                          return IconButton(onPressed: () {
                            if (bookmarkState) {
                              bookmarkState = false;
                              Firestore.instance
                                  .collection('main_data')
                                  .document(widget.userData['companyUid'])
                                  .collection('main_collection')
                                  .document(widget.userData['user'].documentID)
                                  .collection('bookmark')
                                  .getDocuments().then((value) {
                                value.documents.forEach((element) {
                                  if (element.data['docID'] ==
                                      widget.doc.documentID) {
                                    Firestore.instance
                                        .collection('main_data')
                                        .document(widget.userData['companyUid'])
                                        .collection('main_collection')
                                        .document(
                                        widget.userData['user'].documentID)
                                        .collection('bookmark')
                                        .document(element.documentID)
                                        .delete();
                                  }
                                });
                              });
                            }
                            else {
                              bookmarkState = true;
                              var data = {
                                'docID': widget.doc.documentID,
                                'date': new DateTime.now(),
                              };

                              Firestore.instance
                                  .collection('main_data')
                                  .document(widget.userData['companyUid'])
                                  .collection('main_collection')
                                  .document(widget.userData['user'].documentID)
                                  .collection('bookmark')
                                  .add(data);
                            }
                          },

                              icon: bookmarkState ? Icon(
                                  Icons.star, size: 30, color: _getColorFromHex(
                                  '051841'))
                                  : Icon(Icons.star_border, size: 30,
                                color: _getColorFromHex('051841'),)

                          );
                        }
                    ),
                  ),

                  Visibility(
                    visible: widget.userData['user']['access'] == 'super' ||
                        widget.userData['user']['access'] == 'manager' ||
                        widget.userData['docID'] == widget.doc.documentID,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                          color: _getColorFromHex('051841'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            var access;
                            var state;

                            if (widget.accessValue == 1) {
                              access = 'super';
                            } else if (widget.accessValue == 2) {
                              access = 'manager';
                            } else {
                              access = 'normal';
                            }

                            if (widget.stateValue == 1) {
                              state = true;
                            } else if (widget.stateValue == 2) {
                              state = false;
                            } else {
                              state = 'delete';
                            }


                            if (state == true || state == false) {
                              var data = {
                                'state': state,
                                'access': access,
                                'name': myControllerName.text,
                                'position': myControllerPosition.text,
                                'group': myControllerGroup0.text,
                                'department': myControllerGroup1.text,
                                'team': myControllerGroup2.text,
                                'phoneNumber': myControllerPhoneNumber.text.replaceAll(RegExp(r'[^0-9]'),"").replaceAll(' ', ''),
                                'landlineNum': myControllerLandlineNum.text.replaceAll(RegExp(r'[^0-9]'),"").replaceAll(' ', '')
                              };
                              // 댓글 추가
                              Firestore.instance
                                  .collection('main_data')
                                  .document(widget.userData['companyUid'])
                                  .collection('main_collection')
                                  .document(widget.doc.documentID)
                                  .updateData(data).then((value) {
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.info(
                                    message:
                                    '변경이 완료되었습니다',
                                  ),
                                );
                              });
                              if (widget.userData['docID'] == widget.doc.documentID) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        Root2(widget.user)
                                    ));
                              }
                            }
                            //계정 삭제
                            if (state == 'delete') {

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
                                            Text('계정 삭제중', style: TextStyle(
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
                                        print('element1');
                                        print( element1.documentID);
                                        if (element1.data['docID'] == widget.doc.documentID) {

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
                                Firestore.instance
                                    .collection('main_data')
                                    .document(
                                    widget.userData['companyUid'])
                                    .collection('main_collection')
                                    .document(widget.doc.documentID)
                                    .delete().then((value) {
                                  if(widget.doc['uid'] != "" || widget.doc['uid'] != null ){
                                    Firestore.instance
                                        .collection('id_data')
                                        .document(widget.doc['uid'])
                                        .delete().then((value){
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Home(widget.user, widget.userData)), (route) => false);
                                    });
                                  }
                                });
                              }

                              delete_bookmark();
                              Future.delayed(Duration(milliseconds:2400), () => delete_doc());

                            }
                          },
                          child:
                          Text('변경 정보 저장하기', style: TextStyle(fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                    ),
                  ),

                ],
              ),


            ],

          )),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
      child: ListView(
        children: [
          Visibility(
            visible: widget.userData['user']['access'] == 'super' ||
                widget.userData['user']['access'] == 'manager',
            child: Row(
              children: [
                Text('계정 상태'),
                Visibility(
                  visible: widget.userData['user']['access'] == 'super' || widget.userData['user']['access'] == 'manager',
                  child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child:
                      widget.userData['user']['access'] == 'super'?
                      Container(
                        child: DropdownButton(

                            value: widget.stateValue,
                            items: [
                              DropdownMenuItem(
                                child: Text("활성", style: TextStyle(
                                    fontWeight: FontWeight.bold),),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("비활성", style: TextStyle(
                                    fontWeight: FontWeight.bold),),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                child: Text("계정 삭제", style: TextStyle(
                                    fontWeight: FontWeight.bold),),
                                value: 3,
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                widget.stateValue = value;
                              });
                            }
                        ),
                      )
                          :Container(
                        child: DropdownButton(

                            value: widget.stateValue,
                            items: [
                              DropdownMenuItem(
                                child: Text("활성", style: TextStyle(
                                    fontWeight: FontWeight.bold),),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("비활성", style: TextStyle(
                                    fontWeight: FontWeight.bold),),
                                value: 2,
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                widget.stateValue = value;
                              });
                            }
                        ),
                      )

                  ),
                ),
                // Visibility(
                //   visible: widget.userData['user']['access'] == 'manager',
                //   child: Padding(
                //       padding: const EdgeInsets.only(left: 18.0),
                //       child:
                //       Container(
                //         child: DropdownButton(
                //             value: widget.stateValue,
                //             items: [
                //               DropdownMenuItem(
                //                 child: Text("활성", style: TextStyle(
                //                     fontWeight: FontWeight.bold),),
                //                 value: 1,
                //               ),
                //               DropdownMenuItem(
                //                 child: Text("비활성", style: TextStyle(
                //                     fontWeight: FontWeight.bold),),
                //                 value: 2,
                //               ),
                //
                //             ],
                //             onChanged: (value) {
                //               setState(() {
                //                 widget.stateValue = value;
                //               });
                //             }
                //         ),
                //       )
                //
                //   ),
                // ),
                Spacer(),
                Visibility(
                  visible: widget.userData['user']['access'] == 'super',
                  child: Row(
                    children: [
                      Text('권한'),
                      Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child:

                          Container(
                            child: DropdownButton(
                                value: widget.accessValue,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("슈퍼", style: TextStyle(
                                        fontWeight: FontWeight.bold),),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("매니저", style: TextStyle(
                                        fontWeight: FontWeight.bold),),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("일반", style: TextStyle(
                                        fontWeight: FontWeight.bold),),
                                    value: 3,
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    widget.accessValue = value;
                                  });
                                }
                            ),
                          )
                      ),
                    ],
                  ),
                ),

                // ignore: deprecated_member_use

              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text('이름'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              enabled: widget.userData['user']['access'] == 'super' ||
                  widget.userData['user']['access'] == 'manager'
                  || widget.userData['docID'] == widget.doc.documentID,
              controller: myControllerName,
              decoration: new InputDecoration(
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
          Text('직급/직책'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              enabled: widget.userData['user']['access'] == 'super' ||
                  widget.userData['user']['access'] == 'manager' ||
                  widget.userData['docID'] == widget.doc.documentID,

              controller: myControllerPosition,
              decoration: new InputDecoration(
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
          Text('소속1(회사/사업부)'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              enabled: widget.userData['user']['access'] == 'super' ||
                  widget.userData['user']['access'] == 'manager' ||
                  widget.userData['docID'] == widget.doc.documentID,
              controller: myControllerGroup0,
              decoration: new InputDecoration(
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
          Text('소속2(조직)'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              enabled: widget.userData['user']['access'] == 'super' ||
                  widget.userData['user']['access'] == 'manager' ||
                  widget.userData['docID'] == widget.doc.documentID,
              controller: myControllerGroup1,
              decoration: new InputDecoration(
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
          Text('소속3(부서)'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              enabled: widget.userData['user']['access'] == 'super' ||
                  widget.userData['user']['access'] == 'manager' ||
                  widget.userData['docID'] == widget.doc.documentID,
              controller: myControllerGroup2,
              decoration: new InputDecoration(
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
          Row(
            children: [
              Text('핸드폰'),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        new ClipboardData(text: myControllerPhoneNumber.text));
                    showTopSnackBar(
                      context,
                      CustomSnackBar.info(
                        message:
                        '${myControllerPhoneNumber.text} 복사됨',
                      ),
                    );
                  },
                  child: Icon(Icons.copy))
            ],
          ),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              enabled: widget.userData['user']['access'] == 'super' ||
                  widget.userData['user']['access'] == 'manager' ||
                  widget.userData['docID'] == widget.doc.documentID,
              keyboardType: TextInputType.number,
              // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: myControllerPhoneNumber,
              decoration: new InputDecoration(
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
          // SelectableText
          Row(
            children: [
              Text('유선번호'),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        new ClipboardData(text: myControllerLandlineNum.text));

                    showTopSnackBar(
                      context,
                      CustomSnackBar.info(
                        message:
                        '${myControllerLandlineNum.text} 복사됨',
                      ),
                    );
                  },
                  child: Icon(Icons.copy))

            ],
          ),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              enabled: widget.userData['user']['access'] == 'super' ||
                  widget.userData['user']['access'] == 'manager' ||
                  widget.userData['docID'] == widget.doc.documentID,
              keyboardType: TextInputType.number,
              controller: myControllerLandlineNum,
              decoration: new InputDecoration(
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


        ],
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

  String numberWithComma(param) {
    var phoneNum;
    if (param.length != 11) {
      phoneNum = param;
    } else {
      phoneNum = param.substring(0, 3) + "-" + param.substring(3, 7) + "-" +
          param.substring(7, 11);
    }

    return phoneNum;
  }
    String numberWithLandline(param) {
    print(param.length);
      var phoneNum=param;
      if( param.length  <=8  || param.length >= 12){
        phoneNum = param;
      }
      else if (param[1] == "2") {
        if (param.length == 9) {
          //02-000-0000
          phoneNum = param.substring(0, 2) + "-" + param.substring(2, 5) + "-" +
              param.substring(5, 9);
        } else {
          //02-0000-0000
          phoneNum = param.substring(0, 2) + "-" + param.substring(2, 6) + "-" +
              param.substring(6, 10);
        }
      }
      else if(param.length== 10 ||param.length == 11) {
        if(param.length == 10){

          phoneNum = param.substring(0, 3) + "-" + param.substring(3, 6) + "-" +
              param.substring(6, 10);
        }
        else  {
          phoneNum = param.substring(0, 3) + "-" + param.substring(3, 7) + "-" +
              param.substring(7, 11);
        }
      }

      return phoneNum;
    }

    snackBar(text) {
      return
        scaffoldKey.currentState.showSnackBar(
            SnackBar(duration: const Duration(seconds: 1),
                content:
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.blueAccent,),
                      SizedBox(width: 14,),
                      Text("${text}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),),
                    ],
                  ),
                )));
    }

}