import 'package:mental_health/core/services/firebase_service.dart';

class FirebaseDataSeeder {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> seedInitialData() async {
    try {
      print('🌱 Seeding initial data to Firebase...');
      await _firebaseService.addSampleData();
      print('✅ Initial data seeded successfully!');
    } catch (e) {
      print('❌ Error seeding data: $e');
    }
  }
}
