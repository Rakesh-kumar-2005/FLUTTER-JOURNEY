import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/global.dart';
import 'package:flutter/material.dart';


class FavoriteSentFavoriteReceivedScreen extends StatefulWidget {
  const FavoriteSentFavoriteReceivedScreen({super.key});

  @override
  State<FavoriteSentFavoriteReceivedScreen> createState() =>
      _FavoriteSentFavoriteReceivedScreenState();
}

class _FavoriteSentFavoriteReceivedScreenState extends State<FavoriteSentFavoriteReceivedScreen> {
  // Checking which tab is clicked...
  bool isFavoriteSentClicked = true;

  // Favorite Sent List...
  List<String> favoriteSentList = [];

  // favorite Received List...
  List<String> favoriteReceivedList = [];

  // favorite List...
  List favoritesList = [];

  getFavoriteList() async {
    if (isFavoriteSentClicked) {
      var favoriteSentDocument =
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUserId)
              .collection("favoriteSent")
              .get();

      for (int i = 0; i < favoriteSentDocument.docs.length; i++) {
        favoriteSentList.add(favoriteSentDocument.docs[i].id);
      }

      getKeysDataFromUsersCollection(favoriteSentList);
    } else {
      var favoriteReceivedDocument =
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUserId)
              .collection("favoriteReceived")
              .get();

      for (int i = 0; i < favoriteReceivedDocument.docs.length; i++) {
        favoriteReceivedList.add(favoriteReceivedDocument.docs[i].id);
      }

      getKeysDataFromUsersCollection(favoriteReceivedList);
    }
  }

  getKeysDataFromUsersCollection(List<String> keysList) async {
    var allUsersDocument = await FirebaseFirestore.instance.collection("Users").get();

    // Comparing keysList with allUsersDocument
    for (int i = 0; i < allUsersDocument.docs.length; i++) {
      for (int j = 0; j < keysList.length; j++) {
        if (allUsersDocument.docs[i].data()["uid"] == keysList[j]) {
          favoritesList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      favoritesList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // Exit Button...
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => Dialog(
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFFD267D)),
        ),
        // 2 tabs...
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // My Likes...
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isFavoriteSentClicked ? Color(0xFFFD267D) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Clearing Lists...
                    favoriteSentList.clear();
                    favoriteSentList = [];
                    favoriteReceivedList.clear();
                    favoriteReceivedList = [];
                    favoritesList.clear();
                    favoritesList = [];

                    isFavoriteSentClicked = true;

                    // Fetching Data...
                    getFavoriteList();
                  });
                },
                child: Text(
                  "My Favorites",
                  style: TextStyle(
                    color: isFavoriteSentClicked ? Color(0xFFFD267D) : Colors.white54,
                    fontWeight: isFavoriteSentClicked ? FontWeight.bold : FontWeight.normal,
                    fontSize: isFavoriteSentClicked ? 20 : 18,
                  ),
                ),
              ),
            ),

            // Space in between...
            SizedBox(width: 10),

            // I am the Like...
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: !isFavoriteSentClicked ? Color(0xFFFD267D) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Clearing Lists...
                    favoriteSentList.clear();
                    favoriteSentList = [];
                    favoriteReceivedList.clear();
                    favoriteReceivedList = [];
                    favoritesList.clear();
                    favoritesList = [];

                    isFavoriteSentClicked = false;

                    // Fetching Data...
                    getFavoriteList();
                  });
                },
                child: Text(
                  "Me Favorite",
                  style: TextStyle(
                    color: !isFavoriteSentClicked ? Color(0xFFFD267D) : Colors.white54,
                    fontWeight: !isFavoriteSentClicked ? FontWeight.bold : FontWeight.normal,
                    fontSize: !isFavoriteSentClicked ? 20 : 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Body if List is Empty...
      body:
          favoritesList.isEmpty
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
                      "No Favorites",
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
              : ListView.builder(
                itemCount: favoritesList.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final currentLike = favoritesList[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    child: ListTile(
                      tileColor: Color(0x493E3E41),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

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
                                        image: NetworkImage(currentLike["imageProfile"]),
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
                          backgroundImage: NetworkImage(currentLike["imageProfile"]),
                          radius: 25,
                        ),
                      ),

                      // Name...
                      title: Text(
                        currentLike["name"],
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
                      subtitle: Text(
                        '${favoritesList[index]["state"] ?? ""}, ${favoritesList[index]["country"] ?? ""}',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),

                      trailing:
                          isFavoriteSentClicked
                              ? GestureDetector(
                                onTap: () async {
                                  // Removing from Database...
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(currentUserId)
                                      .collection("favoriteSent")
                                      .doc(currentLike["uid"])
                                      .delete();

                                  // Removing from other User Database...
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(currentLike["uid"])
                                      .collection("favoriteReceived")
                                      .doc(currentUserId)
                                      .delete();

                                  // Removing from List...
                                  setState(() {
                                    favoritesList.removeAt(index);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFFF7854), Color(0xFFFD267D)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : null,
                    ),
                  );
                },
              ),
    );
  }
}
