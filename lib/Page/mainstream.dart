import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/HomePage.dart';
import 'package:scrap/Page/profile/createProfile1.dart';
import 'package:scrap/function/realtimeDB/ConfigDatabase.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';

class MainStream extends StatefulWidget {
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  Future<DocumentSnapshot> userStream() async {
    final user = Provider.of<UserData>(context, listen: false);
    final auth = await FirebaseAuth.instance.currentUser();
    var uid = auth.uid;
    user.uid = uid;
    return Firestore.instance.collection('Users').document(uid).get();
  }

  @override
  void initState() {
    confgiDB.initRTDB(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: userStream(),
        builder: (context, snap) {
          if (snap.hasData) {
            return snap.data['id'] == null ? CreateProfile1() : HomePage();
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
