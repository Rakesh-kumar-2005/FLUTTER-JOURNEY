import 'dart:io';

import 'package:dating_app/Controllers/authentication_controller.dart';
import 'package:dating_app/authenticationScreen/gender_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text_field_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Personal Details...
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  String? selectedGender;
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

  // Progress Bar...
  bool showProgressBar = false;

  var authenticationController = AuthenticationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main Body...
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [

              // images...
              Image.asset(
                'images/register.png',
                width: MediaQuery.of(context).size.width * .7,
                height: 380,
              ),

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
              SizedBox(
                height: 20,
              ),

              // Profile Picture Edit button...
              Stack(
                children: [
                  authenticationController.profileImage == null
                      ? Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFFE83546), width: 2),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 80,
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white, // orange
                          ),
                        ),
                      )
                      : Container(
                        height: 190,
                        width: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(File(authenticationController.profileImage!.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFE83546), width: 1),
                      ),

                      // Edit Button...
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (BuildContext context) {
                              return Container(
                                height: 270,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  color: Colors.black,
                                  border: Border(
                                    top: BorderSide(color: Color(0xFFE83546), width: 2),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Pick Your Profile picture from",
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),

                                    // Space from top...
                                    SizedBox(height: 60),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Camera Option
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await authenticationController
                                                    .captureImageFromCamera();
                                                Navigator.pop(context);
                                              },
                                              child: Image.asset('images/camera.png', width: 70),
                                            ),
                                            Text(
                                              "Camera",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Gallery Option
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await authenticationController
                                                    .getImageFromGallery();
                                                Navigator.pop(context);
                                              },
                                              child: Image.asset('images/gallery.png', width: 70),
                                            ),
                                            Text(
                                              "Gallery",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit, color: Color(0xFFF1583C)),
                        iconSize: 30,
                      ),
                    ),
                  ),
                ],
              ),

              // space from top...
              SizedBox(
                height: 10,
              ),

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

              // Sex...
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width - 36,
                child: GenderDropdown(
                  onChanged: (value) {
                    selectedGender = value;
                  },
                ),
              ),

              // Email...
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextFieldWidget(
                  iconData: Icons.email,
                  labelText: 'Email',
                  editingController: emailController,
                ),
              ),

              // Password...
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextFieldWidget(
                  iconData: Icons.lock,
                  labelText: 'Password',
                  isObscure: true,
                  editingController: passwordController,
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

                    // Profile Picture validation...
                    if(authenticationController.profileImage != null){

                      // Form Validation...
                      if(

                      // personal details...
                      nameController.text.trim().isNotEmpty &&
                      ageController.text.trim().isNotEmpty &&
                      selectedGender != null && selectedGender!.isNotEmpty &&
                      emailController.text.trim().isNotEmpty &&
                      passwordController.text.trim().isNotEmpty &&
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
                      ethnicityController.text.trim().isNotEmpty
                      ){


                        setState(() {
                          showProgressBar = true;
                        });

                        // Create user...
                        await authenticationController.createNewUserAccount(

                        // Personal details...
                        authenticationController.profileImage!,
                        nameController.text.trim(),
                        ageController as int,
                        selectedGender!,
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        phoneNoController.text.trim(),
                        cityController.text.trim(),
                        stateController.text.trim(),
                        countryController.text.trim(),
                        profileHeadingController.text.trim(),
                        lookingForInAPartnerController.text.trim(),
                        int.parse(DateTime.now().millisecondsSinceEpoch.toString()),
                        heightController.text.trim(),
                        weightController.text.trim(),
                        complexionController.text.trim(),
                        bodyTypeController.text.trim(),

                        // Lifestyle details...
                        smokingController.text.trim(),
                        drinkingController.text.trim(),
                        livingSituationController.text.trim(),
                        incomeController.text.trim(),
                        professionController.text.trim(),
                        maritalStatusController.text.trim(),
                        noOfChildrenController.text.trim(),
                        relationShipYouAreLookingForController.text.trim(),
                        educationController.text.trim(),
                        languageSpokenController.text.trim(),
                        religionController.text.trim(),
                        nationalityController.text.trim(),
                        ethnicityController.text.trim(),
                        );

                        setState(() {
                          showProgressBar = false;
                          authenticationController.pickedFile.value = null;
                        });


                      }else{
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

                    }else{
                      Get.snackbar(
                        "Image file missing",
                        "Please pick an image from Gallery or capture with camera...",
                        backgroundColor: Color(0xD4FF2E81),
                        borderRadius: 10,
                        colorText: Colors.white,
                        icon: Icon(Icons.warning, color: Colors.white),
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
                  },
                  child: Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Space from top...
              SizedBox(
                height: 10,
              ),

              // Login Text...
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login Here",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        foreground:
                            Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[
                                  Color(0xFFFF7854), // orange
                                  Color(0xFFFD267D), // pink/magenta
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ).createShader(
                                Rect.fromLTWH(
                                  0.0,
                                  0.0,
                                  300.0,
                                  40.0,
                                ), // width/height: tweak or compute dynamically
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              // Space from bottom...
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
