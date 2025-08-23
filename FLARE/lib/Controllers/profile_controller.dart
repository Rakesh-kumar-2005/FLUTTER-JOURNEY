import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/global.dart';
import 'package:dating_app/models/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  // User list...
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);

  List<Person> get allUsersProfileList => usersProfileList.value;

  getResults() {
    onInit();
  }

  // Getting all users...
  @override
  void onInit()  {
    super.onInit();

    if(chosenGender == null || chosenAge == null || chosenCountry == null) {
      usersProfileList.bindStream(
        FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .map((QuerySnapshot queryDataSnapshot) {

            List<Person> profileList = [];

            for(var eachProfile in queryDataSnapshot.docs) {
              profileList.add(Person.fromJson(eachProfile.data() as Map<String, dynamic>));
            }

            return profileList;

          }
        )
      );
    }else{
      usersProfileList.bindStream(
        FirebaseFirestore.instance
          .collection("Users")
          .where("gender", isEqualTo: chosenGender.toString())
          .where("age", isGreaterThanOrEqualTo: int.parse(chosenAge.toString()))
          .where("country", isEqualTo: chosenCountry.toString())
          .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .map((QuerySnapshot queryDataSnapshot) {

            List<Person> profileList = [];

            for(var eachProfile in queryDataSnapshot.docs) {
              profileList.add(Person.fromJson(eachProfile.data() as Map<String, dynamic>));
            }

            return profileList;

          }
        )
      );
    }
  }

  // Favorite sent and favorite received...
  favoriteSentAndFavoriteReceived(String toUserID, String senderName) async {

    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(toUserID).collection("favoriteReceived").doc(currentUserId)
        .get();

    // Remove the sender from favorite received list if it exists...
    if(document.exists) {

      // Remove current user from favoriteReceived list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(toUserID).collection("favoriteReceived").doc(currentUserId)
          .delete();

      // Remove sender from favoriteSent list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId).collection("favoriteSent").doc(toUserID)
          .delete();

    }

    // Mark the sender as favorite sent if it doesn't exist...
    else {

      // Add current user ID to favoriteReceived list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(toUserID).collection("favoriteReceived").doc(currentUserId)
          .set({});

      // Add sender ID to favoriteSent list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId).collection("favoriteSent").doc(toUserID)
          .set({});

    }

  }

  // Like sent and like received...
  likeSentAndLikeReceived(String toUserID, String senderName) async {

    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(toUserID).collection("likeReceived").doc(currentUserId)
        .get();

    // Remove the sender from likeReceived list if it exists...
    if(document.exists) {

      // Remove current user from favoriteReceived list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(toUserID).collection("likeReceived").doc(currentUserId)
          .delete();

      // Remove sender from LikeSent list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId).collection("likeSent").doc(toUserID)
          .delete();

    }

    // Mark the sender as Like sent if it doesn't exist...
    else {

      // Add current user ID to likeReceived list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(toUserID).collection("likeReceived").doc(currentUserId)
          .set({});

      // Add sender ID to likeSent list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId).collection("likeSent").doc(toUserID)
          .set({});

    }

  }

  // View sent and View received...
  viewSentAndViewReceived(String toUserID, String senderName) async {

    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(toUserID).collection("viewReceived").doc(currentUserId)
        .get();

    // Already viewed the profile...
    if(document.exists) {
      print("Already Viewed the Profile...");
    }

    // Mark as new View in the database...
    else {

      // Add current user ID to viewReceived list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(toUserID).collection("viewReceived").doc(currentUserId)
          .set({});

      // Add sender ID to viewSent list...
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId).collection("viewSent").doc(toUserID)
          .set({});

    }

  }

}