import 'package:dating_app/Controllers/authentication_controller.dart';
import 'package:dating_app/authenticationScreen/registration_screen.dart';
import 'package:dating_app/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Controllers for textFields...
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // indicator for progress bar...
  bool showProgressBar = false;

  var authenticationController = AuthenticationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [

              // space from top...
              SizedBox(
                height: 100,
              ),

              // Logo...
              Image.asset(
               'images/logo.webp',
                width: 280,
              ),

                // Welcome Text...
              Text(
                'Welcome to Flare',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[
                        Color(0xFFFF7854), // orange
                        Color(0xFFFD267D), // pink/magenta
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ).createShader(
                      Rect.fromLTWH(0.0, 0.0, 300.0, 40.0), // width/height: tweak or compute dynamically
                    ),
                ),
              ),

              // space from top...
              SizedBox(
                height: 10,
              ),

              // Quick Login Text...
              Text(
                "Login now to find your perfect partner",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  ),
               ),

              // space from top...
              SizedBox(
                height: 60,
              ),

              // email textField...
              SizedBox(
                width: MediaQuery.of(context).size.width-36,
                child: CustomTextFieldWidget(
                  iconData: Icons.email_outlined,
                  labelText: 'Email',
                  editingController: emailController,
                ),
              ),

              // password textField...
              SizedBox(
                width: MediaQuery.of(context).size.width-36,
                child: CustomTextFieldWidget(
                  iconData: Icons.lock_outline_rounded,
                  labelText: 'Password',
                  editingController: passwordController,
                  isObscure: true,
                ),
              ),

              // space from top...
              SizedBox(
                height: 30.0,
              ),

              // login button...
              Container(
                width: MediaQuery.of(context).size.width-36,
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

                    if(emailController.text.trim().isNotEmpty &&
                      passwordController.text.trim().isNotEmpty) {

                      setState(() {
                        showProgressBar = !showProgressBar;
                      });

                      await authenticationController.loginUser(emailController.text.trim(), passwordController.text.trim());

                      setState(() {
                        showProgressBar = !showProgressBar;
                      });

                    }else{
                      Get.snackbar(
                        "Email or Password is missing",
                        "Please fill all the Credentials...",
                        backgroundColor: Colors.black,
                        borderRadius: 10,
                        colorText: Colors.white,
                        icon: Icon(Icons.warning, color: Color(0xD4FF2E81)),
                        duration: Duration(seconds: 6),
                        isDismissible: true,
                        forwardAnimationCurve: Curves.bounceIn,
                        mainButton : TextButton(
                          child: Text("OK", style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      );
                    }
                  },

                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),

              // space from top...
              SizedBox(
                height: 30.0,
              ),

              // Create Account Text...
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New to Flare? ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showProgressBar = !showProgressBar;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                      setState(() {
                        showProgressBar = !showProgressBar;
                      });
                      },
                    child: Text(
                      "Create an Account",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: <Color>[
                              Color(0xFFFF7854), // orange
                              Color(0xFFFD267D), // pink/magenta
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ).createShader(
                            Rect.fromLTWH(0.0, 0.0, 300.0, 40.0), // width/height: tweak or compute dynamically
                          ),
                      ),
                    ),
                  ),
                ],
              ),

              // space from top...
              SizedBox(
                height: 60.0,
              ),

              // progress bar...
              showProgressBar
                ? const CircularProgressIndicator(
                strokeWidth: 3.0,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFFD267D),
                ),
              )
                : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
