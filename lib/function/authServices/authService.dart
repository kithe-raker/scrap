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
import 'package:scrap/Page/authenPage/OTPScreen.dart';
import 'package:scrap/Page/profile/createProfile1.dart';
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

  void navigatorReplace(BuildContext context, var where) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => where));
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

  Future signUpWithPhone(BuildContext context,
      {@required String smsCode}) async {
    try {
      final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
      load.add(true);
      var phoneCredent = PhoneAuthProvider.getCredential(
          verificationId: authenInfo.verificationID, smsCode: smsCode);
      await fireAuth.signInWithCredential(phoneCredent);
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
      await updateToken(curUser.user.uid);
      navigatorReplace(context, AuthenPage());
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
        await updateToken(curUser.user.uid);
        navigatorReplace(context, AuthenPage());
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

  authenWithFacebook(BuildContext context, {bool signUp = false}) async {
    load.add(true);
    var fbLogin = await fbSign.logIn(['email', 'public_profile']);
    switch (fbLogin.status) {
      case FacebookLoginStatus.loggedIn:
        var fbCredent = FacebookAuthProvider.getCredential(
            accessToken: fbLogin.accessToken.token);
        var curUser = await fireAuth.signInWithCredential(fbCredent);
        signUp
            ? navigatorReplace(context, 'somewhere')
            : await updateToken(curUser.user.uid);
        if (!signUp) navigatorReplace(context, AuthenPage());
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
        signUp
            ? navigatorReplace(context, 'somewhere')
            : await updateToken(curUser.user.uid);
        print('twit fin');
        if (!signUp) navigatorReplace(context, AuthenPage());
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
      // signUp
      //     ? navigatorReplace(context, 'somewhere')
      //     : await updateToken(curUser.user.uid);
      // if (!signUp) navigatorReplace(context, AuthenPage());
      load.add(false);
    } catch (e) {
      print(e);
      load.add(false);
    }
  }

// ทำหน้าสร้างprofileโดยเช็คtypeรูปว่าเป็นString?ถ้าใช่ก็ไม่ต้องupload;
// ให้ function authen check เจอข้อมูลมั้ยถ้าไม่ก็ให้สร้างprofile
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
    batch.setData(accRef, {
      'email': uid + '@gmail.com',
      'password': authenInfo.password,
      'pName': authenInfo.pName,
      'region': authenInfo.region,
      'phone': authenInfo.phone,
      'token': token
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
    );
    batch.commit();
    var emailCredent = EmailAuthProvider.getCredential(
        email: uid + '@gmail.com', password: authenInfo.password);
    user.linkWithCredential(emailCredent);
  }
}

final authService = AuthService();
