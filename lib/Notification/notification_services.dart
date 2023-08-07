
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance ;
  // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      Utils().toastMessage1('Permission Granted');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      Utils().toastMessage1('Provisional Permission Granted');
    }else{
      AppSettings.openAppSettings();
      Utils().toastMessage1('Permission Denied');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh(){
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      debugPrint(event);
    });
  }

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {

    });
  }
  //
  // Future<void> showNotification(RemoteMessage message) async {
  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //       Random.secure().nextInt(10000).toString(),
  //       'High Importance Channel',
  //     importance: Importance.max,
  //   );
  //
  //   AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
  //       channel.id.toString(),
  //       channel.name.toString(),
  //     channelDescription: 'Your Channel Description',
  //     priority: Priority.high,
  //     importance: Importance.high,
  //     ticker: 'ticker'
  //   );
  //   DarwinNotificationDetails details = const DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //   NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: details,
  //   );
  //   Future.delayed(Duration.zero, (){
  //     _flutterLocalNotificationsPlugin.show(
  //         0,
  //         message.notification!.title.toString(),
  //         message.notification!.body.toString(),
  //         notificationDetails
  //     );
  //   });
  // }
  //
  // void initLocalNotification(BuildContext context, RemoteMessage message) async {
  //   var androidInitialization = const AndroidInitializationSettings('ic_launcher');
  //   var iosInitialization = const DarwinInitializationSettings();
  //
  //   var initializationSetting = InitializationSettings(
  //     android: androidInitialization,
  //     iOS: iosInitialization
  //   );
  //
  //   await _flutterLocalNotificationsPlugin.initialize(
  //       initializationSetting,
  //     onDidReceiveNotificationResponse: (payload){
  //
  //     }
  //   );
  // }
}