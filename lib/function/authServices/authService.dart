import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authenPage/AuthenPage.dart';
import 'package:scrap/Page/authenPage/OTPScreen.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/provider/authen_provider.dart';

import '../../cacheManagement/cache_UserInfo.dart';
import '../../cacheManagement/cache_UserInfo.dart';
import '../../cacheManagement/cache_UserInfo.dart';

final fireStore = Firestore.instance;
final fireAuth = FirebaseAuth.instance;
final fireMess = FirebaseMessaging();

final fbSign = FacebookLogin();
final ggSign = GoogleSignIn();
final twSign = TwitterLogin(
  consumerKey: '',
  consumerSecret: '',
);

class AuthService {


  PublishSubject<bool> load = PublishSubject();

  Future<bool> hasAccount(String key, dynamic value) async {
    var doc = await fireStore
        .collection('Account')
        .where(key, isEqualTo: value)
        .limit(1)
        .getDocuments();
    return doc.documents.length > 0;
  }

  warn(String warning, BuildContext context) {
    load.add(false);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(warning),
                  RaisedButton(
                      child: Text('ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  void navigatorToAuthenPage(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthenPage()));
  }

  Future<void> phoneVerified(BuildContext context,
      {bool register = false}) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      authenInfo.verificationID = id;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(register: register)));
      load.add(false);
    };
    final PhoneVerificationCompleted success = (AuthCredential credent) async {
      authenInfo.verificationID != null ? print('use OTP') : print('succese');
    };
    PhoneVerificationFailed failed = (AuthException error) {
      print('error');
    };
    await fireAuth
        .verifyPhoneNumber(
            phoneNumber: '+66' + authenInfo.phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      load.add(false);
      print('e');
    });
  }

  Future<String> signUpWithPhone(BuildContext context,
      {@required String smsCode}) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    String uid;
    load.add(true);
    var phoneCredent = PhoneAuthProvider.getCredential(
        verificationId: authenInfo.verificationID, smsCode: smsCode);
    var emailCredent = EmailAuthProvider.getCredential(
        email: authenInfo.phone + '@gmail.com', password: authenInfo.password);
    await fireAuth.signInWithCredential(phoneCredent).then((authResult) async {
      var token = await getToken();
      uid = authResult.user?.uid ?? null;
      authResult.user.linkWithCredential(emailCredent);
      await fireStore.collection('Account').document(uid).setData({
        'email': authenInfo.phone + '@gmail.com',
        'password': authenInfo.password,
        'pName': authenInfo.pName,
        'region': authenInfo.region,
        'phone': authenInfo.phone,
        'token': token
      });
      load.add(false);
    }).catchError((e) {
      switch (e.code) {
        case 'ERROR_NETWORK_REQUEST_FAILED':
          warn('ตรวจสอบการเชื่อมต่อ', context);
          break;
        case 'ERROR_INVALID_VERIFICATION_CODE':
          warn('เช็คใหม่', context);
          break;
        default:
          warn('OTPอาจหมดอายุ', context);
          break;
      }
    });
    return uid;
  }

  signInWithPhone(BuildContext context, {@required String smsCode}) async {
    try {
      final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
      load.add(true);
      var credent = PhoneAuthProvider.getCredential(
          verificationId: authenInfo.verificationID, smsCode: smsCode);
      var curUser = await fireAuth.signInWithCredential(credent);
      await updateToken(curUser.user.uid);
      authenInfo.uid = curUser.user.uid;
      CacheUserInfo().userInfo(curUser.user.uid);
      load.add(false);
    } catch (e) {
      print(e.toString());
      switch (e.code) {
        case 'ERROR_NETWORK_REQUEST_FAILED':
          warn('ตรวจสอบการเชื่อมต่อ', context);
          break;
        case 'ERROR_INVALID_VERIFICATION_CODE':
          warn('เช็คใหม่', context);
          break;
        default:
          warn('OTPอาจหมดอายุ', context);
          break;
      }
    }
  }

  signInWithPenName(BuildContext context,
      {@required String penname, @required String password}) async {
    load.add(true);
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    var docs = await Firestore.instance
        .collection('Account')
        .where('pName', isEqualTo: penname)
        .limit(1)
        .getDocuments();
    if (docs.documents.length > 0) {
      var doc = docs.documents[0];
      if (password == doc['password']) {
        var curUser = await fireAuth.signInWithEmailAndPassword(
            email: doc['email'], password: password);
        await updateToken(curUser.user.uid);
        authenInfo.uid = curUser.user.uid;
        CacheUserInfo().userInfo(curUser.user.uid);
        load.add(false);
      } else {
        warn('ตรวจสอบรหัสผ่านของท่าน', context);
      }
    } else {
      warn('ไม่พบบัญชีดังกล่าว', context);
    }
  }

  signOut(BuildContext context) async {
    load.add(true);
    await fireAuth.signOut();
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    load.add(false);
  }

  signInWithFacebook(BuildContext context) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    load.add(true);
    var fbLogin = await fbSign.logIn(['email', 'public_profile']);
    switch (fbLogin.status) {
      case FacebookLoginStatus.loggedIn:
        var fbCredent = FacebookAuthProvider.getCredential(
            accessToken: fbLogin.accessToken.token);
        var curUser = await fireAuth.signInWithCredential(fbCredent);
        await updateToken(curUser.user.uid);
        authenInfo.uid = curUser.user.uid;
        CacheUserInfo().userInfo(curUser.user.uid);
        print('face fin');
        navigatorToAuthenPage(context);
        load.add(false);
        break;
      default:
        print('something wrong');
        load.add(false);
        break;
    }
  }

  signInWithTwitter(BuildContext context) async {
    load.add(true);
    var user = await twSign.authorize();
    switch (user.status) {
      case TwitterLoginStatus.loggedIn:
        var twCredent = TwitterAuthProvider.getCredential(
            authToken: user.session.token,
            authTokenSecret: user.session.secret);
        var curUser = await fireAuth.signInWithCredential(twCredent);
        await updateToken(curUser.user.uid);
        CacheUserInfo().userInfo(curUser.user.uid);
        print('twit fin');
        navigatorToAuthenPage(context);
        load.add(false);
        break;
      default:
        print('something wrong');
        load.add(false);
        break;
    }
  }

  signInWithGoogle(BuildContext context) async {
    load.add(true);
    try {
      GoogleSignInAccount account = await ggSign.signIn();
      GoogleSignInAuthentication user = await account.authentication;
      var ggCredent = GoogleAuthProvider.getCredential(
          idToken: user.idToken, accessToken: user.accessToken);
      var curUser = await fireAuth.signInWithCredential(ggCredent);
      await updateToken(curUser.user.uid);
      CacheUserInfo().userInfo(curUser.user.uid);
      navigatorToAuthenPage(context);
      load.add(false);
    } catch (e) {
      print(e);
      load.add(false);
    }
  }

  Future<String> getuid() async {
    var user = await fireAuth.currentUser();
    return user?.uid ?? '';
  }

  Future<void> updateToken(String uid) async {
    var token = await getToken();
    await Firestore.instance
        .collection('Account')
        .document(uid)
        .setData({'token': token}, merge: true);
  }

  Future<String> getToken() async {
    var token = await fireMess.getToken();
    return token;
  }
}

final authService = AuthService();
