import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:book_my_show_clone/main.dart';
import 'package:book_my_show_clone/services/firebaseServices/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// ignore: prefer_const_constructors
final AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationplugin =
    FlutterLocalNotificationsPlugin();

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> sendNotificationToPeer(
    {required body,
    required title,
    required token,
    required channelUrl}) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAA3n7so9I:APA91bFqVwKJUtNi4JnuWqZkECdROlSYu22SnLlhaB_QnXVKVhdrEYU5aDqVl5lg4W2mZc2-fTUkiIDvuy0kcvReebWEtKAkySlJDnm6ZkFv1a9UOKtawtC2XyltBbVT5Wdhd3r0qBfe"
      },
      body: jsonEncode(
        <String, dynamic>{
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "message": "$body",
            "title": "$title",
            "vibrate": 1,
            "sound": 1,
            "image": "",
            "logo": "",
            "channelUrl": "$channelUrl",
          },
          'to': "$token"
        },
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();
  BigPictureStyleInformation? styleInformation;

  var data = message.data;
  if (data['image'] != "" && data['logo'] != "") {
    String largeIconPath =
        await _downloadAndSaveFile(data['logo'], 'largeIcon');
    String bigPicturePath =
        await _downloadAndSaveFile(data['image'], 'bigPicture');
    styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
    );
  }

  AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(
      channel.id, channel.name,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: styleInformation,
      groupKey: channel.groupId);
  NotificationDetails notificationDetailsPlatformSpefics =
      NotificationDetails(android: notificationDetails);
  flutterLocalNotificationplugin.show(data.hashCode, data['title'],
      data['message'], notificationDetailsPlatformSpefics);
  if (kDebugMode) {
    print("foreground Data  ${message.messageId}");
  }
  if (kDebugMode) {
    print(message.data);
  }

  if (kDebugMode) {
    print("Handling a background message : ${message.messageId}");
  }
  if (kDebugMode) {
    print(message.data);
  }
}

FirebaseServices _service = FirebaseServices();

class FirebaseNotifcation {
  final BuildContext context;

  FirebaseNotifcation({required this.context});

  initialize(BuildContext context) async {
    await Firebase.initializeApp();

    // ChatProvider model = ChatProvider();
    // model = Provider.of<ChatProvider>(context, listen: false);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationplugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var intializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: intializationSettingsAndroid);

    flutterLocalNotificationplugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      var data = message.data;
      //AndroidNotification? android = message.notification?.android;
      if (kDebugMode) {
        print(message.data);
      }
      BigPictureStyleInformation? styleInformation;

      if (data['image'] != "" && data['logo'] != "") {
        String largeIconPath =
            await _downloadAndSaveFile(data['logo'], 'largeIcon');
        String bigPicturePath =
            await _downloadAndSaveFile(data['image'], 'bigPicture');
        styleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath),
        );
      }

      AndroidNotificationDetails notificationDetails =
          AndroidNotificationDetails(channel.id, channel.name,
              importance: Importance.max,
              styleInformation: styleInformation,
              priority: Priority.high,
              groupKey: channel.groupId);
      NotificationDetails notificationDetailsPlatformSpefics =
          NotificationDetails(android: notificationDetails);
      flutterLocalNotificationplugin.show(data.hashCode, data['title'],
          data['message'], notificationDetailsPlatformSpefics);
      if (kDebugMode) {
        print("foreground Data  ${message.messageId}");
      }
      if (kDebugMode) {
        print(message.data);
      }
      // model = ChatProvider( channelUrl: data['channelUrl']);
      // model.loadChannel().then((value) {
      //   model.loadMessages(reload: true);
      // });

      List<ActiveNotification>? activeNotifications =
          await flutterLocalNotificationplugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.getActiveNotifications();
      if (activeNotifications!.isNotEmpty) {
        List<String> lines =
            activeNotifications.map((e) => e.title.toString()).toList();
        InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
            lines,
            contentTitle: "${activeNotifications.length - 1} messages",
            summaryText: "${activeNotifications.length - 1} messages");
        AndroidNotificationDetails groupNotificationDetails =
            AndroidNotificationDetails(
          channel.id,
          channel.name,
          styleInformation: inboxStyleInformation,
          setAsGroupSummary: true,
        );

        // NotificationDetails groupNotificationDetailsPlatformSpefics =
        //     NotificationDetails(android: groupNotificationDetails);
        // await flutterLocalNotificationplugin.show(
        //     0, '', '', groupNotificationDetailsPlatformSpefics);
      }
    });
  }

  getToken() async {
    await FirebaseMessaging.instance.getToken().then((val) {
      if (preferences!.getString('FCMToken') != val) {
        if (kDebugMode) {
          print('FB Token from Server: ${val!}');
        }
        _service.updateToken({
          'id': FirebaseAuth.instance.currentUser!.uid,
          'token': val,
        });
        preferences!.setString('FCMToken', val!);
      } else {
        // ignore: prefer_interpolation_to_compose_strings
        if (kDebugMode) {
          print('FB Token from SF: ${preferences!.getString('FCMToken')}');
        }
      }
    });
    // print(token);
  }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    log("Subscribed to  $topic");
  }
}
