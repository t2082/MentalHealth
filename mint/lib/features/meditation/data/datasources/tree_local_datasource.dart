import 'package:mental_health/core/services/sqlite_helper.dart';
import 'package:mental_health/core/services/database_constants.dart';
import '../models/tree_model.dart';
import '../../domain/entities/tree.dart';

/// Local data source cho Tree sử dụng SQLite
abstract class TreeLocalDataSource {
  Future<List<TreeModel>> getAllTrees();
  Future<TreeModel?> getTreeById(String id);
  Future<TreeModel> saveTree(TreeModel tree);
  Future<TreeModel> updateTree(TreeModel tree);
  Future<void> deleteTree(String id);
  Future<TreeModel?> getDefaultTree();
  Future<TreeModel> createDefaultTree();
}

class TreeLocalDataSourceImpl implements TreeLocalDataSource {
  final SqliteHelper _sqliteHelper;

  TreeLocalDataSourceImpl(this._sqliteHelper);

  @override
  Future<List<TreeModel>> getAllTrees() async {
    try {
      final db = await _sqliteHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.treesTable,
        orderBy: '${DatabaseConstants.treesCreatedAt} DESC',
      );

      return maps.map((map) => TreeModel.fromJson(map)).toList();
    } catch (e) {
      throw Exception('Failed to get all trees: $e');
    }
  }

  @override
  Future<TreeModel?> getTreeById(String id) async {
    try {
      final db = await _sqliteHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.treesTable,
        where: '${DatabaseConstants.treesId} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return TreeModel.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get tree by id: $e');
    }
  }

  @override
  Future<TreeModel> saveTree(TreeModel tree) async {
    try {
      final db = await _sqliteHelper.database;

      // Kiểm tra xem tree đã tồn tại chưa
      final existing = await getTreeById(tree.id);
      if (existing != null) {
        throw Exception('Tree with id ${tree.id} already exists');
      }

      await db.insert(
        DatabaseConstants.treesTable,
        _treeToMap(tree),
      );

      return tree;
    } catch (e) {
      throw Exception('Failed to save tree: $e');
    }
  }

  @override
  Future<TreeModel> updateTree(TreeModel tree) async {
    try {
      final db = await _sqliteHelper.database;

      final updatedCount = await db.update(
        DatabaseConstants.treesTable,
        _treeToMap(tree),
        where: '${DatabaseConstants.treesId} = ?',
        whereArgs: [tree.id],
      );

      if (updatedCount == 0) {
        throw Exception('Tree with id ${tree.id} not found');
      }

      return tree;
    } catch (e) {
      throw Exception('Failed to update tree: $e');
    }
  }

  @override
  Future<void> deleteTree(String id) async {
    try {
      final db = await _sqliteHelper.database;

      final deletedCount = await db.delete(
        DatabaseConstants.treesTable,
        where: '${DatabaseConstants.treesId} = ?',
        whereArgs: [id],
      );

      if (deletedCount == 0) {
        throw Exception('Tree with id $id not found');
      }
    } catch (e) {
      throw Exception('Failed to delete tree: $e');
    }
  }

  @override
  Future<TreeModel?> getDefaultTree() async {
    try {
      final trees = await getAllTrees();
      if (trees.isNotEmpty) {
        // Trả về cây đầu tiên (mới nhất)
        return trees.first;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get default tree: $e');
    }
  }

  @override
  Future<TreeModel> createDefaultTree() async {
    try {
      final defaultTree = TreeModel.fromEntity(
        Tree.create(
          id: 'default_tree_${DateTime.now().millisecondsSinceEpoch}',
          growth: 0.0,
          name: 'Cây Tâm Hồn',
        ),
      );

      return await saveTree(defaultTree);
    } catch (e) {
      throw Exception('Failed to create default tree: $e');
    }
  }

  /// Chuyển TreeModel thành Map để lưu vào database
  Map<String, dynamic> _treeToMap(TreeModel tree) {
    return {
      DatabaseConstants.treesId: tree.id,
      DatabaseConstants.treesGrowth: tree.growth,
      DatabaseConstants.treesSeed: tree.seed,
      DatabaseConstants.treesName: tree.name,
      DatabaseConstants.treesCreatedAt: tree.createdAt.toIso8601String(),
      DatabaseConstants.treesLastUpdated: tree.lastUpdated.toIso8601String(),
    };
  }
}
