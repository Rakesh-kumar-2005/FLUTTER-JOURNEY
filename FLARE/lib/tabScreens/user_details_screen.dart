import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:get/get.dart';
import '../accountSettingScreen/account_setting_screen.dart';
import '../models/person.dart';

// ignore: must_be_immutable
class UserDetailsScreen extends StatefulWidget {

  String? userID;

  UserDetailsScreen({super.key, this.userID});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}



class _UserDetailsScreenState extends State<UserDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveUserInfo();
  }


  // Personal Details...
  String name = '';
  int age = 0;
  String gender = '';
  String email = '';
  String phone = '';
  String city = '';
  String state = '';
  String country = '';
  String profileHeader = '';
  String lookingForInAPartner = '';

  // Appearance Details...
  String height = '';
  String weight = '';
  String complexion = '';
  String bodyType = '';

  // Life Style details...
  String smoking = '';
  String drinking = '';
  String livingSituation = '';
  String income = '';
  String profession = '';
  String maritalStatus = '';
  String noOfChildren = '';
  String typeOfRelationship = '';

  // Background Details...
  String education = '';
  String noOfLanguages = '';
  String religion = '';
  String nationality = '';
  String ethnicity = '';

  // Slider Images...
  String urlImage1 = " ";
  String urlImage2 = " ";
  String urlImage3 = " ";
  String urlImage4 = " ";
  String urlImage5 = " ";

  void retrieveUserInfo() async {
    try {
      // Step 1: Get the user document from Fire-store
      final docSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.userID)
          .get();

      if (!docSnapshot.exists) {
        print("User document does not exist");
        return;
      }

      final userData = docSnapshot.data() as Map<String, dynamic>;

      // Convert age if needed
      if (userData['age'] is String) {
        userData['age'] = int.tryParse(userData['age']) ?? 0;
      }

      // Create Person object from data
      final user = Person.fromJson(userData);

      // Step 2: Fetch image URLs from Firebase Storage folder
      List<String> imageUrls = [];
      try {
        final ListResult result = await FirebaseStorage.instance
            .ref("images/${widget.userID}") // Folder where images are stored
            .listAll();

        // Loop through all files and get their download URLs
        for (var fileRef in result.items) {
          String fileUrl = await fileRef.getDownloadURL();
          imageUrls.add(fileUrl);
        }

        // Sort images by name to keep order consistent (optional)
        imageUrls.sort();
      } catch (e) {
        print("Error retrieving image URLs from storage: $e");
      }

      // Step 3: Update UI state
      setState(() {
        // Personal
        name = user.name ?? '';
        age = user.age ?? 0;
        gender = user.gender ?? '';
        email = user.email ?? '';
        phone = user.phone ?? '';
        city = user.city ?? '';
        state = user.state ?? '';
        country = user.country ?? '';
        profileHeader = user.profileHeader ?? '';
        lookingForInAPartner = user.lookingForInAPartner ?? '';

        // Appearance
        height = user.height ?? '';
        weight = user.weight ?? '';
        complexion = user.complexion ?? '';
        bodyType = user.bodyType ?? '';

        // Lifestyle
        smoking = user.smoking ?? '';
        drinking = user.drinking ?? '';
        livingSituation = user.livingSituation ?? '';
        income = user.income ?? '';
        profession = user.profession ?? '';
        maritalStatus = user.maritalStatus ?? '';
        noOfChildren = user.noOfChildren ?? '';
        typeOfRelationship = user.typeOfRelationship ?? '';

        // Background
        education = user.education ?? '';
        noOfLanguages = user.noOfLanguages ?? '';
        religion = user.religion ?? '';
        nationality = user.nationality ?? '';
        ethnicity = user.ethnicity ?? '';

        // Images - fallback to placeholder if missing
        const placeholderUrl =
            'https://firebasestorage.googleapis.com/v0/b/flare-9b5ed.firebasestorage.app/o/Place%20Holder%2Favatar.jpg?alt=media&token=f251c441-93d8-42bf-877e-c6e2f69d5e26';

        urlImage1 = imageUrls.isNotEmpty ? imageUrls[0] : placeholderUrl;
        urlImage2 = imageUrls.length > 1 ? imageUrls[1] : placeholderUrl;
        urlImage3 = imageUrls.length > 2 ? imageUrls[2] : placeholderUrl;
        urlImage4 = imageUrls.length > 3 ? imageUrls[3] : placeholderUrl;
        urlImage5 = imageUrls.length > 4 ? imageUrls[4] : placeholderUrl;

      });
    } catch (e) {
      print("Error retrieving user info: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Color(0xFFFD267D),
          onPressed: (){

            // for Back Button
            widget.userID == currentUserId ? showDialog(
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
            ): Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        centerTitle: true,
        title: Text('User Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
        actions: widget.userID == currentUserId
            ? [

          // Settings Button...
          IconButton(
            onPressed: (){
              Get.to(() => AccountSettingScreen(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 400),
              );
            },
            color: Color(0xFFFD267D),
            icon: Icon(CupertinoIcons.gear),
          ),


          // Sign Out Functionality...
          IconButton(
            color: Color(0xFFFD267D),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: Color(0xFFFD267D),
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
                              "Logout",
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
                              "Are you sure you want to logout?",
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
                                FirebaseAuth.instance.signOut();
                              },
                              child: Text("Logout", style: TextStyle(color: Color(0xFFFD267D))),
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
              Icons.logout,
            ),
          ),
        ]
            : null,


      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [

              // Image Slider
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 10,
                  ),
                  child: Carousel(
                    indicatorBarColor: Colors.black.withOpacity(0.3),
                    autoScrollDuration: Duration(seconds: 2),
                    animationPageDuration: Duration(milliseconds: 500),
                    activateIndicatorColor: Color(0xFFFD267D),
                    animationPageCurve: Curves.easeInOut,
                    indicatorBarHeight: 30,
                    indicatorHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.grey,
                    stopAtEnd: false,
                    autoScroll: true,
                    items: [
                      _buildNetworkImage(urlImage1),
                      _buildNetworkImage(urlImage2),
                      _buildNetworkImage(urlImage3),
                      _buildNetworkImage(urlImage4),
                      _buildNetworkImage(urlImage5),
                    ],

                  ),
                ),
              ),

              // Space from top...
              SizedBox(
                height: 20,
              ),

              // Personal Details Text...
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Personal Details :-',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ),

              // Space from top...
              SizedBox(
                height: 10,
              ),

              // Divider...
              Divider(
                color: Colors.white,
                thickness: 1,
              ),


              //Personal Info table data...
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Table(

                  columnWidths: const <int, TableColumnWidth> {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },

                  children: [

                    // Name...
                    TableRow(
                      children: [
                        Text(
                          "Name : ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),



                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Age...
                    TableRow(
                      children: [
                        Text(
                          "Age    :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          age.toString(),
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Phone Number...
                    TableRow(
                      children: [
                        Text(
                          "Phone  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          phone,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Email...
                    TableRow(
                      children: [
                        Text(
                          "Email  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          email,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // City...
                    TableRow(
                      children: [
                        Text(
                          "City  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          city,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // State...
                    TableRow(
                      children: [
                        Text(
                          "State  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          state,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Looking for In a Partner...
                    TableRow(
                      children: [
                        Text(
                          "Seeking  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          lookingForInAPartner,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                  ],
                ),
              ),

              // Appearance Details Text...
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Appearance Details :-',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ),

              // Space from top...
              SizedBox(
                height: 10,
              ),

              // Divider...
              Divider(
                color: Colors.white,
                thickness: 1,
              ),

              // Space from top...
              SizedBox(
                height: 10,
              ),

              // Appearance Details Table...
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Table(

                  columnWidths: const <int, TableColumnWidth> {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                  },

                  children: [

                    // Height...
                    TableRow(
                      children: [
                        Text(
                          "Height  : ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          height,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Weight...
                    TableRow(
                      children: [
                        Text(
                          "Weight  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          weight,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Complexion...
                    TableRow(
                      children: [
                        Text(
                          "Complexion  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          complexion,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Body Type...
                    TableRow(
                      children: [
                        Text(
                          "Body Type :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          bodyType,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),
                  ],
                ),
              ),

              // Life Style Details Text...
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Life Style Details :-',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ),

              // Space from top...
              SizedBox(
                height: 10,
              ),

              // Divider...
              Divider(
                color: Colors.white,
                thickness: 1,
              ),

              // Space from top...
              SizedBox(
                height: 10,
              ),

              // Appearance Details Table...
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Table(

                  columnWidths: const <int, TableColumnWidth> {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },

                  children: [

                    // Profession...
                    TableRow(
                      children: [
                        Text(
                          "Profession  : ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          profession,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Income...
                    TableRow(
                      children: [
                        Text(
                          "Income  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          income,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Living Situation...
                    TableRow(
                      children: [
                        Text(
                          "Living Situation  :  ",
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          livingSituation,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Smoking...
                    TableRow(
                      children: [
                        Text(
                          "Smoking :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          smoking,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Drinking...
                    TableRow(
                      children: [
                        Text(
                          "Drinking :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          drinking,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Marital Status...
                    TableRow(
                      children: [
                        Text(
                          "Marital Status :  ",
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          maritalStatus,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // No of children...
                    TableRow(
                      children: [
                        Text(
                          "children :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          noOfChildren,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Type of relationship looking for...
                    TableRow(
                      children: [
                        Text(
                          "Type of relationship :  ",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          typeOfRelationship,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),
                  ],
                ),
              ),

              // Background Details Text...
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Background & Cultural Values :-',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ),

              // Space from top...
              SizedBox(
                height: 10,
              ),

              // Divider...
              Divider(
                color: Colors.white,
                thickness: 1,
              ),

              // Space from top...
              SizedBox(
                height: 10,
              ),

              // Background and Cultural Details Table...
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Table(

                  columnWidths: const <int, TableColumnWidth> {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },

                  children: [

                    // Education...
                    TableRow(
                      children: [
                        Text(
                          "Qualification  : ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          education,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // No of languages known...
                    TableRow(
                      children: [
                        Text(
                          "No of languages known  :  ",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          noOfLanguages,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // religion...
                    TableRow(
                      children: [
                        Text(
                          "Religion  :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          religion,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // Nationality...
                    TableRow(
                      children: [
                        Text(
                          "Nationality :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          nationality,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                    // Extra for spacing...
                    TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    // ethnicity...
                    TableRow(
                      children: [
                        Text(
                          "Ethnicity :  ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[Color(0xFFFF7854), Color(0xFFFD267D)],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),

                        Text(
                          ethnicity,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              // Space from bottom...
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),


            ],
          ),
        ),
      )
    );
  }
}

// Network image builder...
Widget _buildNetworkImage(String url) {
  return Image.network(
    url,
    fit: BoxFit.cover,
    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child; // Image fully loaded
      return Center(
        child: CircularProgressIndicator(
          color: Colors.red,
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
              : null, // Show indeterminate spinner if size unknown
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) => const Icon(
      Icons.error_rounded,
      size: 50,
      color: Colors.red,
    ),
  );
}
