import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mental_health/presentation/onboarding/onboarding.dart';
import 'package:mental_health/injection_container.dart' as di;
import 'package:mental_health/features/tasks/injection_container.dart'
    as tasks_di;
import 'package:mental_health/features/meditation/presentation/bloc/daily_quote/daily_quote_bloc.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_messenge/mood_messenge_bloc.dart';
import 'package:mental_health/features/music/presentation/bloc/song_bloc.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_bloc.dart';
import 'package:mental_health/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:mental_health/features/quotes/presentation/bloc/quote_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize dependency injection
  await di.init();
  await tasks_di.initTasksFeature();
  // Wait for async dependencies to be ready
  await di.sl.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (context) => di.sl<NavigationBloc>(),
        ),
        BlocProvider<DailyQuoteBloc>(
          create: (context) => di.sl<DailyQuoteBloc>(),
        ),
        BlocProvider<MoodMessageBloc>(
          create: (context) => di.sl<MoodMessageBloc>(),
        ),
        BlocProvider<SongBloc>(
          create: (context) => di.sl<SongBloc>(),
        ),
        BlocProvider<TasksBloc>(
          create: (context) => tasks_di.sl<TasksBloc>(),
        ),
        BlocProvider<QuoteBloc>(
          create: (context) => di.sl<QuoteBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Mental Health App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            home: const OnBoardingScreen(),
          );
        },
      ),
    );
  }
}
