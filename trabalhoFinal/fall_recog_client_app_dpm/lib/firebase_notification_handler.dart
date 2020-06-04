import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
 FirebaseMessaging _firebaseMessaging;

 FirebaseNotifications();

 void setUpFirebase() {
   _firebaseMessaging = FirebaseMessaging();
   firebaseCloudMessagingListeners();   
 }

 void firebaseCloudMessagingListeners() {   

   _firebaseMessaging.getToken().then((token) {
     print("token: $token");
   });

   _firebaseMessaging.configure(
     onMessage: (Map<String, dynamic> message) async {
       print("on message $message");       
     },
     onResume: (Map<String, dynamic> message) async {},
     onLaunch: (Map<String, dynamic> message) async {},
   );

   _firebaseMessaging.subscribeToTopic("fall");
 } 
}