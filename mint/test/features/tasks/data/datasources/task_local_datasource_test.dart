import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health/features/tasks/data/datasources/task_local_datasource.dart';

void main() {
  group('TaskLocalDataSource', () {
    late TaskLocalDataSourceImpl dataSource;
    late SharedPreferences sharedPreferences;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      dataSource = TaskLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    });

    group('getDailyMicroTasks', () {
      test('should load micro tasks without error', () async {
        // Mock the asset loading
        const String mockJsonData = '''
        [
          {
            "id": "micro_task_0000001",
            "title": "Gọi điện cho người nhà",
            "description": "Đã bao lâu rồi bạn không gọi điện cho gia đình.",
            "target_roles": null,
            "required_majors": null,
            "dopamine": 0,
            "endorphin": 0,
            "oxytocin": 10,
            "serotonin": 0
          },
          {
            "id": "micro_task_0000002",
            "title": "Uống một cốc nước",
            "description": "Bổ sung nước cho cơ thể, giữ gìn sức khỏe.",
            "target_roles": null,
            "required_majors": null,
            "dopamine": 0,
            "endorphin": 0,
            "oxytocin": 0,
            "serotonin": 5
          },
          {
            "id": "micro_task_0000003",
            "title": "Dọn dẹp bàn làm việc",
            "description": "Sắp xếp lại không gian làm việc gọn gàng, ngăn nắp.",
            "target_roles": null,
            "required_majors": null,
            "dopamine": 8,
            "endorphin": 0,
            "oxytocin": 0,
            "serotonin": 0
          },
          {
            "id": "micro_task_0000004",
            "title": "Nghe một bài hát yêu thích",
            "description": "Thư giãn và tận hưởng âm nhạc trong 3-5 phút.",
            "target_roles": null,
            "required_majors": null,
            "dopamine": 6,
            "endorphin": 0,
            "oxytocin": 0,
            "serotonin": 0
          }
        ]
        ''';

        // Mock rootBundle.loadString
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'assets/datas/tasks/375_micro_tasks.json') {
              return mockJsonData;
            }
            return null;
          },
        );

        // Act
        final result = await dataSource.getDailyMicroTasks();

        // Assert
        expect(result, hasLength(3));
        expect(result.every((task) => task.tags.contains('micro-task')), isTrue);
        expect(result.every((task) => task.tags.contains('daily')), isTrue);
        expect(result.every((task) => task.priority == 1), isTrue);
        expect(result.every((task) => task.estimatedMinutes == 5), isTrue);
        expect(result.every((task) => !task.isCompleted), isTrue);
      });

      test('should return same tasks for same day', () async {
        // Mock the asset loading
        const String mockJsonData = '''
        [
          {
            "id": "micro_task_0000001",
            "title": "Task 1",
            "description": "Description 1",
            "target_roles": null,
            "required_majors": null,
            "dopamine": 0,
            "endorphin": 0,
            "oxytocin": 10,
            "serotonin": 0
          },
          {
            "id": "micro_task_0000002",
            "title": "Task 2",
            "description": "Description 2",
            "target_roles": null,
            "required_majors": null,
            "dopamine": 0,
            "endorphin": 0,
            "oxytocin": 0,
            "serotonin": 5
          },
          {
            "id": "micro_task_0000003",
            "title": "Task 3",
            "description": "Description 3",
            "target_roles": null,
            "required_majors": null,
            "dopamine": 8,
            "endorphin": 0,
            "oxytocin": 0,
            "serotonin": 0
          }
        ]
        ''';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString') {
              return mockJsonData;
            }
            return null;
          },
        );

        // Act - Call multiple times
        final result1 = await dataSource.getDailyMicroTasks();
        final result2 = await dataSource.getDailyMicroTasks();

        // Assert - Should return same tasks (same order) for same day
        expect(result1.length, equals(result2.length));
        for (int i = 0; i < result1.length; i++) {
          expect(result1[i].title, equals(result2[i].title));
        }
      });
    });
  });
}
