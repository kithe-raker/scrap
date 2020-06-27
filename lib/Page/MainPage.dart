import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/Sorry.dart';
import 'package:scrap/Page/Update.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/Page/mainstream.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/OtherCache.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/realtimeDB/ConfigDatabase.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/ImgCacheManger.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/dialog/IntroduceApp.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin messaging = FlutterLocalNotificationsPlugin();
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
    await messaging.show(0, message['notification']['title'],
        message['notification']['body'], platformChannelSpecifics,
        payload: '');
  }

  Future onTapMessage(String payload) async {
    final auth = await FirebaseAuth.instance.currentUser();
    if (auth != null) nav.push(context, MainStream(initPage: 2));
  }

  Future<bool> serverChecker() async {
    bool close;
    var doc = await Firestore.instance.collection('App').document('info').get();
    close = doc.data['close'];
    appInfo = doc;
    return close;
  }

  bool olderVersion() {
    String recent = '2.0.1', incoming;
    bool isIOS = Platform.isIOS;
    isIOS
        ? incoming = appInfo['versions']['ios']
        : incoming = appInfo['versions']['android'];
    return recent != incoming;
  }

  Future<bool> isLogin() async {
    await confgiDB.initRTDB(context);
    final user = Provider.of<UserData>(context, listen: false);
    var auth = await FirebaseAuth.instance.currentUser();
    if (auth != null) user.uid = auth.uid;
    return auth != null && auth?.phoneNumber != null;
  }

  Future<void> multiCaseNavigator() async {
    final user = Provider.of<UserData>(context, listen: false);
    bool fileExist = await userinfo.fileExist();
    var img;
    if (await isLogin()) {
      if (fileExist) {
        var map = await userinfo.readContents();
        user.region = map['region'];
        user.phone = map['phone'];
        img = map['img'];
        if (img == null) {
          await fireAuth.signOut();
          nav.pushReplacement(context, LoginPage());
        } else {
          nav.pushReplacement(context, MainStream());
        }
      } else {
        await fireAuth.signOut();
        nav.pushReplacement(context, LoginPage());
      }
    } else
      navigator(LoginPage());
  }

  Future<void> introduceApp() async {
    if (await cacheOther.isNotIntroduce())
      nav.push(context, IntroduceApp(onDoubleTap: () {
        multiCaseNavigator();
      }));
    else
      multiCaseNavigator();
  }

  @override
  void initState() {
    Admob.initialize(AdmobService().getAdmobAppId());
    FirebaseAdMob.instance.initialize(appId: AdmobService().getAdmobAppId());
    initFirebaseMessaging();
    initLocalMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                child: SplashScreen.callback(
                  name: 'assets/scraplogo.flr',
                  startAnimation: 'Untitled',
                  onSuccess: (data) async {
                    await serverChecker()
                        ? navigator(Sorry())
                        : olderVersion() ? navigator(Update()) : introduceApp();
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: a.width / 21),
                child: Image.asset('assets/whiteBualoi.png',
                    color: Colors.white.withOpacity(0.78),
                    width: a.width / 8.1,
                    fit: BoxFit.contain),
              ),
            )
          ],
        ));
  }

  navigator(var where) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => where));
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
