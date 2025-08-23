import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/global.dart';
import 'package:dating_app/tabScreens/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewSentViewReceivedScreen extends StatefulWidget {
  const ViewSentViewReceivedScreen({super.key});

  @override
  State<ViewSentViewReceivedScreen> createState() => _ViewSentViewReceivedScreenState();
}

class _ViewSentViewReceivedScreenState extends State<ViewSentViewReceivedScreen> {
  // Checking which tab is clicked...
  bool isViewSentClicked = true;

  // Like Sent List...
  List<String> viewSentList = [];

  // Like Received List...
  List<String> viewReceivedList = [];

  // favorite List...
  List viewsList = [];

  getViewsList() async {
    if (isViewSentClicked) {
      var likeSentDocument =
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId)
          .collection("viewSent")
          .get();

      for (int i = 0; i < likeSentDocument.docs.length; i++) {
        viewSentList.add(likeSentDocument.docs[i].id);
      }

      getKeysDataFromUsersCollection(viewSentList);
    } else {
      var likeReceivedDocument =
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId)
          .collection("viewReceived")
          .get();

      for (int i = 0; i < likeReceivedDocument.docs.length; i++) {
        viewReceivedList.add(likeReceivedDocument.docs[i].id);
      }

      getKeysDataFromUsersCollection(viewReceivedList);
    }
  }

  getKeysDataFromUsersCollection(List<String> keysList) async {
    var allUsersDocument = await FirebaseFirestore.instance.collection("Users").get();

    // Comparing keysList with allUsersDocument
    for (int i = 0; i < allUsersDocument.docs.length; i++) {
      for (int j = 0; j < keysList.length; j++) {
        if (allUsersDocument.docs[i].data()["uid"] == keysList[j]) {
          viewsList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      viewsList;
    });
  }

  @override
  void initState() {
    super.initState();
    getViewsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,

          // Exit Button...
          leading: IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent, // Make outer dialog transparent
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: Color(0xFFFD267D), // Pink border
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Exit",
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              "Are you sure you want to exit?",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                            ),
                            TextButton(
                              onPressed: () {
                                exit(0);
                              },
                              child: Text("exit", style: TextStyle(color: Color(0xFFFD267D))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFFD267D),
            ),
          ),
          // 2 tabs...
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              // space...
              SizedBox(width: 20),

              // My Likes...
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isViewSentClicked ? Color(0xFFFD267D) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      // Clearing Lists...
                      viewSentList.clear();
                      viewSentList = [];
                      viewReceivedList.clear();
                      viewReceivedList = [];
                      viewsList.clear();
                      viewsList = [];

                      isViewSentClicked = true;

                      // Fetching Data...
                      getViewsList();
                    });
                  },
                  child: Text(
                    "My Views",
                    style: TextStyle(
                      color: isViewSentClicked ? Color(0xFFFD267D) : Colors.white54,
                      fontWeight: isViewSentClicked ? FontWeight.bold : FontWeight.normal,
                      fontSize: isViewSentClicked ? 20 : 18,
                    ),
                  ),
                ),
              ),

              // Space in between...
              SizedBox(width: 20),

              // I am the Like...
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: !isViewSentClicked ? Color(0xFFFD267D) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      // Clearing Lists...
                      viewSentList.clear();
                      viewSentList = [];
                      viewReceivedList.clear();
                      viewReceivedList = [];
                      viewsList.clear();
                      viewsList = [];

                      isViewSentClicked = false;

                      // Fetching Data...
                      getViewsList();
                    });
                  },
                  child: Text(
                    "Me Views",
                    style: TextStyle(
                      color: !isViewSentClicked ? Color(0xFFFD267D) : Colors.white54,
                      fontWeight: !isViewSentClicked ? FontWeight.bold : FontWeight.normal,
                      fontSize: !isViewSentClicked ? 20 : 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Body if List is Empty...
        body:
        viewsList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon...
              Icon(Icons.person_off_rounded, size: 100, color: Color(0xFFFD267D)),

              // Space in between...
              SizedBox(height: 20),

              // Text...
              Text(
                "No Views",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  foreground:
                  Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
            ],
          ),
        )
            :
        ListView.builder(
            itemCount: viewsList.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final currentView = viewsList[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: ListTile(
                  tileColor: Color(0x493E3E41),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Profile Picture...
                  leading: GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: "ImageDialog",
                        transitionDuration: Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Center(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.7,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFFD267D)),
                                  borderRadius: BorderRadius.circular(18),
                                  image: DecorationImage(
                                    image: NetworkImage(currentView["imageProfile"]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        transitionBuilder: (context, animation, secondaryAnimation, child) {
                          return ScaleTransition(
                            filterQuality: FilterQuality.high,
                            scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                            child: child,
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(currentView["imageProfile"]),
                      radius: 25,
                    ),
                  ),

                  // Name...
                  title: Text(
                    currentView["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      foreground:
                      Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),

                  // Address...
                  subtitle:
                  Text(
                    '${viewsList[index]["state"] ?? ""}, ${viewsList[index]["country"] ?? ""}',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),

                  trailing:Container(
                    height: 36,
                    width: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF7854), Color(0xFFFD267D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),


                    child: IconButton(
                      onPressed: () {
                        Get.to(() => UserDetailsScreen(userID: currentView["uid"].toString()),
                          transition: Transition.rightToLeft,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 400),

                        );
                      },
                      icon: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}
