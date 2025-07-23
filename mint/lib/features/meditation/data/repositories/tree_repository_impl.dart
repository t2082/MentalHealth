import '../../domain/entities/tree.dart';
import '../../domain/repositories/tree_repository.dart';
import '../datasources/tree_local_datasource.dart';
import '../models/tree_model.dart';

/// Implementation của TreeRepository
class TreeRepositoryImpl implements TreeRepository {
  final TreeLocalDataSource _localDataSource;

  TreeRepositoryImpl(this._localDataSource);

  @override
  Future<List<Tree>> getAllTrees() async {
    try {
      final treeModels = await _localDataSource.getAllTrees();
      return treeModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get all trees: $e');
    }
  }

  @override
  Future<Tree?> getTreeById(String id) async {
    try {
      final treeModel = await _localDataSource.getTreeById(id);
      return treeModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get tree by id: $e');
    }
  }

  @override
  Future<Tree> saveTree(Tree tree) async {
    try {
      final treeModel = TreeModel.fromEntity(tree);
      final savedModel = await _localDataSource.saveTree(treeModel);
      return savedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to save tree: $e');
    }
  }

  @override
  Future<Tree> updateTree(Tree tree) async {
    try {
      final treeModel = TreeModel.fromEntity(tree);
      final updatedModel = await _localDataSource.updateTree(treeModel);
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update tree: $e');
    }
  }

  @override
  Future<void> deleteTree(String id) async {
    try {
      await _localDataSource.deleteTree(id);
    } catch (e) {
      throw Exception('Failed to delete tree: $e');
    }
  }

  @override
  Future<Tree?> getDefaultTree() async {
    try {
      final treeModel = await _localDataSource.getDefaultTree();
      return treeModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get default tree: $e');
    }
  }

  @override
  Future<Tree> createDefaultTree() async {
    try {
      final treeModel = await _localDataSource.createDefaultTree();
      return treeModel.toEntity();
    } catch (e) {
      throw Exception('Failed to create default tree: $e');
    }
  }

  @override
  Future<Tree> updateTreeGrowth(String id, double newGrowth) async {
    try {
      final existingTree = await getTreeById(id);
      if (existingTree == null) {
        throw Exception('Tree with id $id not found');
      }

      final updatedTree = existingTree.updateGrowth(newGrowth);
      return await updateTree(updatedTree);
    } catch (e) {
      throw Exception('Failed to update tree growth: $e');
    }
  }
}
