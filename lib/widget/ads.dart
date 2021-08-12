import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({Key key}) : super(key: key);
  Widget build(BuildContext context) {
    print('build ad');
    return Container(
      width: screenWidthDp,
      color: Colors.grey[400],
      child: AdmobBanner(
          key: key,
          adUnitId: AdmobService().getBannerAdId(),
          adSize: AdmobBannerSize.LARGE_BANNER),
    );
  }
}
