import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'Page/Auth.dart';

const String testDevice = "34C215009965F34F";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //this is new branch
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: Auth(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Scrap.',
          theme: ThemeData(
              fontFamily: 'ThaiSans', unselectedWidgetColor: Colors.white),
          home: Authen()),
    );
  }
}
