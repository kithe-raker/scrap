import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';

class Reporting {
  getDate() {
    var now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  Future<void> reportApp(BuildContext context) async {
    final user = Provider.of<UserData>(context, listen: false);
    final report = Provider.of<Report>(context, listen: false);
    await fireStore
        .collection("Report")
        .document(getDate())
        .collection("reportApp")
        .add({
      "reporter": user.uid,
      "text": report.reportText,
      "timestamp": FieldValue.serverTimestamp()
    });
  }
}

final reportApp = Reporting();
