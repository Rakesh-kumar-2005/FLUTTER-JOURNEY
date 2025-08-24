import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/global.dart';
import 'package:dating_app/homeScreen/home_screen.dart';
import 'package:dating_app/widgets/custom_text_field_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  bool uploading = false;
  bool next = false;

  final List<File> _image = [];

  List<String> urlsList = [];

  double val = 0;

  // TextFields...
  // Personal Details...
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneNoController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final profileHeadingController = TextEditingController();
  final sexController = TextEditingController();
  final lookingForInAPartnerController = TextEditingController();

  // Appearance Details...
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final bodyTypeController = TextEditingController();
  final complexionController = TextEditingController();

  // Life Style Details...
  final smokingController = TextEditingController();
  final drinkingController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final noOfChildrenController = TextEditingController();
  final professionController = TextEditingController();
  final incomeController = TextEditingController();
  final livingSituationController = TextEditingController();
  final willingToRelocateController = TextEditingController();
  final relationShipYouAreLookingForController = TextEditingController();

  // Background Details...
  final nationalityController = TextEditingController();
  final educationController = TextEditingController();
  final languageSpokenController = TextEditingController();
  final religionController = TextEditingController();
  final ethnicityController = TextEditingController();



  // Retrieving Data from firebase...
  // Retrieving Data from firebase...
  retrieveUserData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        setState(() {
          // Assigning values to variables...
          nameController.text = data['name'] ?? '';
          ageController.text = data['age'].toString();
          phoneNoController.text = data['phone'] ?? '';
          cityController.text = data['city'] ?? '';
          stateController.text = data['state'] ?? '';
          countryController.text = data['country'] ?? '';
          profileHeadingController.text = data['profileHeader'] ?? '';
          lookingForInAPartnerController.text = data['lookingForInAPartner'] ?? '';
          heightController.text = data['height'] ?? '';
          weightController.text = data['weight'] ?? '';
          complexionController.text = data['complexion'] ?? '';
          bodyTypeController.text = data['bodyType'] ?? '';
          smokingController.text = data['smoking'] ?? '';
          drinkingController.text = data['drinking'] ?? '';
          maritalStatusController.text = data['maritalStatus'] ?? '';
          noOfChildrenController.text = data['noOfChildren'] ?? '';
          professionController.text = data['profession'] ?? '';
          incomeController.text = data['income'] ?? '';
          livingSituationController.text = data['livingSituation'] ?? '';
          willingToRelocateController.text = data['willingToRelocate'] ?? '';
          relationShipYouAreLookingForController.text = data['typeOfRelationship'] ?? '';
          nationalityController.text = data['nationality'] ?? '';
          educationController.text = data['education'] ?? '';
          languageSpokenController.text = data['noOfLanguages'] ?? '';
          religionController.text = data['religion'] ?? '';
          ethnicityController.text = data['ethnicity'] ?? '';

        });
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveUserData();
  }



  // Updating the new information to the fireStore Database
  updateUserDataToFirestoreDatabase(

    // Personal Details...
    String name,
    String age,
    String phone,
    String city,
    String state,
    String country,
    String profileHeader,
    String lookingForInAPartner,
    int publishDateTime,

    // Appearance Details...
    String height,
    String weight,
    String complexion,
    String bodyType,

    // Life style details...
    String smoking,
    String drinking,
    String livingSituation,
    String income,
    String profession,
    String maritalStatus,
    String noOfChildren,
    String willingToRelocate,
    String typeOfRelationship,

    // Background details...
    String education,
    String noOfLanguages,
    String religion,
    String nationality,
    String ethnicity,
    ) async
  {

    // circular progress indicator...
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFFFD267D)),
                SizedBox(height: 16),
                Text("Uploading...", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      },
    );

    // the function to upload images...
    await uploadImages();

    await FirebaseFirestore
      .instance
      .collection("Users")
      .doc(currentUserId)
      .update({

      // Personal Details...
      'name': name,
      'age': age,
      'phone': phone,
      'city': city,
      'state': state,
      'country': country,
      'profileHeader': profileHeader,
      'lookingForInAPartner': lookingForInAPartner,
      'publishDateTime': publishDateTime,

      // Appearance Details...
      'height': height,
      'weight': weight,
      'complexion': complexion,
      'bodyType': bodyType,

      // Life Style details...
      'smoking': smoking,
      'drinking': drinking,
      'livingSituation': livingSituation,
      'profession': profession,
      'maritalStatus': maritalStatus,
      'noOfChildren': noOfChildren,
      'typeOfRelationship': typeOfRelationship,
      'willingToRelocate': willingToRelocate,

      // Background Details...
      'education': education,
      'noOfLanguages': noOfLanguages,
      'religion': religion,
      'nationality': nationality,
      'ethnicity': ethnicity,

      // Images...
      'images': urlsList[0].toString(),
      'images2': urlsList[1].toString(),
      'images3': urlsList[2].toString(),
      'images4': urlsList[3].toString(),
      'images5': urlsList[4].toString(),

    });

    Get.snackbar(
      "Account Updated",
      "Congratulations! your account has been updated successfully",
      backgroundColor: Color(0xD4FF2E81),
      borderRadius: 10,
      colorText: Colors.white,
      icon: Icon(Icons.done_outline_rounded, color: Colors.white),
      duration: Duration(seconds: 2),
      isDismissible: true,
      forwardAnimationCurve: Curves.bounceIn,
    );

    Get.off(HomeScreen());

    // Clearing the list...
    setState(() {
      uploading = false;
      _image.clear();
      urlsList.clear();
    });

  }

  // Fetching Images from gallery...
  chooseImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  // Uploading images to Firebase Storage after deleting old ones
  Future<void> uploadImages() async {
    try {
      // Step 1: Delete old images
      final ListResult oldImages = await FirebaseStorage.instance
          .ref('images/$currentUserId')
          .listAll();

      for (var fileRef in oldImages.items) {
        await fileRef.delete();
      }
      print("Old images deleted successfully.");

      // Step 2: Upload new images
      int i = 1;
      urlsList.clear(); // Clear local list too

      for (var img in _image) {
        setState(() {
          val = i / _image.length;
        });

        var refImage = FirebaseStorage.instance.ref().child(
          'images/$currentUserId/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        await refImage.putFile(img);

        String urlImage = await refImage.getDownloadURL();
        urlsList.add(urlImage);

        i++;
      }

      print("New images uploaded successfully:");
      print(urlsList);
    } catch (e) {
      print("Error uploading images: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color(0xFFFD267D),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          next ? "Profile Information" : "Profile Pictures",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          next
            ? Container()
            : IconButton(
              onPressed: () {

                if(_image.length == 5){
                  setState(() {
                    uploading = false;
                    next = true;
                  });
                }else{

                  // Dialog Box for uploading images...
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
                            Text(
                              "Please upload 5 images",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFD267D).withOpacity(0.8),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              iconSize: 28, // control icon size here
              padding: EdgeInsets.all(8), // control tap target size
              color: Color(0xFFFD267D),
              icon: Icon(Icons.manage_accounts_rounded),
            ),
        ],
      ),
      body:
        next
          ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  // Personal Details...
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'Personal Details :- ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        foreground:
                            Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[
                                  Color(0xFFFF7854), // orange
                                  Color(0xFFFD267D), // pink/magenta
                                ],
                              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                  ),

                  // Space from top...
                  SizedBox(height: 20),

                  // Name...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.person,
                      labelText: 'Name',
                      editingController: nameController,
                    ),
                  ),

                  // Age...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.calendar_month,
                      labelText: 'Age',
                      editingController: ageController,
                    ),
                  ),

                  // Phone No...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.phone,
                      labelText: 'Phone No',
                      editingController: phoneNoController,
                    ),
                  ),

                  // City...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.domain,
                      labelText: 'City',
                      editingController: cityController,
                    ),
                  ),

                  // State...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.map,
                      labelText: 'State',
                      editingController: stateController,
                    ),
                  ),

                  // Country...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.public,
                      labelText: 'Country',
                      editingController: countryController,
                    ),
                  ),

                  // Profile heading...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.text_fields,
                      labelText: 'Profile Heading',
                      editingController: profileHeadingController,
                    ),
                  ),

                  //Looking for...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.work,
                      labelText: 'Looking For',
                      editingController: lookingForInAPartnerController,
                    ),
                  ),

                  // Appearance Details...
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'Appearance Details :- ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        foreground:
                            Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[
                                  Color(0xFFFF7854), // orange
                                  Color(0xFFFD267D), // pink/magenta
                                ],
                              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                  ),

                  // Height...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.height,
                      labelText: 'Height',
                      editingController: heightController,
                    ),
                  ),

                  // Weight...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.monitor_weight_rounded,
                      labelText: 'Weight',
                      editingController: weightController,
                    ),
                  ),

                  // Body Type...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.accessibility_new,
                      labelText: 'Body Type',
                      editingController: bodyTypeController,
                    ),
                  ),

                  // Complexion...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.face,
                      labelText: 'Complexion',
                      editingController: complexionController,
                    ),
                  ),

                  // Life Style Details...
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'Life Style Details :- ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        foreground:
                            Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[
                                  Color(0xFFFF7854), // orange
                                  Color(0xFFFD267D), // pink/magenta
                                ],
                              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                  ),

                  // Smoking...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.smoking_rooms_rounded,
                      labelText: 'Smoking',
                      editingController: smokingController,
                    ),
                  ),

                  // Drinking...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.local_drink_rounded,
                      labelText: 'Drinking',
                      editingController: drinkingController,
                    ),
                  ),

                  //Living situation...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.home,
                      labelText: 'Living Situation',
                      editingController: livingSituationController,
                    ),
                  ),

                  // Income...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.attach_money_rounded,
                      labelText: 'Income',
                      editingController: incomeController,
                    ),
                  ),

                  // Willing to Relocate...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.location_on,
                      labelText: 'Are you willing to Relocate ?',
                      editingController: willingToRelocateController,
                    ),
                  ),

                  // Profession...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.work_rounded,
                      labelText: 'Profession',
                      editingController: professionController,
                    ),
                  ),

                  // Marital Status...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.family_restroom_rounded,
                      labelText: 'Marital Status',
                      editingController: maritalStatusController,
                    ),
                  ),

                  //No of Children...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.child_care_rounded,
                      labelText: 'No of Children',
                      editingController: noOfChildrenController,
                    ),
                  ),

                  //RelationShip looking for...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.family_restroom,
                      labelText: "What kind of relationship you're Looking For",
                      editingController: relationShipYouAreLookingForController,
                    ),
                  ),

                  // Background Details...
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'Background Or Cultural Values :- ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        foreground:
                            Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[
                                  Color(0xFFFF7854), // orange
                                  Color(0xFFFD267D), // pink/magenta
                                ],
                              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                  ),

                  // Education...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.school_rounded,
                      labelText: 'Qualification',
                      editingController: educationController,
                    ),
                  ),

                  // Language Known...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.language_rounded,
                      labelText: 'How many languages do you Known ?',
                      editingController: languageSpokenController,
                    ),
                  ),

                  // Religion...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.temple_hindu_rounded,
                      labelText: 'Religion',
                      editingController: religionController,
                    ),
                  ),

                  // Nationality...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.flag_rounded,
                      labelText: 'Nationality',
                      editingController: nationalityController,
                    ),
                  ),

                  // Ethnicity...
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      iconData: Icons.temple_buddhist,
                      labelText: 'Ethnicity',
                      editingController: ethnicityController,
                    ),
                  ),

                  // Space from top...
                  SizedBox(
                    height: 30,
                  ),

                  // Register button...
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFFFF7854), // orange
                          Color(0xFFFD267D), // pink/magenta
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        // Form Validation...
                        if (
                          // personal details...
                          nameController.text.trim().isNotEmpty &&
                          ageController.text.trim().isNotEmpty &&
                          phoneNoController.text.trim().isNotEmpty &&
                          cityController.text.trim().isNotEmpty &&
                          stateController.text.trim().isNotEmpty &&
                          countryController.text.trim().isNotEmpty &&
                          profileHeadingController.text.trim().isNotEmpty &&
                          lookingForInAPartnerController.text.trim().isNotEmpty &&
                          // Appearance details...
                          heightController.text.trim().isNotEmpty &&
                          weightController.text.trim().isNotEmpty &&
                          bodyTypeController.text.trim().isNotEmpty &&
                          complexionController.text.trim().isNotEmpty &&
                          // Lifestyle details...
                          smokingController.text.trim().isNotEmpty &&
                          drinkingController.text.trim().isNotEmpty &&
                          livingSituationController.text.trim().isNotEmpty &&
                          incomeController.text.trim().isNotEmpty &&
                          willingToRelocateController.text.trim().isNotEmpty &&
                          professionController.text.trim().isNotEmpty &&
                          maritalStatusController.text.trim().isNotEmpty &&
                          noOfChildrenController.text.trim().isNotEmpty &&
                          relationShipYouAreLookingForController.text.trim().isNotEmpty &&
                          // background details...
                          educationController.text.trim().isNotEmpty &&
                          languageSpokenController.text.trim().isNotEmpty &&
                          religionController.text.trim().isNotEmpty &&
                          nationalityController.text.trim().isNotEmpty &&
                          ethnicityController.text.trim().isNotEmpty) {

                          // Update and save user...

                          _image.isNotEmpty ?
                          await updateUserDataToFirestoreDatabase(
                            // Personal details...
                            nameController.text.trim(),
                            ageController.text.trim(),
                            phoneNoController.text.trim(),
                            cityController.text.trim(),
                            stateController.text.trim(),
                            countryController.text.trim(),
                            profileHeadingController.text.trim(),
                            lookingForInAPartnerController.text.trim(),
                            int.parse(DateTime.now().millisecondsSinceEpoch.toString()),

                            // Appearance details...
                            heightController.text.trim(),
                            weightController.text.trim(),
                            complexionController.text.trim(),
                            bodyTypeController.text.trim(),

                            // Lifestyle details...
                            smokingController.text.trim(),
                            drinkingController.text.trim(),
                            livingSituationController.text.trim(),
                            incomeController.text.trim(),
                            willingToRelocateController.text.trim(),
                            professionController.text.trim(),
                            maritalStatusController.text.trim(),
                            noOfChildrenController.text.trim(),
                            relationShipYouAreLookingForController.text.trim(),

                            // Background details...
                            educationController.text.trim(),
                            languageSpokenController.text.trim(),
                            religionController.text.trim(),
                            nationalityController.text.trim(),
                            ethnicityController.text.trim(),
                          ) : null;

                        } else {
                          Get.snackbar(
                            "Some form fields are missing",
                            "Please fill up all the credentials...",
                            backgroundColor: Color(0xD4FF2E81),
                            borderRadius: 10,
                            colorText: Colors.white,
                            icon: Icon(Icons.warning, color: Colors.white),
                            duration: Duration(seconds: 6),
                            isDismissible: true,
                            forwardAnimationCurve: Curves.bounceIn,
                            mainButton: TextButton(
                              child: Text("OK", style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Space from bottom...
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )
          : Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return index == 0
                      ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF7854), Color(0xFFFD267D)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              if(_image.length < 5) {
                                !uploading ? chooseImage() : null;
                              }else{
                                setState(() {
                                  uploading = true;
                                });
                                Get.snackbar(
                                  "Limit Exceeded",
                                  "You can upload maximum 5 images...",
                                  backgroundColor: Color(0xD4FF2E81).withOpacity(0.6),
                                  borderRadius: 10,
                                  colorText: Colors.white,
                                  icon: Icon(Icons.warning, color: Colors.white),
                                  duration: Duration(seconds: 6),
                                  isDismissible: true,
                                  forwardAnimationCurve: Curves.bounceIn,
                                  mainButton: TextButton(
                                    child: Text("OK", style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                );
                              }
                            },
                            iconSize: 49,
                            color: Colors.white,
                            icon: Icon(Icons.add),
                          ),
                        ),
                      )
                      : Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: FileImage(_image[index - 1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
    );
  }
}