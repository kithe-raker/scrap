import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register {
  final String email;
  final String phone;
  final String password;
  final String token;
  Register({
    @required this.email,
    this.phone,
    @required this.password,
    @required this.token,
  });

  registerWithPhone(String verified, String otpCode) async {
    var authCredential = PhoneAuthProvider.getCredential(
        verificationId: verified, smsCode: otpCode);
    await FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((AuthResult auth) async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      var credential = EmailAuthProvider.getCredential(
          email: this.email, password: this.password);
      await user.linkWithCredential(credential);
      await toDb(user.uid);
      await addToken(user.uid);
    });
  }

  register(AuthCredential authCredential) async {
    await FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((AuthResult auth) async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      var credential = EmailAuthProvider.getCredential(
          email: this.email, password: this.password);
      await user.linkWithCredential(credential);
      await toDb(user.uid);
      await addToken(user.uid);
    });
  }

  addToken(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('token')
        .document(token)
        .setData({'token': this.token});
  }

  toDb(String uid) async {
    await Firestore.instance.collection('Users').document(uid).setData({
      'email': this.email,
      'password': this.password,
      'phone': this.phone ?? '',
      'uid': uid,
    });
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('scraps')
        .document('recently')
        .setData({});
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('scraps')
        .document('collection')
        .setData({});
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('scraps')
        .document('notification')
        .setData({});
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document('searchHist')
        .setData({});
  }
}

class PhoneLogin {
  loginWithOTP(String verified, String otpCode) async {
    var authCredential = PhoneAuthProvider.getCredential(
        verificationId: verified, smsCode: otpCode);
    await FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  login(AuthCredential authCredential) async {
    await FirebaseAuth.instance.signInWithCredential(authCredential);
  }
}
