import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scrap/Page/HomePage.dart';
import 'package:scrap/Page/LoginPage.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/Page/profile/createProfile1.dart';
import 'package:scrap/Page/setting/servicedoc.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart';
import 'package:scrap/widget/Loading.dart';

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
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin messaging = FlutterLocalNotificationsPlugin();

  initLocalMessage() {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initMessaging = InitializationSettings(android, ios);
    messaging.initialize(initMessaging, onSelectNotification: onTapMessage);
  }

  void initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        displayNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        displayNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        displayNotification(message);
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  displayNotification(Map message) async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('com.scrap', 'scrap.', 'description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await messaging.show(0, message['notification']['title'],
        message['notification']['body'], platformChannelSpecifics,
        payload: '');
  }

  Future onTapMessage(String payload) async {
    final uid = await Provider.of(context).auth.currentUser();
    await Firestore.instance.collection('Users').document(uid).get().then(
        (data) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => Profile(doc: data))));
  }

  @override
  void initState() {
    initFirebaseMessaging();
    initLocalMessage();
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
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: userStream(context),
        builder: (context, snap) {
          if (snap.hasData &&
              snap.connectionState == ConnectionState.active &&
              currentLocation != null) {
            return snap.data['id'] == null
                ? CreateProfile1(uid: snap.data['uid'])
                : snap?.data['accept'] ?? false
                    ? HomePage(
                        doc: snap.data,
                        currentLocation: currentLocation,
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
