import 'dart:io';

class AdmobManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8106249853899035~5729006697";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8106249853899035~5799259070";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8106249853899035/8462943252";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8106249853899035/4431719972";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8106249853899035/4962737781";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
