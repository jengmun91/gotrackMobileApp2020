import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gotrack_flutter/services/gotrackAPI.dart' as gotrackAPI;

List allCourier = [
  {
    "code": "4px",
    "name": "4px Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/4px_200x100.jpg"
  },
  {
    "code": "abx",
    "name": "ABX Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/abx_200x100.jpg"
  },
  // {
  //   "code": "after5",
  //   "name": "After 5",
  //   "logo_url": "https://cdn.gotrack.my/courier/logo/xs/after5_200x100.jpg"
  // },
  {
    "code": "airpak",
    "name": "Airpak Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/airpak_200x100.jpg"
  },
  {
    "code": "aramex",
    "name": "Aramex",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/aramex_200x100.jpg"
  },
  {
    "code": "asiaxpress",
    "name": "Asiaxpress",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/asiaxpress_200x100.jpg"
  },
  {
    "code": "blackarrow",
    "name": "Black Arrow Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/blackarrow_200x100.jpg"
  },
  {
    "code": "citylink",
    "name": "Citylink Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/citylink_200x100.jpg"
  },
  {
    "code": "cj",
    "name": "CJ Century",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/cj_200x100.jpg"
  },
  {
    "code": "collectco",
    "name": "Collectco",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/collectco_200x100.jpg"
  },
  {
    "code": "comone",
    "name": "Comone Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/comone_200x100.jpg"
  },
  {
    "code": "dd",
    "name": "DD Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/dd_200x100.jpg"
  },
  {
    "code": "dhl",
    "name": "DHL Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/dhl_200x100.jpg"
  },
  {
    "code": "dhlec",
    "name": "DHL Ecommerce",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/dhlec_200x100.jpg"
  },
  {
    "code": "dpe",
    "name": "Dpe Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/dpe_200x100.jpg"
  },
  {
    "code": "dpex",
    "name": "Dpex Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/dpex_200x100.jpg"
  },
  {
    "code": "fedex",
    "name": "FedEx Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/fedex_200x100.jpg"
  },
  {
    "code": "fmx",
    "name": "FMX",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/fmx_200x100.jpg"
  },
  {
    "code": "gdex",
    "name": "Gdex Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/gdex_200x100.jpg"
  },
  {
    "code": "goodmaji",
    "name": "Goodmaji 好馬吉",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/goodmaji_200x100.jpg"
  },
  {
    "code": "janio",
    "name": "Janio",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/janio_200x100.jpg"
  },
  {
    "code": "jocom",
    "name": "Jocom",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/jocom_200x100.jpg"
  },
  {
    "code": "js",
    "name": "Jet Ship",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/js_200x100.jpg"
  },
  {
    "code": "jt",
    "name": "J&T Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/jt_200x100.jpg"
  },
  {
    "code": "jt_sg",
    "name": "J&T Express SG",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/jt-sg_200x100.jpg"
  },
  {
    "code": "karhoo",
    "name": "Karhoo Courier",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/karhoo_200x100.jpg"
  },
  {
    "code": "ktmd",
    "name": "KTMD Malaysia",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/ktmd_200x100.jpg"
  },
  {
    "code": "lbc",
    "name": "LBC Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/lbc_200x100.jpg"
  },
  // {
  //   "code": "lel",
  //   "name": "Lazada eLogistics (LEL)",
  //   "logo_url": "https://cdn.gotrack.my/courier/logo/xs/lel_200x100.jpg"
  // },
  {
    "code": "leopards",
    "name": "Leopards Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/leopards_200x100.jpg"
  },
  {
    "code": "lineclear",
    "name": "LineClear Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/lineclear_200x100.jpg"
  },
  {
    "code": "lwe",
    "name": "LWE",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/lwe_200x100.jpg"
  },
  {
    "code": "matdespatch",
    "name": "MatDespatch",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/matdespatch_200x100.jpg"
  },
  {
    "code": "mayexpress",
    "name": "May Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/mayexpress_200x100.jpg"
  },
  {
    "code": "motorex",
    "name": "Motorex",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/motorex_200x100.jpg"
  },
  {
    "code": "mxpress",
    "name": "M Xpress",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/mxpress_200x100.jpg"
  },
  {
    "code": "mypoz",
    "name": "MyPoz",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/mypoz_200x100.jpg"
  },
  {
    "code": "nationwide",
    "name": "Nationwide Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/nationwide_200x100.jpg"
  },
  {
    "code": "near_u",
    "name": "Near U",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/near-u_200x100.jpg"
  },
  {
    "code": "ninjavan_my",
    "name": "NinjaVan MY",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/ninjavan-my_200x100.jpg"
  },
  {
    "code": "ninjavan_sg",
    "name": "NinjaVan SG",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/ninjavan-sg_200x100.jpg"
  },
  {
    "code": "pgeon",
    "name": "Pgeon Delivery",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/pgeon_200x100.jpg"
  },
  {
    "code": "pickupp",
    "name": "Pickupp",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/pickupp_200x100.jpg"
  },
  {
    "code": "ping_u",
    "name": "Ping U",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/ping-u_200x100.jpg"
  },
  {
    "code": "poslaju",
    "name": "Poslaju Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/poslaju_200x100.jpg"
  },
  {
    "code": "qs",
    "name": "Quantium Solutions",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/qs_200x100.jpg"
  },
  {
    "code": "qxpress",
    "name": "Qxpress",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/qxpress_200x100.jpg"
  },
  {
    "code": "roadbull",
    "name": "Roadbull",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/roadbull_200x100.jpg"
  },
  {
    "code": "sf",
    "name": "SF Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/sf_200x100.jpg"
  },
  {
    "code": "shopee",
    "name": "Shopee Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/shopee_200x100.jpg"
  },
  {
    "code": "singpost",
    "name": "Singapore Post",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/singpost_200x100.jpg"
  },
  {
    "code": "skynet",
    "name": "Skynet Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/skynet_200x100.jpg"
  },
  {
    "code": "spc",
    "name": "SPC",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/spc_200x100.jpg"
  },
  {
    "code": "teleport",
    "name": "Teleport",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/teleport_200x100.jpg"
  },
  {
    "code": "tnt",
    "name": "TNT Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/tnt_200x100.jpg"
  },
  {
    "code": "ups",
    "name": "UPS Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/ups_200x100.jpg"
  },
  {
    "code": "urbanfox",
    "name": "UrbanFox",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/urbanfox_200x100.jpg"
  },
  {
    "code": "wepost",
    "name": "WePost",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/wepost_200x100.jpg"
  },
  {
    "code": "yunda",
    "name": "Yunda Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/yunda_200x100.jpg"
  },
  {
    "code": "zoom",
    "name": "Zoom",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/zoom_200x100.jpg"
  },
  {
    "code": "zto",
    "name": "ZTO Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/zto_200x100.jpg"
  },
  {
    "code": "best",
    "name": "Best Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/best_200x100.jpg"
  },
  {
    "code": "best_my",
    "name": "Best Express MY",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/best-my_200x100.jpg"
  },
  {
    "code": "yto",
    "name": "YTO Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/yto_200x100.jpg"
  },
  {
    "code": "sto",
    "name": "STO Express",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/sto_200x100.jpg"
  },
  {
    "code": "chinapost",
    "name": "China Post",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/chinapost_200x100.jpg"
  },
  {
    "code": "ztoglobal",
    "name": "ZTO International",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/ztoglobal_200x100.jpg"
  },
  {
    "code": "thelorry",
    "name": "The Lorry",
    "logo_url": "https://cdn.gotrack.my/courier/logo/xs/thelorry_200x100.jpg"
  }
];

