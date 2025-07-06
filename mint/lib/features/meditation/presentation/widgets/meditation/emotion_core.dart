import 'package:flutter/material.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/meditation/presentation/widgets/meditation/feeling_button.dart';

class EmotionCore extends StatelessWidget {
  const EmotionCore({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FeelingButton(
          feeling: 'Mục tiêu',
          process: 0.6, // Đầy để test quotes dialog
          color: DefaultColors.dopamine,
          icon: 'assets/icons/target.svg',
          colorLight: DefaultColors.dopamineNeon,
        ),
        FeelingButton(
          feeling: 'Vận động',
          process: 1,
          color: DefaultColors.endorphin,
          icon: 'assets/icons/energy.svg',
          colorLight: DefaultColors.endorphinNeon,
        ),
        FeelingButton(
          feeling: 'Gắn kết',
          process: 0.3,
          color: DefaultColors.oxytocin,
          icon: 'assets/icons/heart.svg',
          colorLight: DefaultColors.oxytocinNeon,
        ),
        FeelingButton(
          feeling: 'Tự tin',
          process: 1.0, // Đầy để test quotes dialog
          color: DefaultColors.serotonin,
          icon: 'assets/icons/galaxy-star.svg',
          colorLight: DefaultColors.serotoninNeon,
        ),
      ],
    );
  }
}
