import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_category.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../widgets/task_category_chip.dart';

/// Màn hình thêm/sửa nhiệm vụ
class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  final bool isEditing;

  const AddEditTaskScreen({
    super.key,
    this.task,
  }) : isEditing = task != null;

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  
  TaskCategory? _selectedCategory;
  int _priority = 2;
  int _estimatedMinutes = 30;
  DateTime? _dueDate;
  List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.task != null) {
      _initializeWithTask(widget.task!);
    }
  }

  void _initializeWithTask(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _notesController.text = task.notes ?? '';
    _selectedCategory = task.category;
    _priority = task.priority;
    _estimatedMinutes = task.estimatedMinutes;
    _dueDate = task.dueDate;
    _tags = List.from(task.tags);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Sửa nhiệm vụ' : 'Thêm nhiệm vụ mới',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              widget.isEditing ? 'Cập nhật' : 'Lưu',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildCategorySelection(),
              const SizedBox(height: 16),
              _buildPrioritySelection(),
              const SizedBox(height: 16),
              _buildTimeEstimation(),
              const SizedBox(height: 16),
              _buildDueDateSelection(),
              const SizedBox(height: 16),
              _buildTagsSection(),
              const SizedBox(height: 16),
              _buildNotesField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Tên nhiệm vụ *',
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập tên nhiệm vụ';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      style: const TextStyle(color: Colors.white),
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Mô tả *',
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập mô tả nhiệm vụ';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danh mục *',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TaskCategoryChipGrid(
          categories: TaskCategory.defaultCategories,
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
          crossAxisCount: 2,
          childAspectRatio: 4.0,
        ),
        if (_selectedCategory == null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Vui lòng chọn danh mục',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildPrioritySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Độ ưu tiên',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [1, 2, 3].map((priority) {
            final isSelected = _priority == priority;
            final colors = [Colors.green, Colors.orange, Colors.red];
            final labels = ['Thấp', 'Trung bình', 'Cao'];
            
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _priority = priority),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? colors[priority - 1].withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                            ? colors[priority - 1]
                            : Colors.white30,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      labels[priority - 1],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected 
                            ? colors[priority - 1]
                            : Colors.white70,
                        fontWeight: isSelected 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeEstimation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thời gian ước tính (phút)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _estimatedMinutes.toDouble(),
          min: 5,
          max: 240,
          divisions: 47,
          activeColor: Colors.blue,
          inactiveColor: Colors.white30,
          label: '$_estimatedMinutes phút',
          onChanged: (value) {
            setState(() {
              _estimatedMinutes = value.round();
            });
          },
        ),
        Text(
          '$_estimatedMinutes phút',
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildDueDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày hết hạn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDueDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white70),
                const SizedBox(width: 12),
                Text(
                  _dueDate != null
                      ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                      : 'Chọn ngày hết hạn',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                if (_dueDate != null)
                  GestureDetector(
                    onTap: () => setState(() => _dueDate = null),
                    child: const Icon(Icons.clear, color: Colors.white70),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Nhập tag và nhấn Enter',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onSubmitted: _addTag,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _addTag(_tagController.text),
              icon: const Icon(Icons.add, color: Colors.blue),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _tags.map((tag) {
              return Chip(
                label: Text('#$tag'),
                backgroundColor: Colors.blue.withOpacity(0.2),
                labelStyle: const TextStyle(color: Colors.blue),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeTag(tag),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      style: const TextStyle(color: Colors.white),
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Ghi chú',
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn danh mục')),
        );
      }
      return;
    }

    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      completedAt: widget.task?.completedAt,
      priority: _priority,
      dueDate: _dueDate,
      tags: _tags,
      estimatedMinutes: _estimatedMinutes,
      notes: _notesController.text.trim().isEmpty 
          ? null 
          : _notesController.text.trim(),
    );

    if (widget.isEditing) {
      context.read<TasksBloc>().add(UpdateTask(task));
    } else {
      context.read<TasksBloc>().add(AddTask(task));
    }

    Navigator.of(context).pop();
  }
}
