import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/subjects.dart';
import 'package:provider/provider.dart';
import 'package:scrap/provider/authen_provider.dart';

final fireStore = Firestore.instance;
final fireAuth = FirebaseAuth.instance;
final fbSign = FacebookLogin();
final ggSign = GoogleSignIn();
final twSign = TwitterLogin(
  consumerKey: '',
  consumerSecret: '',
);

class AuthService {
  PublishSubject<bool> load = PublishSubject();
  Stream<FirebaseUser> user = fireAuth.onAuthStateChanged;
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

  Future<void> phoneVerified(String phone, BuildContext context,
      {bool login = false}) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      authenInfo.verificationID = id;
      load.add(false);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => OTPScreen(login: login)));
    };
    final PhoneVerificationCompleted success = (AuthCredential credent) async {
      authenInfo.verificationID != null ? print('use OTP') : print('succese');
    };
    PhoneVerificationFailed failed = (AuthException error) {
      print('error');
    };
    await fireAuth
        .verifyPhoneNumber(
            phoneNumber: '+66' + phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      print('e');
    });
  }

  Future<String> signUpWithPhone(BuildContext context,
      {@required String verificationId,
      @required String smsCode,
      @required String phone,
      @required String region,
      @required String password,
      @required String pName}) async {
    String uid;
    load.add(true);
    var phoneCredent = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    var emailCredent = EmailAuthProvider.getCredential(
        email: phone + '@gmail.com', password: password);
    await fireAuth.signInWithCredential(phoneCredent).then((authResult) async {
      uid = authResult.user?.uid ?? null;
      authResult.user.linkWithCredential(emailCredent);
      await fireStore.collection('Account').document(uid).setData({
        'email': phone + '@gmail.com',
        'password': password,
        'pName': pName,
        'region': region,
        'phone': phone
      });
      print('link fin');
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

  signInWithPhone(BuildContext context,
      {@required String verificationId, @required String smsCode}) async {
    var credent = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    await fireAuth.signInWithCredential(credent).then((value) {
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
  }

  signInWithPenName({@required String email, @required String password}) async {
    await fireAuth.signInWithEmailAndPassword(email: email, password: password);
    load.add(false);
  }

  signOut(BuildContext context) async {
    load.add(true);
    await fireAuth.signOut();
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    load.add(false);
  }

  signInWithFacebook() async {
    load.add(true);
    var fbLogin = await fbSign.logIn(['email', 'public_profile']);
    switch (fbLogin.status) {
      case FacebookLoginStatus.loggedIn:
        var fbCredent = FacebookAuthProvider.getCredential(
            accessToken: fbLogin.accessToken.token);
        await fireAuth.signInWithCredential(fbCredent);
        print('face fin');
        load.add(false);
        break;
      default:
        print('something wrong');
        load.add(false);
        break;
    }
  }

  signInWithTwitter() async {
    load.add(true);
    var user = await twSign.authorize();
    switch (user.status) {
      case TwitterLoginStatus.loggedIn:
        var twCredent = TwitterAuthProvider.getCredential(
            authToken: user.session.token,
            authTokenSecret: user.session.secret);
        await fireAuth.signInWithCredential(twCredent);
        print('twit fin');
        load.add(false);
        break;
      default:
        print('something wrong');
        load.add(false);
        break;
    }
  }

  signInWithGoogle() async {
    load.add(true);
    try {
      GoogleSignInAccount account = await ggSign.signIn();
      GoogleSignInAuthentication user = await account.authentication;
      var ggCredent = GoogleAuthProvider.getCredential(
          idToken: user.idToken, accessToken: user.accessToken);
      await fireAuth.signInWithCredential(ggCredent);
    } catch (e) {
      print(e);
    }
    load.add(false);
  }
}

final authService = AuthService();
