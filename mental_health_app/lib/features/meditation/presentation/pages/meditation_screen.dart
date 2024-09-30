import 'package:flutter/material.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/meditation/presentation/widgets/feeling_button.dart';
import 'package:mental_health/features/meditation/presentation/widgets/task_card.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColors.white,
      appBar: AppBar(
        backgroundColor: DefaultColors.white,
        elevation: 0,
        leading: Image.asset('assets/images/menu_burger.png'),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Akuro... Chào cậu !',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 32,
              ),
              Text('Cậu cảm thấy hôm nay thế nào ?',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(
                height: 16,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FeelingButton(
                      label: 'Vui vẻ',
                      image: 'assets/images/happy.png',
                      color: DefaultColors.pink),
                  FeelingButton(
                      label: 'Yên bình',
                      image: 'assets/images/calm.png',
                      color: DefaultColors.purple),
                  FeelingButton(
                      label: 'Thư giản',
                      image: 'assets/images/relax.png',
                      color: DefaultColors.orange),
                  FeelingButton(
                      label: 'Tập trung',
                      image: 'assets/images/focus.png',
                      color: DefaultColors.lightteal),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Nhiệm vụ hôm nay',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              TaskCard(
                  title: 'Buổi sáng',
                  description: 'Chào hỏi ít nhất 5 người',
                  color: DefaultColors.task1),
              const SizedBox(
                height: 16,
              ),
              TaskCard(
                  title: 'Buổi trưa',
                  description:
                      'Ăn thật no, sau đó ngủ thật sâu, và nhớ đặt báo thức trước 2 giờ',
                  color: DefaultColors.task2),
              const SizedBox(
                height: 16,
              ),
              TaskCard(
                  title: 'Buổi chiều',
                  description: 'Đi chợ mua đồ ăn về nấu ăn',
                  color: DefaultColors.task3),
            ],
          ),
        ),
      ),
    );
  }
}
