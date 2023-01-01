import 'dart:convert';


import 'package:faceclone/shared/constants.dart';
import 'package:faceclone/shared/network/local/cashhelper.dart';
import 'package:faceclone/shared/network/remote/diohelper.dart';
import 'package:faceclone/shared/styles/thems.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'layout/layout.dart';
import 'layout/layout_controller.dart';
import 'model/message_model.dart';
import 'model/user_model.dart';
import 'modules/social_login/login.dart';



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(" message data background " + message.data.toString());

  //showToast(message: "on background message", status: ToastStatus.Success);
}

void main() async {
  // NOTE : to run all thing befor runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: INITIALIZE FIREBASE
  await Firebase.initializeApp();

  await DioHelper.init();

// NOTE : catch notification  with parameter while app is opened  : ForeGroundMessage
  FirebaseMessaging.onMessage.listen((message) {
    print("message data " + message.data.toString());
    SocialLayoutController controller = Get.find<SocialLayoutController>();
    controller.getMyFriend();
    // showToast(message: "on message", status: ToastStatus.Success);
  });

// NOTE : catch notification  with parameter while app is closed and when on press notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("message data opened " + message.data['messageModel'].toString());
    SocialLayoutController controller = Get.find<SocialLayoutController>();

    MessageModel messageModel =
    MessageModel.fromJson(json.decode(message.data['messageModel']));

    UserModel userModel = controller.myFriends
        .where((element) => element.uId == messageModel.senderId)
        .single;

  });

// NOTE : catch notification  with parameter while app is in background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await CashHelper.Init();

  Widget widget;

  uId = CashHelper.getData(key: "uId") ?? null;
  print("UId :" + uId.toString());

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }

  // show top status bar
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [SystemUiOverlay.top],
  // );

  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  Widget widget;
  MyApp(this.widget);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: lightTheme(),
      themeMode: ThemeMode.light,
      // initialBinding: Binding(),
      debugShowCheckedModeBanner: false,
      home: widget,
    );
  }
}