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
     if (Platform.isIOS){
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  String getVideoAdId(){
    if (Platform.isIOS){
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return null;
  }
}

final ads = AdmobService();
