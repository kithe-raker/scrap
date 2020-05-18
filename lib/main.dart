import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/GridFollowing.dart';
import 'package:scrap/Page/GridTopScrap.dart';
import 'package:scrap/Page/Gridfavorite.dart';
import 'package:scrap/Page/Gridsubscripe.dart';
import 'package:scrap/Page/MainPage.dart';
import 'package:scrap/Page/GridFollowing.dart';

import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/provider/AdsCounter.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart' as prov;
import 'package:scrap/widget/personcard.dart';

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
            value: AdsCounterProvider())
      ],
      child: prov.Provider(
        auth: Auth(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Scrap.',
            theme: ThemeData(
                fontFamily: 'ThaiSans', unselectedWidgetColor: Colors.white),
            home: Subpeople()),
      ),
    );
  }
}
