import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../shared/styles/colors.dart';
import 'layout_controller.dart';


class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
        init: SocialLayoutController(),
        builder: (socialLayoutController) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: Colors.white,
              title: Text(
                socialLayoutController
                    .appbar_title[socialLayoutController.currentIndex],
                style: socialLayoutController.currentIndex == 0
                    ? TextStyle(color: defaultColor)
                    : TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                    color: Colors.grey.shade600,
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                    )),
                IconButton(
                    color: Colors.grey.shade600,
                    onPressed: () {},
                    icon: Icon(Icons.notifications))
              ],
            ),
            body: socialLayoutController.isGetNeededData!
                ? socialLayoutController
                    .screens[socialLayoutController.currentIndex]
                : Center(child: CircularProgressIndicator()),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 30,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: defaultColor,
              onTap: (index) {
                print(index);
                //NOTE : if index equal 2 open NewPostScreen without change index

                socialLayoutController.onchangeIndex(index);
              },
              currentIndex: socialLayoutController.currentIndex,
              items: socialLayoutController.bottomItems,
            ),
          );
        });
  }
}
