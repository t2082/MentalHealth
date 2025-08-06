import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/features/meditation/presentation/pages/meditation_wrapper_screen.dart';
import 'package:mental_health/features/music/presentation/pages/music_player_screen.dart';
import 'package:mental_health/features/music/presentation/pages/playlist_screen.dart';
import 'package:mental_health/features/tasks/presentation/pages/tasks_screen.dart';
import 'package:mental_health/features/connection/presentation/pages/connection_screen.dart';
import 'package:mental_health/features/settings/presentation/pages/settings_screen.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_bloc.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_state.dart';
import 'package:mental_health/presentation/bottomNavBar/widgets/bottom_nav_bar.dart';
import 'package:mental_health/core/widgets/time_based_background_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Widget> pages = [
    const MeditationWrapperScreen(), // Trang chủ
    const TasksScreen(), // Nhiệm vụ
    PlaylistScreen(), // Cảm xúc
    const ConnectionScreen(), // Kết nối
    const SettingsScreen(), // Cài đặt
  ];

  BottomNavigationBarItem createBottomNavItem({
    required IconData iconData,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TimeBasedBackgroundWidget(
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Để nền trong suốt để thấy Lottie background
        body: Stack(children: [
          BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              if (state is NavigationChange) {
                // state có phải kiểu NavigationChange không ?
                return pages[state.index];
              }
              return pages[0];
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<NavigationBloc, NavigationState>(
                builder: (context, state) {
              int currentIndex = 0;
              if (state is NavigationChange) {
                currentIndex = state.index;
              }
              final List<BottomNavigationBarItem> bottomNavItems = [
                createBottomNavItem(
                  iconData: Icons.home_rounded,
                  label: 'Trang chủ',
                ),
                createBottomNavItem(
                  iconData: Icons.task_alt_rounded,
                  label: 'Nhiệm vụ',
                ),
                createBottomNavItem(
                  iconData: Icons.favorite_rounded,
                  label: 'Âm nhạc',
                ),
                createBottomNavItem(
                  iconData: Icons.people_rounded,
                  label: 'Kết nối',
                ),
                createBottomNavItem(
                  iconData: Icons.settings_rounded,
                  label: 'Cài đặt',
                ),
              ];
              return BottomNavBar(
                  items: bottomNavItems, currentIndex: currentIndex);
            }),
          ),
        ]),
      ),
    );
  }
}
