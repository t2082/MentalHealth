import 'package:mental_health/features/music/domain/entities/song.dart';

class SongModel extends Song {
  SongModel(
      {required super.id,
      required super.title,
      required super.author,
      required super.songlink});

  factory SongModel.fromJson(Map<String, dynamic> json) { // để khởi tạo một đối tượng từ một nguồn dữ liệu bên ngoài (Json)
    return SongModel(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        songlink: json['songlink']);
  } // Lấy các khóa Json bên ngoài truyền vào Song Model
}
