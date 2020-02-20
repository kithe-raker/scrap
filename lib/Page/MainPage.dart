import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'Auth.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
        color: Colors.black,
        child: InkWell(
          child: Container(
            width: a.width / 2,
            height: a.width / 5,
            child: SplashScreen.callback(
              name: 'assets/splash.flr',
              startAnimation: 'Untitled',
              onSuccess: (data) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Authen(),
                    ));
              },
              loopAnimation: '1',
              until: () => Future.delayed(Duration(seconds: 1)),
              endAnimation: '0',
              onError: (e, er) {
                print(e);
                print(er);
              },
            ),
          ),
        ));
  }
}
