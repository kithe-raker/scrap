import 'dart:io';

class AdmobService {
  String getAdmobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3612265554509092~4730522974';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3612265554509092~5449650222';
    }
    return null;
  }

  String getBannerAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3612265554509092/4043772045';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3612265554509092/3753425177';
    }
    return null;
  }

  String getVideoAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3612265554509092/6217554953';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3612265554509092/1348371653';
    }
    return null;
  }

  String getNativeAdId() {
    return Platform.isIOS
        ? 'ca-app-pub-3612265554509092/8652228758'
        : 'ca-app-pub-3612265554509092/6245525449';
  }
}

final ads = AdmobService();

/*

getbanner android => ca-app-pub-3612265554509092/3753425177
getbanner ios => ca-app-pub-3612265554509092/4043772045
getVedioAdid  android => ca-app-pub-3612265554509092/6245525449
getVideoAdid ios => ca-app-pub-3612265554509092/8652228758
*/
