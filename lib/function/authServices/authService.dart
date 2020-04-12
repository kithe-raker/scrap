import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/subjects.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authenPage/AuthenPage.dart';
import 'package:scrap/Page/profile/createProfile1.dart';
import 'package:scrap/function/cacheManager/cache_UserInfo.dart';
import 'package:scrap/provider/authen_provider.dart';

final fireStore = Firestore.instance;
final fireAuth = FirebaseAuth.instance;
final fireMess = FirebaseMessaging();

final fbSign = FacebookLogin();
final ggSign = GoogleSignIn();
final twSign = TwitterLogin(
  consumerKey: '',
  consumerSecret: '',
);

final cacheUser = CacheUserInfo();

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

  Future<String> getRegion(String uid) async {
    var doc = await fireStore.collection('Account').document(uid).get();
    return doc?.data['region'] ?? '';
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

  void navigatorReplace(BuildContext context, var where) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => where));
  }

  Future<void> phoneValidator(BuildContext context,
      {bool login = false}) async {
    load.add(true);
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    var docs = await Firestore.instance
        .collection('Account')
        .where('phone', isEqualTo: authenInfo.phone)
        .limit(1)
        .getDocuments();
    if (docs.documents.length > 0) {
      login
          ? phoneVerified(context, region: docs.documents[0]['region'])
          : warn('บัญชีดังกล่าวลงทะเบียนไว้แล้ว', context);
    } else {
      login ? warn('ไม่พบบัญชีดังกล่าว', context) : phoneVerified(context);
    }
  }

  Future<void> phoneVerified(BuildContext context, {String region}) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    authenInfo.region = region;
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {};
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      authenInfo.verificationID = id;
      load.add(false);
    };
    final PhoneVerificationCompleted success = (AuthCredential credent) async {
      authenInfo.verificationID != null ? print('use OTP') : print('succese');
    };
    PhoneVerificationFailed failed = (AuthException error) {
      warn('เกิดข้อผิดพลาดกรุณาลองใหม่', context);
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
      warn('เกิดข้อผิดพลาดกรุณาลองใหม่', context);
    });
  }

  Future signUpWithPhone(BuildContext context,
      {@required String smsCode}) async {
    try {
      final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
      load.add(true);
      var phoneCredent = PhoneAuthProvider.getCredential(
          verificationId: authenInfo.verificationID, smsCode: smsCode);
      var curUser = await fireAuth.signInWithCredential(phoneCredent);
      await fireStore
          .collection('Account')
          .document(curUser.user.uid)
          .setData({'phone': authenInfo.phone}, merge: true);
      navigatorReplace(context, CreateProfile1());
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

  signInWithPhone(BuildContext context, {@required String smsCode}) async {
    try {
      final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
      load.add(true);
      var credent = PhoneAuthProvider.getCredential(
          verificationId: authenInfo.verificationID, smsCode: smsCode);
      var curUser = await fireAuth.signInWithCredential(credent);
      var uid = curUser.user.uid;
      await updateToken(uid);

      if (await cacheUser.docExistsThenNewFile(uid, context,
          region: authenInfo?.region ?? null))
        navigatorReplace(context, AuthenPage());
      else
        navigatorReplace(context, CreateProfile1());

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
        var uid = curUser.user.uid;
        await updateToken(uid);

        if (await cacheUser.docExistsThenNewFile(uid, context,
            region: doc?.data['region'] ?? null))
          navigatorReplace(context, AuthenPage());
        else
          navigatorReplace(context, CreateProfile1());

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
    navigatorReplace(context, AuthenPage());
    load.add(false);
  }

  authenWithFacebook(BuildContext context) async {
    load.add(true);
    var fbLogin = await fbSign.logIn(['email', 'public_profile']);
    switch (fbLogin.status) {
      case FacebookLoginStatus.loggedIn:
        var fbCredent = FacebookAuthProvider.getCredential(
            accessToken: fbLogin.accessToken.token);
        var curUser = await fireAuth.signInWithCredential(fbCredent);
        var uid = curUser.user.uid;
        await updateToken(uid);

        if (await cacheUser.docExistsThenNewFile(uid, context))
          navigatorReplace(context, AuthenPage());
        else
          navigatorReplace(context, CreateProfile1());

        load.add(false);
        break;
      default:
        print('something wrong');
        load.add(false);
        break;
    }
  }

  authenWithTwitter(BuildContext context, {bool signUp = false}) async {
    load.add(true);
    var user = await twSign.authorize();
    switch (user.status) {
      case TwitterLoginStatus.loggedIn:
        var twCredent = TwitterAuthProvider.getCredential(
            authToken: user.session.token,
            authTokenSecret: user.session.secret);
        var curUser = await fireAuth.signInWithCredential(twCredent);
        var uid = curUser.user.uid;
        await updateToken(uid);

        if (await cacheUser.docExistsThenNewFile(uid, context))
          navigatorReplace(context, AuthenPage());
        else
          navigatorReplace(context, CreateProfile1());

        load.add(false);
        break;
      default:
        print('something wrong');
        load.add(false);
        break;
    }
  }

  authenWithGoogle(BuildContext context) async {
    load.add(true);
    try {
      GoogleSignInAccount account = await ggSign.signIn();
      GoogleSignInAuthentication user = await account.authentication;
      var ggCredent = GoogleAuthProvider.getCredential(
          idToken: user.idToken, accessToken: user.accessToken);
      var curUser = await fireAuth.signInWithCredential(ggCredent);
      var uid = curUser.user.uid;
      await updateToken(curUser.user.uid);

      if (await cacheUser.docExistsThenNewFile(uid, context))
        navigatorReplace(context, AuthenPage());
      else
        navigatorReplace(context, CreateProfile1());

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

  Future<void> setAccount(BuildContext context) async {
    var token = await getToken();
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    var user = await fireAuth.currentUser();
    String uid = user.uid;
    var accRef = fireStore.collection('Account').document(uid);
    var userRef = fireStore
        .collection('User')
        .document(authenInfo.region)
        .collection('users')
        .document(uid);
    var batch = fireStore.batch();
    batch.setData(
        accRef,
        user?.email == null
            ? {
                'email': uid + '@gmail.com',
                'password': authenInfo.password,
                'pName': authenInfo.pName,
                'region': authenInfo.region,
                'token': token,
              }
            : {
                'email': user.email,
                'password': authenInfo.password,
                'pName': authenInfo.pName,
                'region': authenInfo.region,
                'token': token,
              });
    batch.setData(
        userRef,
        {
          'pName': authenInfo.pName,
          'region': authenInfo.region,
          'birthday': authenInfo.birthday,
          'gender': authenInfo.gender,
          'created': FieldValue.serverTimestamp(),
        },
        merge: true);
    cacheUser.newFileUserInfo(uid, context, info: {
      "uid": uid,
      "img": authenInfo.img,
      'pName': authenInfo.pName,
      'region': authenInfo.region,
      'birthday': authenInfo.birthday.toString(),
      'gender': authenInfo.gender,
    });
    await batch.commit();
    if (user?.email == null) {
      var emailCredent = EmailAuthProvider.getCredential(
          email: uid + '@gmail.com', password: authenInfo.password);
      user.linkWithCredential(emailCredent);
    }
    print('set fin');
  }
}

final authService = AuthService();
