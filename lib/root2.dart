import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'not-logged-in.dart';


class Root2 extends StatefulWidget {
  final FirebaseUser user;

  Root2(this.user);

  @override
  _Root2State createState() => _Root2State();
}

class _Root2State extends State<Root2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(
        stream: Firestore.instance.collection('id_data').where('uid', isEqualTo: widget.user.uid).snapshots(),
        builder: (context, _snapshot) {
          if(!_snapshot.hasData){
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
          }
          else if( _snapshot.data.documents.length == 0){
            return  NotLoggedIn();
          }
          // ignore: missing_return

            return StreamBuilder <QuerySnapshot>(
                stream:  Firestore.instance.collection('main_data').document("${_snapshot.data.documents[0]['companyID']}")
                    .collection('main_collection').where('uid',isEqualTo: "${widget.user.uid}").snapshots(),
                builder: (context, __snapshot) {
                  if(!__snapshot.hasData){
                    return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
                  }
                  else{
                    var userData = {
                      'companyUid' : _snapshot.data.documents[0]['companyID']??11,
                      'user' : __snapshot.data.documents[0],
                      'docID': __snapshot.data.documents[0].documentID,
                    };
                    print("@@@@@@@@@@@@@@@");
                    print(userData['companyUid']);
                    return Home(widget.user, userData);
                  }
                }
            );
        }
    );
  }
}
