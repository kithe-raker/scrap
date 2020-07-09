import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:scrap/services/admob_service.dart';

class FeedNativeAds {
  static NativeAdmob feedAds = NativeAdmob(
    adUnitID: ads.getNativeAdId(),
  );
}
