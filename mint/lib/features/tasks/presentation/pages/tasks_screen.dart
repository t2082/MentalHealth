import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    context.read<TasksBloc>().add(const LoadDailyMicroTasks());

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
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              spacing: 16.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35.h),
                _buildWelcomeSection(),
                _buildAddTaskSection(),
                _buildMicroTasksSection(),
                SizedBox(height: 80.h),
              ],
            ),
          ),
          _buildAppbar()
        ]),
      ),
      // floatingActionButton: _buildModernFloatingActionButton(),
    );
  }

  Widget _buildAppbar() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 12,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      const Icon(Icons.task_alt, color: Colors.white, size: 16),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              ],
            ),
          ),
          // Modern Menu Button
          // GestureDetector(
          //   onTap: () => _showMenuDialog(),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       gradient: LinearGradient(
          //         colors: [
          //           DefaultColors.oxytocin.withValues(alpha: 0.3),
          //           DefaultColors.oxytocinNeon.withValues(alpha: 0.1),
          //         ],
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: DefaultColors.oxytocin.withValues(alpha: 0.2),
          //           blurRadius: 12,
          //           spreadRadius: 0,
          //           offset: const Offset(0, 4),
          //         ),
          //       ],
          //     ),
          //     child: const CircleAvatar(
          //       radius: 20,
          //       backgroundColor: Colors.transparent,
          //       child: Icon(Icons.more_vert, color: Colors.white, size: 20),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
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
      ),
    );
  }

  Widget _buildAddTaskSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: _addNewTask,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: DfBRadius.defaultRadius,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      DefaultColors.serotonin.withValues(alpha: 0.2),
                      DefaultColors.serotoninNeon.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: DefaultColors.serotoninNeon,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Thêm nhiệm vụ',
                style: TextPresets.title.copyWith(
                  color: Colors.black.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMicroTasksSection() {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is TasksLoaded && state.microTasks.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.w,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            bottomLeft: Radius.circular(20.r)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            DefaultColors.serotonin,
                            DefaultColors.serotonin.withValues(alpha: 0.5),
                            DefaultColors.white,
                          ],
                          stops: const [0.0, 0.8, 1.0],
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: DefaultColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text('Các Tasks Hôm Nay',
                              style: TextPresets.title
                                  .copyWith(color: DefaultColors.white)),
                          SizedBox(width: 40.w),
                        ],
                      ),
                    ),
                  ],
                ),
                ...state.microTasks.map((task) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _buildMicroTaskCard(task),
                    )),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
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

  Widget _buildMicroTaskCard(Task task) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: DfBRadius.defaultRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DefaultColors.dopamine.withValues(alpha: 0.1),
            DefaultColors.dopamineNeon.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: DefaultColors.dopamine.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: DefaultColors.dopamine.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
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
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: task.isCompleted
                    ? LinearGradient(
                        colors: const [
                          DefaultColors.dopamine,
                          DefaultColors.dopamineNeon,
                        ],
                      )
                    : null,
                border: Border.all(
                  color: task.isCompleted
                      ? DefaultColors.dopamineNeon
                      : DefaultColors.dopamine.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          // Task Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextPresets.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.8),
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextPresets.bodySmall.copyWith(
                      color: task.isCompleted
                          ? Colors.black.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.6),
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: DefaultColors.dopamine.withValues(alpha: 0.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: DefaultColors.dopamine,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Micro Task',
                            style: TextPresets.labelSmall.copyWith(
                              color: DefaultColors.dopamine,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: DefaultColors.endorphin.withValues(alpha: 0.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 12,
                            color: DefaultColors.endorphin,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '5 phút',
                            style: TextPresets.labelSmall.copyWith(
                              color: DefaultColors.endorphin,
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
