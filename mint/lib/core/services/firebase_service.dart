import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health/features/meditation/data/models/daily_quote_model.dart';
import 'package:mental_health/features/meditation/data/models/mood_messenge_model.dart';
import 'package:mental_health/features/music/data/models/song_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Meditation Services
  Future<DailyQuoteModel> getDailyQuote() async {
    try {
      // Lấy quote ngẫu nhiên từ collection 'daily_quotes'
      final querySnapshot = await _firestore.collection('daily_quotes').get();

      if (querySnapshot.docs.isNotEmpty) {
        // Chọn ngẫu nhiên một quote
        final randomIndex = DateTime.now().day % querySnapshot.docs.length;
        final doc = querySnapshot.docs[randomIndex];
        final data = doc.data();

        return DailyQuoteModel.fromJson({
          'text': data['text'] ??
              '{"morningQuote":"Take time to make your soul happy.","noonQuote":"Breathe and be present.","eveningQuote":"Rest and reflect on your day."}',
        });
      } else {
        // Fallback quote nếu không có dữ liệu
        return DailyQuoteModel.fromJson({
          'text':
              '{"morningQuote":"Take time to make your soul happy.","noonQuote":"Breathe and be present.","eveningQuote":"Rest and reflect on your day."}',
        });
      }
    } catch (e) {
      throw Exception('Failed to load daily quote: $e');
    }
  }

  Future<MoodMessengeModel> getMoodMessage(String mood) async {
    try {
      // Lấy message theo mood từ collection 'mood_messages'
      final querySnapshot = await _firestore
          .collection('mood_messages')
          .where('mood', isEqualTo: mood.toLowerCase())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Chọn ngẫu nhiên một message cho mood đó
        final randomIndex =
            DateTime.now().millisecond % querySnapshot.docs.length;
        final doc = querySnapshot.docs[randomIndex];

        return MoodMessengeModel.fromJson({
          'text': doc.data()['text'] ?? 'You are doing great! Keep going.',
        });
      } else {
        // Fallback message nếu không có dữ liệu cho mood đó
        return MoodMessengeModel.fromJson({
          'text': 'You are doing great! Keep going.',
        });
      }
    } catch (e) {
      throw Exception('Failed to load mood message: $e');
    }
  }

  // Music Services
  Future<List<SongModel>> getAllSongs() async {
    try {
      final querySnapshot = await _firestore.collection('songs').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return SongModel.fromJson({
          'id': doc.id,
          'title': data['title'] ?? '',
          'author': data['author'] ?? '',
          'songlink': data['songlink'] ?? '',
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to load songs: $e');
    }
  }

  // Helper methods để thêm dữ liệu mẫu (có thể dùng để setup ban đầu)
  Future<void> addSampleData() async {
    try {
      // Thêm sample daily quotes
      await _firestore.collection('daily_quotes').add({
        'text':
            '{"morningQuote":"The only way to do great work is to love what you do.","noonQuote":"Innovation distinguishes between a leader and a follower.","eveningQuote":"Stay hungry, stay foolish."}',
      });

      await _firestore.collection('daily_quotes').add({
        'text':
            '{"morningQuote":"Life is what happens to you while you\'re busy making other plans.","noonQuote":"A dream you dream alone is only a dream.","eveningQuote":"All you need is love."}',
      });

      // Thêm sample mood messages
      await _firestore.collection('mood_messages').add({
        'mood': 'happy',
        'text':
            'Your happiness is contagious! Keep spreading those positive vibes.',
      });

      await _firestore.collection('mood_messages').add({
        'mood': 'sad',
        'text':
            'It\'s okay to feel sad sometimes. Remember, this feeling will pass.',
      });

      await _firestore.collection('mood_messages').add({
        'mood': 'calm',
        'text': 'Your peaceful energy is beautiful. Stay centered and serene.',
      });

      await _firestore.collection('mood_messages').add({
        'mood': 'focus',
        'text': 'Your focus is your superpower. Channel it wisely.',
      });

      // Thêm sample songs
      await _firestore.collection('songs').add({
        'title': 'Peaceful Morning',
        'author': 'Nature Sounds',
        'songlink': 'https://example.com/peaceful-morning.mp3',
      });

      await _firestore.collection('songs').add({
        'title': 'Meditation Bells',
        'author': 'Zen Master',
        'songlink': 'https://example.com/meditation-bells.mp3',
      });
    } catch (e) {
      print('Error adding sample data: $e');
    }
  }
}
