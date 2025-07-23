import '../entities/tree.dart';

/// Repository interface cho Tree
abstract class TreeRepository {
  /// Lấy tất cả cây
  Future<List<Tree>> getAllTrees();
  
  /// Lấy cây theo ID
  Future<Tree?> getTreeById(String id);
  
  /// Lưu cây mới
  Future<Tree> saveTree(Tree tree);
  
  /// Cập nhật cây
  Future<Tree> updateTree(Tree tree);
  
  /// Xóa cây
  Future<void> deleteTree(String id);
  
  /// Lấy cây mặc định (cây chính của người dùng)
  Future<Tree?> getDefaultTree();
  
  /// Tạo cây mặc định mới
  Future<Tree> createDefaultTree();
  
  /// Cập nhật growth của cây
  Future<Tree> updateTreeGrowth(String id, double newGrowth);
}
