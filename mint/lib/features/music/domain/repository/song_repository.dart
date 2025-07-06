import 'package:mental_health/features/music/domain/entities/song.dart';

abstract class SongRepository { // dart không có interface
  Future<List<Song>> getAllSongs();
}
