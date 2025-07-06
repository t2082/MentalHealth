# Tasks Feature - Kiến trúc chuyên nghiệp

## Tổng quan
Feature Tasks đã được thiết kế lại với kiến trúc Clean Architecture, BLoC pattern và UI/UX chuyên nghiệp.

## Kiến trúc

### 1. Domain Layer (Lớp nghiệp vụ)
- **Entities**: Các đối tượng nghiệp vụ cốt lõi
  - `Task`: Đại diện cho một nhiệm vụ
  - `TaskCategory`: Đại diện cho danh mục nhiệm vụ

- **Repositories**: Interface cho việc truy cập dữ liệu
  - `TaskRepository`: Abstract repository cho Task operations

- **Use Cases**: Các trường hợp sử dụng cụ thể
  - `GetDailyTasks`: Lấy nhiệm vụ hàng ngày
  - `AddTask`: Thêm nhiệm vụ mới
  - `DeleteTask`: Xóa nhiệm vụ
  - `ToggleTaskCompletion`: Toggle trạng thái hoàn thành
  - `GetTaskStats`: Lấy thống kê nhiệm vụ

### 2. Data Layer (Lớp dữ liệu)
- **Models**: Các model để serialize/deserialize dữ liệu
  - `TaskModel`: Model cho Task entity
  - `TaskCategoryModel`: Model cho TaskCategory entity

- **Data Sources**: Nguồn dữ liệu
  - `TaskLocalDataSource`: Local storage sử dụng SharedPreferences

- **Repository Implementation**: Triển khai concrete của repository
  - `TaskRepositoryImpl`: Implementation của TaskRepository

### 3. Presentation Layer (Lớp giao diện)
- **BLoC**: Quản lý state
  - `TasksBloc`: BLoC chính cho Tasks feature
  - `TasksEvent`: Các events
  - `TasksState`: Các states

- **Pages**: Các màn hình
  - `TasksScreen`: Màn hình chính hiển thị danh sách nhiệm vụ
  - `AddEditTaskScreen`: Màn hình thêm/sửa nhiệm vụ

- **Widgets**: Các widget tái sử dụng
  - `TaskStatsCard`: Widget hiển thị thống kê
  - `TaskItemCard`: Widget hiển thị item nhiệm vụ
  - `TaskCategoryChip`: Widget chip danh mục

## Tính năng chính

### 1. Quản lý nhiệm vụ
- ✅ Thêm, sửa, xóa nhiệm vụ
- ✅ Toggle trạng thái hoàn thành
- ✅ Phân loại theo danh mục
- ✅ Đặt độ ưu tiên (Thấp, Trung bình, Cao)
- ✅ Thời gian ước tính
- ✅ Ngày hết hạn
- ✅ Tags và ghi chú

### 2. Giao diện người dùng
- ✅ Dark theme với gradient đẹp mắt
- ✅ Animations mượt mà
- ✅ Swipe actions (sửa, xóa)
- ✅ Pull-to-refresh
- ✅ Search và filter
- ✅ Sort theo nhiều tiêu chí

### 3. Thống kê và báo cáo
- ✅ Thống kê hôm nay
- ✅ Tỷ lệ hoàn thành
- ✅ Nhiệm vụ quá hạn
- ✅ Progress bar trực quan

### 4. Tính năng nâng cao
- ✅ Filter theo trạng thái
- ✅ Sort theo nhiều tiêu chí
- ✅ Search nhiệm vụ
- ✅ Xóa hàng loạt nhiệm vụ đã hoàn thành
- ✅ Demo data tự động

## Cách sử dụng

### 1. Khởi tạo
```dart
// Trong main.dart
await tasks_di.initTasksFeature();

// Thêm BLoC provider
BlocProvider(create: (context) => tasks_di.sl<TasksBloc>()),
```

### 2. Sử dụng trong widget
```dart
// Load nhiệm vụ hôm nay
context.read<TasksBloc>().add(const LoadTodayTasks());

// Thêm nhiệm vụ mới
context.read<TasksBloc>().add(AddTask(newTask));

// Toggle hoàn thành
context.read<TasksBloc>().add(ToggleTaskCompletion(taskId));
```

### 3. Lắng nghe state changes
```dart
BlocBuilder<TasksBloc, TasksState>(
  builder: (context, state) {
    if (state is TasksLoading) {
      return CircularProgressIndicator();
    }
    if (state is TasksLoaded) {
      return TasksList(tasks: state.tasks);
    }
    if (state is TasksError) {
      return ErrorWidget(message: state.message);
    }
    return SizedBox.shrink();
  },
)
```

## Dependencies
- `flutter_bloc`: State management
- `equatable`: Value equality
- `shared_preferences`: Local storage
- `flutter_slidable`: Swipe actions
- `get_it`: Dependency injection

## Demo Data
Hệ thống tự động tạo demo data khi chạy lần đầu, bao gồm:
- 10 nhiệm vụ mẫu
- Đa dạng danh mục
- Các trạng thái khác nhau
- Độ ưu tiên khác nhau
- Ngày hết hạn và tags

## Tương lai
- [ ] Sync với Firebase
- [ ] Notifications
- [ ] Recurring tasks
- [ ] Team collaboration
- [ ] Analytics nâng cao
- [ ] Export/Import data
- [ ] Offline support
- [ ] Widget cho home screen
