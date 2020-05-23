import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/provider/AdsCounter.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
<<<<<<< HEAD
import 'package:scrap/services/auth.dart';
import 'package:scrap/widget/announce.dart';
import 'package:scrap/widget/dialog/WatchVideoDialog.dart';
import 'package:scrap/widget/showdialogfinishpaper.dart';
import 'package:scrap/widget/showdialogreport.dart';
import 'package:scrap/widget/showdialogblock.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/burnt.dart';
import 'package:scrap/widget/notburnt.dart';
import 'package:scrap/widget/showcontract.dart';
import 'package:scrap/widget/peoplethrowpaper.dart';
import 'package:scrap/widget/thrown.dart';
import 'package:scrap/widget/understand.dart';
import 'package:scrap/widget/wrap.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/Page/profile/OptionSetting_My_Profile.dart';
=======
>>>>>>> c54f9665560da9cc8a15d8cb7e3ae3a4d2110279

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdsCounterProvider>.value(
            value: AdsCounterProvider()),
        ChangeNotifierProvider<RealtimeDB>.value(value: RealtimeDB()),
        ChangeNotifierProvider<Report>.value(value: Report()),
        ChangeNotifierProvider<UserData>.value(value: UserData()),
        ChangeNotifierProvider<WriteScrapProvider>.value(
            value: WriteScrapProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Scrap.',
          theme: ThemeData(
              fontFamily: 'ThaiSans', unselectedWidgetColor: Colors.white),
<<<<<<< HEAD
          home: Understand()),
=======
          home: LoginPage()),
>>>>>>> c54f9665560da9cc8a15d8cb7e3ae3a4d2110279
    );
  }
}
