import 'package:flutter/material.dart';
import 'package:mental_health/core/theme.dart';

class Background extends StatelessWidget {
  // final Widget child;

  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 223, 255, 202),
            DefaultColors.background,
            DefaultColors.background,
            Color.fromARGB(255, 223, 255, 202),
          ],
          stops: [0.0, 0.3, 0.8, 1],
        ),
      ),
      // child: child,
    );
  }
}
