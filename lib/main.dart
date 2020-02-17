import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap/Page/profile/createProfile2.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/Page/setting/FeedbackPage.dart';
import 'package:scrap/Page/signup/SignUpMail.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart';
import 'package:scrap/Page/MainPage.dart';
import 'package:scrap/Page/HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: Auth(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Scrap.',
          theme: ThemeData(fontFamily: 'ThaiSans' ,  unselectedWidgetColor:Colors.white),
          home: MainPage()),
    );
  }
}
