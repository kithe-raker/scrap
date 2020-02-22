import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scrap/Page/HomePage.dart';
import 'package:scrap/Page/profile/createProfile1.dart';
import 'package:scrap/Page/setting/servicedoc.dart';
import 'package:scrap/services/provider.dart';
import 'package:scrap/widget/Loading.dart';

class MainStream extends StatefulWidget {
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  
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
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: userStream(context),
        builder: (context, snap) {
          if (snap.hasData && snap.connectionState == ConnectionState.active) {
            return snap.data['id'] == null
                ? CreateProfile1(uid: snap.data['uid'])
                : snap?.data['accept'] ?? false
                    ? HomePage(
                        doc: snap.data,
                      )
                    : Servicedoc(
                        regis: true,
                      );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
