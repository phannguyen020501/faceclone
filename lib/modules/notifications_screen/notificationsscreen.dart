import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


import '../../layout/layout_controller.dart';
import '../../model/friend_request.dart';
import '../../shared/constants.dart';
import '../../shared/styles/colors.dart';
import 'notification_controller.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var friendrequestsQuery = FirebaseFirestore.instance
      .collection('users')
      .doc(uId)
      .collection('receivedfriendrequest')
      .orderBy('requestDate', descending: true)
      .withConverter<FriendRequest>(
        fromFirestore: (snapshot, _) =>
            FriendRequest.fromJson(snapshot.data()!),
        toFirestore: (request, _) => request.toJson(),
      );

  var controller = Get.put(NotificationController());
  var socialLayoutController_needed = Get.find<SocialLayoutController>();
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height * 0.4,
              child: FirestoreListView<FriendRequest>(
                  // reverse: true,
                  //    physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  pageSize: 5,
                  query: friendrequestsQuery,
                  // loadingBuilder: (context) => Center(
                  //       child: CircularProgressIndicator(),
                  //     ),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Something went wrong! ${error} - ${stackTrace}'),
                  itemBuilder: (context, snapshot) {
                    FriendRequest model;
                    int count_ofreceivedRequest = 0;

                    if (snapshot.isBlank!) {
                      print('snapshot blank');

                      print(snapshot.data().name);
                      return Container();
                    } else {
                      model = snapshot.data();
                      count_ofreceivedRequest++;
                      print('snapshot data');
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Text(
                                "Friend requests",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${count_ofreceivedRequest}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                "See all",
                                style: TextStyle(color: defaultColor),
                              ),
                            ],
                          ),
                        ),
                        _buildRequestItem(model, context, controller),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _buildRequestItem(FriendRequest model, BuildContext context,
      NotificationController controller) {
    return Container(
      height: MediaQuery.of(context).size.height * .15,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: model.image == null || model.image == ""
                  ? AssetImage('assets/default profile.png') as ImageProvider
                  : NetworkImage(model.image!),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.name.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${convertToAgo(model.requestDate!.toDate())}",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: defaultColor.shade800,
                        onPressed: () {
                          controller
                              .confirmRequest(
                                  myId: uId.toString(),
                                  user_requestId: model.requestId.toString())
                              .then((value) {
                            //after confirmed wait then get logged in user to show my new friends
                            Future.delayed(Duration(seconds: 2)).then((value) {
                              socialLayoutController_needed
                                  .getLoggedInUserData();
                            });
                          });
                        },
                        child: Text(
                          "confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: MaterialButton(
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.grey.shade300,
                        onPressed: () {
                          controller.deleteRequest(
                              myId: uId.toString(),
                              user_requestId: model.requestId.toString());
                        },
                        child: Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
