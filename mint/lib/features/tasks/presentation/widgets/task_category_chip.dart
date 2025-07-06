import 'package:flutter/material.dart';
import '../../domain/entities/task_category.dart';

/// Widget hiển thị chip danh mục nhiệm vụ
class TaskCategoryChip extends StatelessWidget {
  final TaskCategory category;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showIcon;
  final double? fontSize;

  const TaskCategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.showIcon = true,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? category.color.withOpacity(0.3)
              : category.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? category.color
                : category.color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                category.icon,
                size: 14,
                color: category.color,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              category.name,
              style: TextStyle(
                color: category.color,
                fontSize: fontSize ?? 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị danh sách các chip danh mục
class TaskCategoryChipList extends StatelessWidget {
  final List<TaskCategory> categories;
  final TaskCategory? selectedCategory;
  final Function(TaskCategory)? onCategorySelected;
  final bool showAllOption;
  final ScrollPhysics? physics;

  const TaskCategoryChipList({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.showAllOption = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: physics ?? const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (showAllOption)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TaskCategoryChip(
                category: const TaskCategory(
                  id: 'all',
                  name: 'Tất cả',
                  description: 'Tất cả danh mục',
                  iconName: 'apps',
                  colorHex: '#9E9E9E',
                ),
                isSelected: selectedCategory?.id == 'all' || selectedCategory == null,
                onTap: () => onCategorySelected?.call(
                  const TaskCategory(
                    id: 'all',
                    name: 'Tất cả',
                    description: 'Tất cả danh mục',
                    iconName: 'apps',
                    colorHex: '#9E9E9E',
                  ),
                ),
              ),
            ),
          ...categories.map((category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TaskCategoryChip(
                  category: category,
                  isSelected: selectedCategory?.id == category.id,
                  onTap: () => onCategorySelected?.call(category),
                ),
              )),
        ],
      ),
    );
  }
}

/// Widget hiển thị grid các chip danh mục
class TaskCategoryChipGrid extends StatelessWidget {
  final List<TaskCategory> categories;
  final TaskCategory? selectedCategory;
  final Function(TaskCategory)? onCategorySelected;
  final int crossAxisCount;
  final double childAspectRatio;

  const TaskCategoryChipGrid({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.crossAxisCount = 2,
    this.childAspectRatio = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return TaskCategoryChip(
          category: category,
          isSelected: selectedCategory?.id == category.id,
          onTap: () => onCategorySelected?.call(category),
          fontSize: 12,
        );
      },
    );
  }
}