Map allCourierObj = computeAllCourierObj();

sortCourier() {
  allCourier.sort((a, b) => a['name'].compareTo(b['name']));
  return allCourier;
}

computeAllCourierObj() {
  Map temp = {};
  allCourier.forEach((o) {
    temp[o['code']] = o;
  });
  return temp;
}

String preferCourier = 'pgeon';
Map selectedCourier = allCourierObj[preferCourier];
SharedPreferences prefs;
List trackingHistory = [];
List activeTracking = [];

String deviceId;
PackageInfo packageInfo;

Future<String> getDevideId() async {
  if (deviceId == null) {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId; // unique ID on Android
    }
  }
  return deviceId;
}

Future<PackageInfo> getPackageInfo() async {
  packageInfo = await PackageInfo.fromPlatform();
  print(packageInfo.appName);
  print(packageInfo.buildNumber);
  print(packageInfo.packageName);
  print(packageInfo.version);
  return packageInfo;
}

Future preload() async {
  allCourier = sortCourier();
  prefs = await SharedPreferences.getInstance();
  await getDevideId();
  trackingHistory =
      jsonDecode((prefs.getString('trackingHistory') ?? jsonEncode([])));
  trackingHistory = trackingHistory.where((o) => o['courier'] != null).toList();

  String preferCourierTemp = prefs.getString('preferCourier');
  if (preferCourierTemp != null) {
    selectedCourier = allCourierObj[preferCourierTemp];
  }

  try {
    var temp = await gotrackAPI.getActiveTracking(deviceId);
    temp = jsonDecode(temp);
    activeTracking = temp['result'][0]['track_item'].map((o) {
      if (o['last_status'] != null) {
        o['result'] = o['last_status'];
        o.remove('last_status');
      }
      return o;
    }).toList();
  } catch (err) {
    print(err);
  }
  if (activeTracking.length == 0) {
    print('ddb empty');
    activeTracking =
        jsonDecode((prefs.getString('activeTracking') ?? jsonEncode([])));
  } else {
    await prefs.setString('activeTracking', jsonEncode(activeTracking));
    print('ddb not empty');
  }
  print('preload done');
}

Map screenRefreshMapping = {};
