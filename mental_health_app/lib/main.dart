import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/music/data/datasources/song_remote_data_source.dart';
import 'package:mental_health/features/music/data/repository/song_repository_impl.dart';
import 'package:mental_health/features/music/domain/usecases/get_all_songs.dart';
import 'package:mental_health/features/music/presentation/bloc/song_bloc.dart';
import 'package:mental_health/features/music/presentation/bloc/song_event.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_bloc.dart';
import 'package:mental_health/presentation/homePage/home_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationBloc()),
          BlocProvider(
              create: (_) => SongBloc(
                  getAllSongs: GetAllSongs(
                      repository: SongRepositoryImpl(
                          remoteDataSource:
                              SongRemoteDataSourceImp(client: http.Client()))))
                ..add(FetchSongs()))
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: HomeScreen()));
  }
}
