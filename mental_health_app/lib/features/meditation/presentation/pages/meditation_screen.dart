import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/meditation/presentation/bloc/daily_quote/daily_quote_bloc.dart';
import 'package:mental_health/features/meditation/presentation/bloc/daily_quote/daily_quote_state.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_messenge/mood_messenge_bloc.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_messenge/mood_messenge_event.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_messenge/mood_messenge_state.dart';

import 'package:mental_health/features/meditation/presentation/widgets/feeling_button.dart';
import 'package:mental_health/features/meditation/presentation/widgets/task_card.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DefaultColors.white,
        elevation: 0,
        leading: Image.asset('assets/images/menu_burger.png'),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
      backgroundColor: DefaultColors.white,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back, Akuro!',
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(
                height: 32,
              ),
              Text(
                'Cậu cảm thấy hôm nay thế nào ?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FeelingButton(
                      label: 'Vui vẻ',
                      image: 'assets/images/happy.png',
                      color: DefaultColors.pink,
                      onTap: () {
                        context
                            .read<MoodMessageBloc>()
                            .add(FetchMoodMessage('vui vẻ'));
                      }),
                  FeelingButton(
                      label: 'Yên bình',
                      image: 'assets/images/calm.png',
                      color: DefaultColors.purple,
                      onTap: () {
                        context
                            .read<MoodMessageBloc>()
                            .add(FetchMoodMessage('yên bình'));
                      }),
                  FeelingButton(
                      label: 'Thư giản',
                      image: 'assets/images/relax.png',
                      color: DefaultColors.orange,
                      onTap: () {
                        context
                            .read<MoodMessageBloc>()
                            .add(FetchMoodMessage('thư giản'));
                      }),
                  FeelingButton(
                      label: 'Tập trung',
                      image: 'assets/images/focus.png',
                      color: DefaultColors.lightteal,
                      onTap: () {
                        context
                            .read<MoodMessageBloc>()
                            .add(FetchMoodMessage('tập trung'));
                      })
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Nhiệm vụ hôm nay',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<DailyQuoteBloc, DailyQuoteState>(
                builder: (context, state) {
                  if (state is DailyQuoteLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is DailyQuoteLoaded) {
                    return Column(
                      children: [
                        TaskCard(
                          title: 'Buổi sáng',
                          description: state.dailyQuote.morningQuote,
                          color: DefaultColors.task1,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TaskCard(
                          title: 'Buổi trưa',
                          description: state.dailyQuote.noonQuote,
                          color: DefaultColors.task2,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TaskCard(
                          title: 'Buổi tối',
                          description: state.dailyQuote.everningQuote,
                          color: DefaultColors.task3,
                        )
                      ],
                    );
                  } else if (state is DailyQuoteError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Không có dữ liệu',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  }
                },
              ),
              BlocBuilder<MoodMessageBloc, MoodMessageState>(
                builder: (context, state) {
                  if (state is MoodMessageLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(
                                  'Lời khuyên dành cho cậu <3',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                content: Text(
                                  state.moodMessage.text,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context
                                            .read<MoodMessageBloc>()
                                            .add(ResetMoodMessage());
                                      },
                                      child: Text('Okay'))
                                ],
                              ));
                    });
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
