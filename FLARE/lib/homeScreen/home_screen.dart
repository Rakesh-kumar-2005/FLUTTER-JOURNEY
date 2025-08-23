import 'dart:ui';

import 'package:dating_app/tabScreens/favorite_sent_favorite_received_screen.dart';
import 'package:dating_app/tabScreens/like_sent_like_received_screen.dart';
import 'package:dating_app/tabScreens/swiping_screen.dart';
import 'package:dating_app/tabScreens/user_details_screen.dart';
import 'package:dating_app/tabScreens/view_sent_view_received_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Screen Index number...
  int screenIndex = 0;

  // Screen Lists...
  List<Widget> screens = [
    SwipingScreen(),
    ViewSentViewReceivedScreen(),
    FavoriteSentFavoriteReceivedScreen(),
    LikeSentLikeReceivedScreen(),
    UserDetailsScreen(userID: FirebaseAuth.instance.currentUser!.uid,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 👈 IMPORTANT for blur to overlay the body
      body: screens[screenIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1), // Semi-transparent
              border: Border(
                top: BorderSide(
                  color: Color(0xFFFD267D),
                  width: 2,
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: screenIndex,
              onTap: (index) {
                setState(() {
                  screenIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color(0xFFFD267D),
              unselectedItemColor: Colors.white,
              selectedIconTheme: IconThemeData(size: 28),
              unselectedIconTheme: IconThemeData(size: 22),
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 11,
              ),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.remove_red_eye), label: 'View'),
                BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorite'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
