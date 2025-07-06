import 'package:mental_health/features/music/data/models/song_model.dart';
import 'package:mental_health/core/services/firebase_service.dart';

abstract class SongRemoteDataSource {
  // dart không có interface
  Future<List<SongModel>> getAllSongs();
}

class SongRemoteDataSourceImp implements SongRemoteDataSource {
  final FirebaseService firebaseService;

  SongRemoteDataSourceImp({required this.firebaseService});

  @override
  Future<List<SongModel>> getAllSongs() async {
    return await firebaseService.getAllSongs();
  }
}
