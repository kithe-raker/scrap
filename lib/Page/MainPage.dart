import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scrap/Page/Auth.dart';
import 'package:scrap/Page/Sorry.dart';
import 'package:scrap/Page/Update.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/services/ImgCacheManger.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/services/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin messaging = FlutterLocalNotificationsPlugin();
  JsonConverter jsonConverter = JsonConverter();
  ImgCacheManager imgCacheManager = ImgCacheManager();
  DocumentSnapshot appInfo;
  initLocalMessage() {
    var android = AndroidInitializationSettings('noti_ic');
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
          debugPrint('onLaunch');
          // displayNotification(message);
        },
        onResume: (Map<String, dynamic> message) async {
          debugPrint('onResume');
          // displayNotification(message);
        },
        onBackgroundMessage: Platform.isIOS ? null : Fcm.backgroundHandler);

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  displayNotification(Map message) async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('com.scrap', 'scrap.', 'description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await messaging.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: '',
    );
  }

  Future onTapMessage(String payload) async {
    final uid = await Provider.of(context).auth.currentUser();
    await Firestore.instance.collection('Users').document(uid).get().then(
        (data) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => Profile(doc: data))));
  }

  Future<bool> serverChecker() async {
    bool close;
    await Firestore.instance
        .collection('App')
        .document('info')
        .get()
        .then((doc) {
      close = doc.data['close'];
      appInfo = doc;
    });
    final uid = await Provider.of(context).auth?.currentUser() ?? '';
    return close && uid != 'czKPreN6fqVWJv2RaLSjzhKoAeV2';
  }

  Future<bool> versionChecker() async {
    String recent = '1.0.3', incoming;
    bool isIOS = Platform.isIOS;
    isIOS
        ? incoming = appInfo['versions']['IOS']
        : incoming = appInfo['versions']['androind'];
    final uid = await Provider.of(context).auth?.currentUser() ?? '';
    return recent == incoming || uid == 'czKPreN6fqVWJv2RaLSjzhKoAeV2';
  }

  @override
  void initState() {
    initFirebaseMessaging();
    initLocalMessage();
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
              onSuccess: (data) async {
                await serverChecker()
                    ? navigator(Sorry())
                    : await versionChecker()
                        ? navigator(Authen())
                        : navigator(Update());
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

  navigator(var where) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => where));
  }
}

class Fcm {
  static Future<dynamic> backgroundHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      debugPrint('DatabackgroundHandler');
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      debugPrint('NotibackgroundHandler');
    }

    // Or do other work.
  }
}
