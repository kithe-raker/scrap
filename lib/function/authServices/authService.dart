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
import 'package:scrap/Page/authentication/PennameWithPassword.dart';
import 'package:scrap/Page/authentication/PhoneWithOTP.dart';
import 'package:scrap/Page/authentication/not_registered/CreateProfile1.dart';
import 'package:scrap/function/cacheManager/cache_UserInfo.dart';
import 'package:scrap/function/others/resizeImage.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/provider/authen_provider.dart';

final fireStore = Firestore.instance;
final fireAuth = FirebaseAuth.instance;
final fireMess = FirebaseMessaging();
final nav = Nav();

final fbSign = FacebookLogin();
final ggSign = GoogleSignIn();
final twSign = TwitterLogin(
  consumerKey: '',
  consumerSecret: '',
);

final cacheUser = CacheUserInfo();

class AuthService {
  ///[load] is varieble that use for tell the widget whether
  ///current function is in process or not
  PublishSubject<bool> load = PublishSubject();

  ///For check Accoubt in database whether in [key] has [value] or not
  Future<bool> hasAccount(String key, dynamic value) async {
    var doc = await fireStore
        .collection('Account')
        .where(key, isEqualTo: value)
        .limit(1)
        .getDocuments();
    return doc.documents.length > 0;
  }

  ///Get multi documents by pass [key] and [value]
  ///
  ///this will return as [QuerySnapshot]
  Future<QuerySnapshot> getDocuments(String key, dynamic value) async {
    var doc = await fireStore
        .collection('Account')
        .where(key, isEqualTo: value)
        .limit(1)
        .getDocuments();
    return doc;
  }

  ///get user region by [uid] if null return empty String
  Future<String> getRegion(String uid) async {
    var doc = await fireStore.collection('Account').document(uid).get();
    return doc?.data['region'] ?? '';
  }

  ///warning dialog auto set [load] to false ,When was called
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

  ///shortcut for [Navigator.pushReplacement] by pass Class is [where]
  void navigatorReplace(BuildContext context, var where) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => where));
  }

  ///Validator for seperate whether where should lead user to ,
  ///By pass [value] and [withPhone] whether user authentication with phone or not
  ///
  ///[withPhone] default is false
  Future<void> validator(BuildContext context, String value,
      {bool withPhone = false}) async {
    load.add(true);
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    var doc =
        await authService.getDocuments(withPhone ? 'phone' : 'pName', value);
    if (doc.documents.length > 0) {
      var accDoc = doc.documents[0];
      authenInfo.email = accDoc['email'];
      authenInfo.password = accDoc['password'];
      authenInfo.region = accDoc['region'] ?? '';
      nav.push(context, withPhone ? PhoneWithOTP() : PennameLogin());
      load.add(false);
    } else if (withPhone) {
      nav.push(context, PhoneWithOTP(register: true));
      load.add(false);
    } else {
      warn('ไม่พบบัญชีดังกล่าว', context);
    }
  }

  ///Send OTP code for verified phone number
  ///[region] use for check country phone code of user
  ///you can pass region to [region] if provider doesn't work well
  Future<void> phoneVerified(BuildContext context) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
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

  ///Sign user up with phone number and requied [smsCode] or OTP code
  ///use for verified phone number Then this will lead user to [CreateProfile1] immediately
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

  ///Sign user in with phone number and requied [smsCode] or OTP code
  ///get user data then store to cache ,after that lead to [AuthenPage]
  ///if user's data doesn't exist lead to [CreateProfile1] immediately
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

  ///Sign user in with [penname] and required [password]
  ///get user data then store to cache ,after that lead to [AuthenPage]
  ///if user's data doesn't exist lead to [CreateProfile1] immediately
  signInWithPassword(BuildContext context, {@required String password}) async {
    load.add(true);
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    if (password == authenInfo.password) {
      var curUser = await fireAuth.signInWithEmailAndPassword(
          email: authenInfo.email, password: password);
      var uid = curUser.user.uid;
      await updateToken(uid);

      if (await cacheUser.docExistsThenNewFile(uid, context,
          region: authenInfo?.region ?? null))
        navigatorReplace(context, AuthenPage());
      else
        navigatorReplace(context, CreateProfile1());

      load.add(false);
    } else {
      warn('ตรวจสอบรหัสผ่านของคุณ', context);
    }
  }

  ///sign current user out then laed to [AuthenPage]
  signOut(BuildContext context) async {
    load.add(true);
    await fireAuth.signOut();
    navigatorReplace(context, AuthenPage());
    load.add(false);
  }

  ///Sign user in with facebook aacount
  ///get user data then store to cache ,after that lead to [AuthenPage]
  ///if user's data doesn't exist lead to [CreateProfile1] immediately
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

  ///Sign user in with twitter aacount
  ///get user data then store to cache ,after that lead to [AuthenPage]
  ///if user's data doesn't exist lead to [CreateProfile1] immediately
  authenWithTwitter(BuildContext context) async {
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

  ///Sign user in with google aacount
  ///get user data then store to cache ,after that lead to [AuthenPage]
  ///if user's data doesn't exist lead to [CreateProfile1] immediately
  authenWithGoogle(BuildContext context) async {
    try {
      load.add(true);
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

  ///get current user an uid if [null] return empty String
  Future<String> getuid() async {
    var user = await fireAuth.currentUser();
    return user?.uid ?? '';
  }

  ///Update current user token required [uid]
  ///[token] use for send notification to user
  Future<void> updateToken(String uid) async {
    var token = await getToken();
    await Firestore.instance
        .collection('Account')
        .document(uid)
        .setData({'token': token}, merge: true);
  }

  ///Get application token by [fireMess] library
  ///[token] use for send notification to user
  Future<String> getToken() async {
    var token = await fireMess.getToken();
    return token;
  }

  ///Set up user account in data base after user has Sign up
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
    if (authenInfo.img.runtimeType != String) {
      var resizeImg = await resize.resize(image: authenInfo.img);
      authenInfo.img =
          await resize.uploadImg(img: resizeImg, imageName: uid + '_pro0');
    }
    batch.setData(
        accRef,
        {
          'email': user?.email ?? '$uid@gmail.com',
          'password': authenInfo.password,
          'pName': authenInfo.pName,
          'region': authenInfo.region,
          'token': token,
        },
        merge: true);
    batch.setData(
        userRef,
        {
          'pName': authenInfo.pName,
          'region': authenInfo.region,
          'birthday': authenInfo.birthday,
          'gender': authenInfo.gender,
          'created': FieldValue.serverTimestamp(),
          'img': authenInfo.img,
          'imgList': FieldValue.arrayUnion([authenInfo.img])
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

    var emailCredent = EmailAuthProvider.getCredential(
        email: user?.email ?? '$uid@gmail.com', password: authenInfo.password);
    await user.linkWithCredential(emailCredent);

    nav.pushReplacement(context, AuthenPage());
    load.add(false);
  }
}

final authService = AuthService();
