import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scrap/Page/viewprofile.dart';

class CheckBlockList extends StatefulWidget {
  @override
  _CheckBlockListState createState() => _CheckBlockListState();
}

class _CheckBlockListState extends State<CheckBlockList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
      .collection("Users")
      .document(uid)
      .snapshots()
      ,
      builder: (context, snapshot){
          List<String> blocked = snapshot.data['blockList'];
          if(blocked.contains(uid))
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text("คุณถูกผู้ใช้ดังกล่าวปิดกั้น"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: Text("OK")
                )
            ],
          )
         else
          return //ปากระดาษใส่
      }
      );
  }
}