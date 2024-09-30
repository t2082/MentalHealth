import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/core/theme.dart';
// import 'package:http/http.dart' as http;
import 'package:mental_health/features/music/presentation/bloc/song_bloc.dart';
import 'package:mental_health/features/music/presentation/bloc/song_state.dart';
import 'package:mental_health/features/music/presentation/pages/music_player_screen.dart';

class PlaylistScreen extends StatelessWidget {
  PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Danh sách phát hôm nay',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          backgroundColor: DefaultColors.white,
          elevation: 1,
          centerTitle: false,
        ),
        body: BlocBuilder<SongBloc, SongState>(
          builder: (context, state) {
            if (state is SongLoading) {
              // Hiện loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SongLoaded) {
              //Hiện Nhạc
              return Container(
                color: DefaultColors.white,
                child: ListView.builder(
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/child_with_dog.png'),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                        title: Text(
                          state.songs[index].title,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        subtitle: Text(
                          state.songs[index].author,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MusicPlayerScreen(
                                        song: state.songs[index],
                                      )));
                          // SongRemoteDataSourceImp(client: http.Client())
                          //     .getAllSongs();
                        },
                      );
                    }),
              );
            } else if (state is SongError) {
              //Hiện lỗi
              return Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.archive_outlined,
                      size: 56,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    Text(
                      'Không có nhạc để hiển thị',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
