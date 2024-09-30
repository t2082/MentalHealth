import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mental_health/features/music/data/models/song_model.dart';

abstract class SongRemoteDataSource {
  // dart không có interface
  Future<List<SongModel>> getAllSongs();
}

class SongRemoteDataSourceImp implements SongRemoteDataSource {
  final http.Client client;

  SongRemoteDataSourceImp({required this.client});

  @override
  Future<List<SongModel>> getAllSongs() async {
    final response =
        await client.get(Uri.parse('http://10.0.2.2:6000/songs/all'));

    // print('RepStatusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      // print('RepBody: ${jsonResponse}');
      return jsonResponse.map((song) => SongModel.fromJson(song)).toList();
    } else {
      throw Exception('Fail to load model: song_remote_data_source.dart');
    }
  }
}
