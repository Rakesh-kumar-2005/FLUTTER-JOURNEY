import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Controllers/profile_controller.dart';
import 'package:dating_app/global.dart';
import 'package:dating_app/models/person.dart';
import 'package:dating_app/tabScreens/user_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SwipingScreen extends StatefulWidget {
  const SwipingScreen({super.key});

  @override
  State<SwipingScreen> createState() => _SwipingScreenState();
}

class _SwipingScreenState extends State<SwipingScreen> {
  ProfileController profileController = Get.put(ProfileController());

  String senderName = '';

  // Apply filter based on gender, age and country...
  applyFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text('Apply Filter', style: TextStyle(color: Colors.white, fontSize: 24)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gender tou are looking for...
                  Row(
                    children: [
                      Text(
                        "I am looking for a :",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DropdownButton<String>(
                      hint: Text(
                        'Select Gender',
                        style: TextStyle(fontSize: 18, color: Color(0xFFFD267D)),
                      ),
                      value: chosenGender,
                      borderRadius: BorderRadius.circular(20),
                      underline: SizedBox(),
                      items:
                          ['Male', 'Female', 'Other']
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item, style: TextStyle(color: Colors.white)),
                                ),
                              )
                              .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          chosenGender = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Country You are looking for...
                  Row(
                    children: [
                      Text("Who is from :", style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DropdownButton<String>(
                      hint: Text(
                        'Select Country',
                        style: TextStyle(color: Color(0xFFFD267D), fontSize: 18),
                      ),
                      value: chosenCountry,
                      borderRadius: BorderRadius.circular(20),
                      underline: SizedBox(),
                      items:
                          ['India', 'USA', 'England', 'Australia', 'Germany', 'France']
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item, style: TextStyle(color: Colors.white)),
                                ),
                              )
                              .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          chosenCountry = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Age You are looking for...
                  Row(
                    children: [
                      Text(
                        "Who's age is equal to or above :",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DropdownButton<String>(
                      hint: Text(
                        'Select Age',
                        style: TextStyle(color: Color(0xFFFD267D), fontSize: 18),
                      ),
                      value: chosenAge,
                      borderRadius: BorderRadius.circular(20),
                      underline: SizedBox(),
                      items:
                          ['18', '25', '30', '35', '40', '45', '50']
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item, style: TextStyle(color: Colors.white)),
                                ),
                              )
                              .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          chosenAge = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFD267D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Apply', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    profileController.getResults();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> startChattingInWhatsApp(BuildContext context, String receiverPhoneNumber) async {
    // Android URL
    final androidUrl = "whatsapp://send?phone=$receiverPhoneNumber&text=${Uri.encodeComponent("Heyy, I found you on Flare, let's chat!")}";

    // iOS URL
    final iosUrl = "https://wa.me/$receiverPhoneNumber?text=${Uri.encodeComponent("Heyy, I found you on Flare, let's chat!")}";

    try {
      final uri = Platform.isIOS ? Uri.parse(iosUrl) : Uri.parse(androidUrl);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // If it fails to open
        _showWhatsAppErrorDialog(context);
      }
    } catch (e) {
      _showWhatsAppErrorDialog(context);
    }
  }

  void _showWhatsAppErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.black54,
        icon: Icon(Icons.error, color: Color(0xFFFD267D), size: 50),
        title: Text('Error', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        content: Text('WhatsApp is not installed on this device or this phone number is not registered'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFFD267D), width: 2),
              ),
            ),
            child: Text('OK', style: TextStyle(color: Color(0xFFFD267D), fontSize: 18)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Read current user's data...
  readCurrentUserData() async {
    await FirebaseFirestore.instance.collection("Users").doc(currentUserId).get().then((value) {
      senderName = value.data()!['name'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return profileController.allUsersProfileList.isNotEmpty
          ? PageView.builder(
            itemCount: profileController.allUsersProfileList.length,
            controller: PageController(initialPage: 0),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Person eachProfileInfo = profileController.allUsersProfileList[index];

              return Stack(
                children: [
                  // Background image
                  Container(
                    height: MediaQuery.of(context).size.height * 0.9289,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(eachProfileInfo.imageProfile ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Scrollable content overlay
                  Positioned.fill(
                    // First page...
                    child: SizedBox(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 50, bottom: 50),
                        child: Column(
                          children: [
                            // Filter Button...
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    // Back Button...
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          // Confirmation for exiting...
                                          showDialog(
                                            context: context,
                                            builder:
                                              (context) => Dialog(
                                                backgroundColor:
                                                    Colors
                                                        .transparent, // Make outer dialog transparent
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
                                                            style: TextStyle(
                                                              color: Colors.white70,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 20),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.end,
                                                        children: [
                                                          TextButton(
                                                            onPressed:
                                                                () => Navigator.pop(context),
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              exit(0);
                                                            },
                                                            child: Text(
                                                              "exit",
                                                              style: TextStyle(
                                                                color: Color(0xFFFD267D),
                                                              ),
                                                            ),
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
                                          CupertinoIcons.back,
                                          size: 20,
                                          color: Color(0xFFFD267D),
                                        ),
                                      ),
                                    ),

                                    // Filter Button...
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: CupertinoButton(
                                        onPressed: () {
                                          applyFilter();
                                        },
                                        child: Icon(
                                          CupertinoIcons.slider_horizontal_3,
                                          size: 20,
                                          color: Color(0xFFFD267D),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Name and main Credentials...
                            Container(
                              margin: EdgeInsets.only(bottom: 3),
                              height: MediaQuery.of(context).size.height * 0.733,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 20),

                                      // Name of the Person...
                                      Text(
                                        (eachProfileInfo.name?.split(' ').first ?? '')
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      // Space between name and age...
                                      SizedBox(width: 18),

                                      // Age of the Person...
                                      Text(
                                        (eachProfileInfo.age ?? '').toString(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white60,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Location of the Person...
                                  Row(
                                    children: [
                                      // Space from the side...
                                      SizedBox(width: 20),

                                      // Icon...
                                      Icon(Icons.location_on, color: Colors.white),

                                      // City...
                                      Text(
                                        eachProfileInfo.city?.toUpperCase() ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),

                                      // Comma...
                                      Text(
                                        ', ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      // Country...
                                      Text(
                                        eachProfileInfo.country?.toUpperCase() ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Space from top...
                                  SizedBox(height: 10),

                                  // Some Qualities...
                                  Row(
                                    children: [
                                      // Space from the side...
                                      SizedBox(width: 20),

                                      // Gender...
                                      Container(
                                        height: 30,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(35),
                                          color: Color.fromRGBO(0, 0, 0, 0.3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              eachProfileInfo.gender == 'Male'
                                                  ? Icons.male
                                                  : Icons.female,
                                              color:
                                                  eachProfileInfo.gender == 'Male'
                                                      ? Colors.blue
                                                      : Color(0xFFFD267D),
                                            ),
                                            Text(
                                              eachProfileInfo.gender ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Space between weight and height...
                                      SizedBox(width: 3),

                                      // Weight...
                                      Container(
                                        height: 30,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(35),
                                          color: Color.fromRGBO(0, 0, 0, 0.3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.line_weight_rounded,
                                              color: Color(0xFFFD267D),
                                            ),
                                            Text(
                                              ' ${eachProfileInfo.weight ?? ''} kg',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Space between weight and height...
                                      SizedBox(width: 3),

                                      // Height
                                      Container(
                                        height: 30,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(35),
                                          color: Color.fromRGBO(0, 0, 0, 0.3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.height_rounded, color: Color(0xFFFD267D)),
                                            Text(
                                              '${eachProfileInfo.height ?? ''} cm ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Space from bottom...
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),

                            // Second Page...
                            Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                ),
                                color: Color.fromRGBO(0, 0, 0, 0.7),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    profileController.viewSentAndViewReceived(
                                      eachProfileInfo.uid.toString(),
                                      senderName,
                                    );

                                    // Send User to Profile Screen...
                                    Get.to(
                                      () => UserDetailsScreen(
                                        userID: eachProfileInfo.uid.toString(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFD267D),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'View Profile',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Immediate active buttons...
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Container(
                        height: 65,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Favorite Button...
                            Container(
                              height: 80,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: CupertinoButton(
                                onPressed: () {
                                  profileController.favoriteSentAndFavoriteReceived(
                                    eachProfileInfo.uid.toString(),
                                    senderName,
                                  );
                                },
                                child: Icon(
                                  Icons.star_purple500_outlined,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),

                            // Chat Button...
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: CupertinoButton(
                                onPressed: () {
                                  startChattingInWhatsApp(context, eachProfileInfo.phone.toString());
                                },
                                child: Icon(
                                  CupertinoIcons.chat_bubble_2_fill,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),

                            // Like Button...
                            Container(
                              height: 80,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Color(0xFFFD267D),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: CupertinoButton(
                                onPressed: () {
                                  profileController.likeSentAndLikeReceived(
                                    eachProfileInfo.uid.toString(),
                                    senderName,
                                  );
                                },
                                child: Icon(
                                  CupertinoIcons.suit_heart_fill,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
          : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off_outlined, size: 100, color: Color(0xFFFD267D)),
                SizedBox(height: 10),
                Text(
                  'No Profiles Available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      chosenGender = null;
                      chosenAge = null;
                      chosenCountry = null;
                    });
                    profileController.getResults();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE5045D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Restore', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          );
      }),
    );
  }
}
