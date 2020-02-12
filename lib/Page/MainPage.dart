import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/LoginPage.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart';

import 'HomePage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: InkWell(
        child: Container(
          child: Center(
              child: Image.asset(
            './assets/SCRAP.png',
            width: a.width / 2,
          )),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Authen()));
        },
      ),
    );
  }
}

class Authen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return MainStream();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class MainStream extends StatefulWidget {
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  Stream<DocumentSnapshot> userStream(BuildContext context) async* {
    try {
      final uid = await Provider.of(context).auth.currentUser();
      yield* Firestore.instance.collection('users').document(uid).snapshots();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: userStream(context),
        builder: (context, snap) {
          if (snap.hasData && snap.connectionState == ConnectionState.active) {
            return HomePage(
              doc: snap.data,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
