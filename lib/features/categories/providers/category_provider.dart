import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/core/service_locator.dart';
import 'package:munshi/features/transactions/data/datasources/category_local_datasource.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/domain/value_objects/transaction_category_input.dart';

/// Manages the in-memory lists of expense and income categories.
class CategoryProvider extends ChangeNotifier {
  /// Creates a [CategoryProvider] and triggers an initial category load.
  CategoryProvider() {
    unawaited(loadCategories());
  }
  final CategoryLocalDataSource _categoriesDao =
      locator<CategoryLocalDataSource>();

  List<TransactionCategory> _expenseCategories = [];
  List<TransactionCategory> _incomeCategories = [];
  bool _isLoading = false;

  /// All loaded expense categories.
  List<TransactionCategory> get expenseCategories => _expenseCategories;

  /// All loaded income categories.
  List<TransactionCategory> get incomeCategories => _incomeCategories;

  /// Whether categories are currently being loaded from the database.
  bool get isLoading => _isLoading;

  /// Reloads both expense and income categories from the local database.
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenseCategories = await _categoriesDao.getExpenseCategories();
      _incomeCategories = await _categoriesDao.getIncomeCategories();
    } on Object catch (e) {
      debugPrint('Error loading categories: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Inserts a new [category] and refreshes the cached category lists.
  Future<void> addCategory(TransactionCategoryInput category) async {
    await _categoriesDao.insertCategory(category);
    await loadCategories();
  }

  /// Updates an existing [category] and refreshes the cached category lists.
  Future<void> updateCategory(TransactionCategory category) async {
    await _categoriesDao.updateCategory(category);
    await loadCategories();
  }

  /// Deletes the category with [id] and refreshes the cached category lists.
  Future<void> deleteCategory(int id) async {
    await _categoriesDao.deleteCategory(id);
    await loadCategories();
  }

  /// Returns `true` if a category with [name] and [type] already exists.
  Future<bool> categoryNameExists(
    String name,
    TransactionType type, {
    int? excludeId,
  }) async {
    return _categoriesDao.categoryNameExists(
      name,
      type,
      excludeId: excludeId,
    );
  }
}
