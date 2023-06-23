import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FirebaseApi {
  final _firebasesMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebasesMessaging.requestPermission();
    final fCMToken = await _firebasesMessaging.getToken();
    print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> sendNotification(String title, String body) async {
    await _firebasesMessaging.requestPermission();
    final fCMToken = await _firebasesMessaging.getToken();
    
    final notification = {
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
      },
      'to': fCMToken,
    };
    

    final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAZ2xF4kI:APA91bE62O8t-kAFgbu0rD3fKek8GTkl8WwlNn09BmJgZTJ47-Kp_owHbKWpdrv1gz_Lp-8laVqxUf02DcHTKPE0LMuJy2xw_HCa9izVQgw-YuOr7UQdFPgzseoTRTvHhDwsz8JYD3lf',
    },
    body: jsonEncode(notification),
  );

    if (response.statusCode == 200) {
      print('Notifikasi berhasil dikirim');
    } else {
      print('Gagal mengirim notifikasi');
    }
  }

}
