import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/authenticationScreen/login_screen.dart';
import 'package:dating_app/homeScreen/home_screen.dart';
import 'package:dating_app/models/person.dart' as personModel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get to => Get.find();

  late Rx<User?> firebaseCurrentUser;

  Rx<File?> pickedFile = Rx<File?>(null);
  File? get profileImage => pickedFile.value;

  final ImagePicker _picker = ImagePicker();

  // Getting image from gallery...
  Future<void> getImageFromGallery() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      pickedFile.value = File(imageFile.path);
      Get.snackbar(
        "Profile Picture",
        "Profile Picture has been updated from Gallery...",
        backgroundColor: Colors.black,
        borderRadius: 10,
        colorText: Colors.white,
        icon: Icon(Icons.done_outline_rounded, color: Color(0xD4FF2E81)),
        duration: Duration(seconds: 2),
        isDismissible: true,
        forwardAnimationCurve: Curves.bounceIn,
      );
    }
  }

  // Capturing image from camera...
  Future<void> captureImageFromCamera() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      pickedFile.value = File(imageFile.path);
      Get.snackbar(
        "Profile Picture",
        "Profile Picture has been updated from Camera...",
        backgroundColor: Colors.black,
        borderRadius: 10,
        colorText: Colors.white,
        icon: Icon(Icons.done_outline_rounded, color: Color(0xD4FF2E81)),
        duration: Duration(seconds: 2),
        isDismissible: true,
        forwardAnimationCurve: Curves.bounceIn,
      );
    }
  }

  // Uploading image to firebase storage...
  Future<String> uploadImageToStorage(File imageFile) async {
    Reference referenceStorage = FirebaseStorage.instance
        .ref()
        .child('Profile Images')
        .child(FirebaseAuth.instance.currentUser!.uid);

    // Uploading the image file...
    UploadTask task = referenceStorage.putFile(imageFile);
    TaskSnapshot snapshot = await task;

    // Downloadable URL...
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  createNewUserAccount(
      File imageProfile,
      String name,
      int age,
      String gender,
      String email,
      String password,
      String phone,
      String city,
      String state,
      String country,
      String profileHeader,
      String lookingForInAPartner,
      int publishDateTime,
      String height,
      String weight,
      String complexion,
      String bodyType,
      String smoking,
      String drinking,
      String livingSituation,
      String income,
      String profession,
      String maritalStatus,
      String noOfChildren,
      String typeOfRelationship,
      String education,
      String noOfLanguages,
      String religion,
      String nationality,
      String ethnicity,
      ) async {
    try {
      // 1. Authenticate and create a new user account...
      UserCredential credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Upload image to firebase storage and get download url...
      String urlOfDownloadedImage = await uploadImageToStorage(imageProfile);

      // 3. Save user details to fire-store database...
      personModel.Person personInstance = personModel.Person(

        // Unique ID...
        uid: FirebaseAuth.instance.currentUser!.uid,

        // Personal Details...
        imageProfile: urlOfDownloadedImage,
        name: name,
        age: age,
        gender: gender,
        email: email,
        password: password,
        phone: phone,
        city: city,
        state: state,
        country: country,
        profileHeader: profileHeader,
        lookingForInAPartner: lookingForInAPartner,
        publishDateTime: DateTime.now().millisecondsSinceEpoch,

        // Appearance Details...
        height: height,
        weight: weight,
        complexion: complexion,
        bodyType: bodyType,

        // Life Style details...
        smoking: smoking,
        drinking: drinking,
        livingSituation: livingSituation,
        income: income,
        profession: profession,
        maritalStatus: maritalStatus,
        noOfChildren: noOfChildren,
        typeOfRelationship: typeOfRelationship,

        // Background Details...
        education: education,
        noOfLanguages: noOfLanguages,
        religion: religion,
        nationality: nationality,
        ethnicity: ethnicity,
      );

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(personInstance.toJson());

      Get.snackbar(
        "Account created",
        "Congratulations! your account has been created successfully",
        backgroundColor: Color(0xD4FF2E81),
        borderRadius: 10,
        colorText: Colors.white,
        icon: Icon(Icons.done_outline_rounded, color: Colors.white),
        duration: Duration(seconds: 2),
        isDismissible: true,
        forwardAnimationCurve: Curves.bounceIn,
      );

      // Go to the home screen...
      Get.to(() => HomeScreen());

    } catch (e) {
      Get.snackbar(
        "Account creation unsuccessful",
        "Error occurred : $e",
        backgroundColor: Color(0xD4FF2E81),
        borderRadius: 10,
        colorText: Colors.white,
        icon: Icon(Icons.info, color: Colors.white),
        duration: Duration(seconds: 6),
        isDismissible: true,
        forwardAnimationCurve: Curves.bounceIn,
        mainButton : TextButton(
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      );
    }
  }

  // Login User...
  loginUser(String email, String password) async {
    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Get.snackbar(
        "Login Successful",
        "You have been logged in successfully",
        backgroundColor: Colors.black,
        borderRadius: 10,
        colorText: Colors.white,
        icon: Icon(Icons.done_outline_rounded, color: Color(0xD4FF2E81)),
        duration: Duration(seconds: 2),
        isDismissible: true,
        forwardAnimationCurve: Curves.bounceIn,
      );

      Get.offAll(() => HomeScreen());


    } catch (e) {
      Get.snackbar(
        "Login Unsuccessful",
        "Error occurred : $e",
        backgroundColor: Colors.black,
        borderRadius: 10,
        colorText: Colors.white,
        icon: Icon(Icons.cancel, color: Color(0xD4FF2E81)),
        duration: Duration(seconds: 6),
        isDismissible: true,
        forwardAnimationCurve: Curves.bounceIn,
        mainButton : TextButton(
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      );
    }
  }

  checkIfUserIsLoggedIn(User? user) async {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAll(() => HomeScreen());
    }
    else {
      Get.offAll(() => LoginScreen());
    }

  }

  @override
  void onReady() {
    super.onReady();

    firebaseCurrentUser =  Rx<User?> (FirebaseAuth.instance.currentUser);
    firebaseCurrentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(firebaseCurrentUser, checkIfUserIsLoggedIn);
  }

}
