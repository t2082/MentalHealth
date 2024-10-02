import 'package:flutter/material.dart';
import 'package:mental_health/presentation/homePage/home_page.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Chạm vào để tiếp tục',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).focusColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
