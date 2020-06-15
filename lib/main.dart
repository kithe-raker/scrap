import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/BottomBarItem/FeedScrap.dart';
import 'package:scrap/Page/MainPage.dart';
import 'package:scrap/Page/mainstream.dart';
import 'package:scrap/bloc/FeedBloc.dart';
import 'package:scrap/bloc/TestBloc.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';

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
          // ChangeNotifierProvider<AdsCounterProvider>.value(
          //     value: AdsCounterProvider()),
          ChangeNotifierProvider<RealtimeDB>.value(value: RealtimeDB()),
          ChangeNotifierProvider<Report>.value(value: Report()),
          ChangeNotifierProvider<UserData>.value(value: UserData()),
          ChangeNotifierProvider<WriteScrapProvider>.value(
              value: WriteScrapProvider()),
          StreamProvider<Position>.value(
              value: Geolocator().getPositionStream()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CounterBloc>.value(value: CounterBloc()),
            // BlocProvider<FeedBloc>.value(value: FeedBloc()),
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Scrap.',
              theme: ThemeData(
                  fontFamily: 'ThaiSans', unselectedWidgetColor: Colors.white),
              home: MainStream()),
        ));
  }
}
