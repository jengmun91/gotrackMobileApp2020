import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiBaseUrl = 'https://gotrack-3nnv43jdkq-as.a.run.app';
// const String apiBaseUrl = 'https://c0fa3a3844a6.ngrok.io';

Future getSupportCourier() async {
  http.Response response = await http.get(
    Uri.encodeFull("$apiBaseUrl/api/support-courier"),
  );
  // print(response.body);
  //Returns 'true' or 'false' as a String
  return response.body;
}

Future getSuggestCourier(String trackingNo) async {
  http.Response response = await http.get(
    Uri.encodeFull("$apiBaseUrl/api/suggest-courier/$trackingNo"),
  );
  // print(response.body);
  //Returns 'true' or 'false' as a String
  return response.body;
}

Future getTracking(String trackingNo, String courier) async {
  http.Response response =
      await http.post(Uri.encodeFull("$apiBaseUrl/api/track/v1"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'tracking_no': trackingNo,
            'courier': courier,
          }));
  // print(response.body);
  //Returns 'true' or 'false' as a String
  return response.body;
}

Future getActiveTracking(String deviceId) async {
  http.Response response = await http.get(
      Uri.encodeFull("$apiBaseUrl/api/user/track-item?user_id=$deviceId"),
      headers: {
        'Content-Type': 'application/json',
        'source': 'android',
      });
  // print(response.body);
  //Returns 'true' or 'false' as a String
  return response.body;
}

Future setActiveTracking(String deviceId, List activeTracking) async {
  http.Response response =
      await http.post(Uri.encodeFull("$apiBaseUrl/api/user/track-item"),
          headers: {
            'Content-Type': 'application/json',
            'source': 'android',
          },
          body: jsonEncode({
            'user_id': deviceId,
            'track_item': activeTracking,
          }));
  // print(response.body);
  //Returns 'true' or 'false' as a String
  return response.body;
}

Future checkActiveTracking(String deviceId) async {
  http.Response response = await http.post(
      Uri.encodeFull("$apiBaseUrl/api/cron/user/track-item?user_id=$deviceId"),
      headers: {
        'Content-Type': 'application/json',
        'source': 'android',
      },
      body: jsonEncode({
        'user_id': deviceId,
      }));
  // print(response.body);
  //Returns 'true' or 'false' as a String
  return response.body;
}
