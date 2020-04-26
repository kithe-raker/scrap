import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/createworld/PreCreateWorld.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/provider/createWorldProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenProvider>.value(value: AuthenProvider()),
        ChangeNotifierProvider<CreateWorldProvider>.value(
            value: CreateWorldProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Scrap.',
          theme: ThemeData(
              fontFamily: 'ThaiSans', unselectedWidgetColor: Colors.white),
          home: PreCreateWorld()),
    );
  }
}
