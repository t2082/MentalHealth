import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/core/theme.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import '../../domain/entities/task.dart';
import 'add_edit_task_screen.dart';

/// Màn hình Nhiệm vụ chuyên nghiệp với thiết kế glassmorphism
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late AnimationController _headerAnimationController;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Load dữ liệu ban đầu
    context.read<TasksBloc>().add(const LoadTodayTasks());

    // Bắt đầu animation
    _headerAnimationController.forward();
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildModernAppBar(),
      body: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              _buildTaskStatsSection(),
              _buildQuickActionsSection(),
              _buildTasksListSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildModernFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: 100,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            spacing: 12,
            children: [
              // Modern Stats Container with Glassmorphism
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tasks Counter
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            DefaultColors.endorphin.withValues(alpha: 0.8),
                            DefaultColors.endorphinNeon.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.task_alt,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '12',
                            style: TextPresets.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Completed Counter
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            DefaultColors.serotonin.withValues(alpha: 0.8),
                            DefaultColors.serotoninNeon.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '8',
                            style: TextPresets.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Search Button
                    GestureDetector(
                      onTap: _showSearchDialog,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              DefaultColors.dopamine.withValues(alpha: 0.8),
                              DefaultColors.dopamineNeon.withValues(alpha: 0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  DefaultColors.dopamine.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Modern Menu Button
              GestureDetector(
                onTap: () => _showMenuDialog(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        DefaultColors.oxytocin.withValues(alpha: 0.3),
                        DefaultColors.oxytocinNeon.withValues(alpha: 0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: DefaultColors.oxytocin.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.more_vert, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    DefaultColors.endorphin.withValues(alpha: 0.2),
                    DefaultColors.endorphinNeon.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                color: DefaultColors.endorphinNeon,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nhiệm vụ hôm nay', style: TextPresets.subTitle),
                  Text('Hãy hoàn thành mục tiêu của bạn!',
                      style: TextPresets.title),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bạn đã hoàn thành 8/12 nhiệm vụ',
                      style: TextPresets.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Tiếp tục phấn đấu để đạt mục tiêu!',
                      style: TextPresets.bodySmall.copyWith(),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      DefaultColors.serotonin.withValues(alpha: 0.3),
                      DefaultColors.serotoninNeon.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: DefaultColors.serotoninNeon,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            DefaultColors.dopamine.withValues(alpha: 0.9),
            DefaultColors.dopamineNeon.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: DefaultColors.dopamine.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _addNewTask,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildTaskStatsSection() {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is TasksLoaded && state.stats != null) {
          final stats = state.stats!;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: DfBRadius.defaultRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.18),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            DefaultColors.dopamine.withValues(alpha: 0.2),
                            DefaultColors.dopamineNeon.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.analytics_rounded,
                        color: DefaultColors.dopamineNeon,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Thống kê hôm nay', style: TextPresets.title),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            DefaultColors.serotonin.withValues(alpha: 0.2),
                            DefaultColors.serotoninNeon.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Text(
                        '${stats.todayCompletedTasks}/${stats.todayTasks}',
                        style: TextPresets.label,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Hoàn thành',
                        '${stats.todayCompletedTasks}',
                        Icons.check_circle_rounded,
                        DefaultColors.serotonin,
                        DefaultColors.serotoninNeon,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Còn lại',
                        '${stats.todayTasks - stats.todayCompletedTasks}',
                        Icons.pending_rounded,
                        DefaultColors.endorphin,
                        DefaultColors.endorphinNeon,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Quá hạn',
                        '${stats.overdueTasks}',
                        Icons.warning_rounded,
                        DefaultColors.oxytocin,
                        DefaultColors.oxytocinNeon,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color primaryColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.1),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: accentColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextPresets.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextPresets.bodySmall.copyWith(
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Tìm kiếm nhiệm vụ',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nhập từ khóa...',
            hintStyle: TextStyle(color: Colors.white54),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          onChanged: (query) {
            context.read<TasksBloc>().add(SearchTasks(query));
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showMenuDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Tùy chọn',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.filter_list, color: Colors.white70),
              title: const Text('Lọc nhiệm vụ',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showFilterDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort, color: Colors.white70),
              title:
                  const Text('Sắp xếp', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showSortDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.red),
              title: const Text('Xóa đã hoàn thành',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteCompletedDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: DfBRadius.defaultRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      DefaultColors.oxytocin.withValues(alpha: 0.2),
                      DefaultColors.oxytocinNeon.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.flash_on_rounded,
                  color: DefaultColors.oxytocinNeon,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text('Hành động nhanh', style: TextPresets.title),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Thêm nhiệm vụ',
                  Icons.add_task_rounded,
                  DefaultColors.dopamine,
                  DefaultColors.dopamineNeon,
                  _addNewTask,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  'Lọc & Sắp xếp',
                  Icons.filter_list_rounded,
                  DefaultColors.serotonin,
                  DefaultColors.serotoninNeon,
                  _showFilterDialog,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color primaryColor,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withValues(alpha: 0.1),
              accentColor.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: accentColor, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextPresets.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksListSection() {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is TasksLoading) {
          return Container(
            padding: const EdgeInsets.all(40),
            child: const Center(
              child:
                  CircularProgressIndicator(color: DefaultColors.dopamineNeon),
            ),
          );
        }

        if (state is TasksError) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: DfBRadius.defaultRadius,
              gradient: LinearGradient(
                colors: [
                  Colors.red.withValues(alpha: 0.1),
                  Colors.red.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Có lỗi xảy ra',
                  style: TextPresets.title.copyWith(color: Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextPresets.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<TasksBloc>().add(const RefreshTasks());
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (state is TasksLoaded) {
          if (state.filteredAndSortedTasks.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                borderRadius: DfBRadius.defaultRadius,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                ),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          DefaultColors.endorphin.withValues(alpha: 0.2),
                          DefaultColors.endorphinNeon.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.task_alt_rounded,
                      color: DefaultColors.endorphinNeon,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Chưa có nhiệm vụ nào', style: TextPresets.title),
                  const SizedBox(height: 8),
                  Text(
                    'Hãy thêm nhiệm vụ đầu tiên của bạn!',
                    style: TextPresets.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          DefaultColors.endorphin.withValues(alpha: 0.2),
                          DefaultColors.endorphinNeon.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.list_alt_rounded,
                      color: DefaultColors.endorphinNeon,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Danh sách nhiệm vụ', style: TextPresets.title),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          DefaultColors.endorphin.withValues(alpha: 0.2),
                          DefaultColors.endorphinNeon.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Text(
                      '${state.filteredAndSortedTasks.length} nhiệm vụ',
                      style: TextPresets.label,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...state.filteredAndSortedTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildModernTaskCard(task),
                  )),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildModernTaskCard(Task task) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: DfBRadius.defaultRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Completion Checkbox
          GestureDetector(
            onTap: () {
              context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: task.isCompleted
                    ? LinearGradient(
                        colors: [
                          DefaultColors.serotonin,
                          DefaultColors.serotoninNeon,
                        ],
                      )
                    : null,
                border: Border.all(
                  color: task.isCompleted
                      ? DefaultColors.serotoninNeon
                      : Colors.black.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          // Task Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextPresets.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.black,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextPresets.bodySmall.copyWith(
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Priority Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _getPriorityColor(task.priority)
                            .withValues(alpha: 0.2),
                      ),
                      child: Text(
                        task.priorityText,
                        style: TextPresets.labelSmall.copyWith(
                          color: _getPriorityColor(task.priority),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: DefaultColors.endorphin.withValues(alpha: 0.2),
                      ),
                      child: Text(
                        task.category.name,
                        style: TextPresets.labelSmall.copyWith(
                          color: DefaultColors.endorphin,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Due Date
                    if (task.dueDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: task.isOverdue
                              ? Colors.red.withValues(alpha: 0.2)
                              : DefaultColors.oxytocin.withValues(alpha: 0.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: task.isOverdue
                                  ? Colors.red
                                  : DefaultColors.oxytocin,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(task.dueDate!),
                              style: TextPresets.labelSmall.copyWith(
                                color: task.isOverdue
                                    ? Colors.red
                                    : DefaultColors.oxytocin,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Action Menu
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black.withValues(alpha: 0.5),
              size: 20,
            ),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editTask(task);
                  break;
                case 'delete':
                  _deleteTask(task);
                  break;
                case 'details':
                  _showTaskDetails(task);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'details',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16),
                    SizedBox(width: 8),
                    Text('Chi tiết'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 16),
                    SizedBox(width: 8),
                    Text('Chỉnh sửa'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Xóa', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return DefaultColors.serotonin;
      case 2:
        return DefaultColors.endorphin;
      case 3:
        return DefaultColors.oxytocin;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Hôm nay';
    } else if (taskDate == tomorrow) {
      return 'Ngày mai';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Lọc nhiệm vụ',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskFilter.values.map((filter) {
            String title;
            switch (filter) {
              case TaskFilter.all:
                title = 'Tất cả';
                break;
              case TaskFilter.completed:
                title = 'Đã hoàn thành';
                break;
              case TaskFilter.pending:
                title = 'Chưa hoàn thành';
                break;
              case TaskFilter.overdue:
                title = 'Quá hạn';
                break;
              case TaskFilter.today:
                title = 'Hôm nay';
                break;
              case TaskFilter.upcoming:
                title = 'Sắp đến hạn';
                break;
            }

            return ListTile(
              title: Text(title, style: const TextStyle(color: Colors.white)),
              onTap: () {
                context.read<TasksBloc>().add(ChangeTaskFilter(filter));
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Sắp xếp nhiệm vụ',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskSortOrder.values.map((sortOrder) {
            String title;
            switch (sortOrder) {
              case TaskSortOrder.createdDateAsc:
                title = 'Ngày tạo (cũ → mới)';
                break;
              case TaskSortOrder.createdDateDesc:
                title = 'Ngày tạo (mới → cũ)';
                break;
              case TaskSortOrder.priorityAsc:
                title = 'Độ ưu tiên (thấp → cao)';
                break;
              case TaskSortOrder.priorityDesc:
                title = 'Độ ưu tiên (cao → thấp)';
                break;
              case TaskSortOrder.dueDateAsc:
                title = 'Hạn chót (sớm → muộn)';
                break;
              case TaskSortOrder.dueDateDesc:
                title = 'Hạn chót (muộn → sớm)';
                break;
              case TaskSortOrder.titleAsc:
                title = 'Tên (A → Z)';
                break;
              case TaskSortOrder.titleDesc:
                title = 'Tên (Z → A)';
                break;
            }

            return ListTile(
              title: Text(title, style: const TextStyle(color: Colors.white)),
              onTap: () {
                context.read<TasksBloc>().add(ChangeTaskSort(sortOrder));
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Xóa nhiệm vụ đã hoàn thành',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả nhiệm vụ đã hoàn thành?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TasksBloc>().add(const DeleteCompletedTasks());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditTaskScreen(),
      ),
    );
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                task.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                task.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: DefaultColors.endorphin.withValues(alpha: 0.2),
                ),
                child: Text(
                  task.category.name,
                  style: TextPresets.label.copyWith(
                    color: DefaultColors.endorphin,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _editTask(task);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Sửa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteTask(task);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Xóa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Xóa nhiệm vụ',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa nhiệm vụ "${task.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TasksBloc>().add(DeleteTask(task.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
