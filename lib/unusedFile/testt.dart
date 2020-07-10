import 'package:flutter/material.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/realtimeDB/ConfigDatabase.dart';
import 'package:scrap/function/toDatabase/scrap.dart';

class TestT extends StatefulWidget {
  @override
  _TestTState createState() => _TestTState();
}

class _TestTState extends State<TestT> {
  @override
  void initState() {
    confgiDB.initRTDB(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
              child: RaisedButton(
            onPressed: () async {
              var scraps =
                  await fireStore.collectionGroup('history').getDocuments();
              await rtdb
                  .child('scrap-app')
                  .update({'allScrap': scraps.documents.length});
              print('fin');
              // authService.signOut(context);
            },
            child: Text('data'),
          ))),
    );
  }
}
