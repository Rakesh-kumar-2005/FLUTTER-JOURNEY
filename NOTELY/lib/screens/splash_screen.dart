import 'package:flutter/material.dart';
import 'package:notely/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool isZoomingOut = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Initial animation: zoom in → normal (5.0 → 1.0)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !isZoomingOut) {
        // Start zoom-out animation (1.0 → 10.0)
        isZoomingOut = true;
        _controller.reset();

        setState(() {
          _scaleAnimation = Tween<double>(begin: 1.4, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
          );
        });

        _controller.forward();
      } else if (status == AnimationStatus.completed && isZoomingOut) {
        // Navigate after second animation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: 500,
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/welcome.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
