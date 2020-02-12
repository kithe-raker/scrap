import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scrap/Page/HomePage.dart';
import 'package:scrap/Page/LoginPage.dart';
import 'package:scrap/Page/creatProfile.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart';

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
  Position currentLocation;

  @override
  void initState() {
    Geolocator().getCurrentPosition().then((curlo) {
      setState(() {
        currentLocation = curlo;
      });
    });
    super.initState();
  }

  Stream<DocumentSnapshot> userStream(BuildContext context) async* {
    try {
      final uid = await Provider.of(context).auth.currentUser();
      yield* Firestore.instance.collection('Users').document(uid).snapshots();
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
          if (snap.hasData &&
              snap.connectionState == ConnectionState.active &&
              currentLocation != null) {
            return snap.data['id'] == null
                ? CreateProfile(uid: snap.data['uid'])
                : HomePage(
                    doc: snap.data,
                    currentLocation: currentLocation,
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
