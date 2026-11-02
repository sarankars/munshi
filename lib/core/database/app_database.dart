import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:munshi/core/database/converters/transaction_type_converter.dart';
import 'package:munshi/core/database/tables/transaction_categories.dart';
import 'package:munshi/core/database/tables/transactions.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/features/transactions/data/datasources/category_local_datasource.dart';
import 'package:munshi/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:munshi/features/transactions/domain/value_objects/category_icon_spec.dart';
import 'package:munshi/features/transactions/domain/value_objects/transaction_category_input.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Transactions, TransactionCategories],
  daos: [TransactionLocalDataSource, CategoryLocalDataSource],
)
/// The main Drift database for the Munshi app.
///
/// Manages [Transactions] and [TransactionCategories] tables and exposes
/// [TransactionLocalDataSource] and [CategoryLocalDataSource] DAOs.
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] backed by a persistent on-device SQLite file.
  AppDatabase() : super(_openConnection());

  /// Creates an [AppDatabase] using the provided query executor, intended for
  /// testing with an in-memory database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedDefaultCategories();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add categories table
          await m.createTable(transactionCategories);
          await _seedDefaultCategories();
        }
        if (from < 3) {
          // Migrate from storing category object to categoryId foreign key
          await _migrateToCategoryId(m);
        }
        if (from < 4) {
          // Update default colors for Healthcare and Utilities categories
          await _updateCategoryColors();
        }
      },
    );
  }

  Future<void> _seedDefaultCategories() async {
    final categoriesDao = CategoryLocalDataSource(this);

    // Seed expense categories
    const expenseCategoriesToSeed = [
      TransactionCategoryInput(
        name: 'Food & Dining',
        icon: CategoryIconSpec(
          codePoint: 0xee52,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFFFF5252,
        type: TransactionType.expense,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Transportation',
        icon: CategoryIconSpec(
          codePoint: 0xec48,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFF448AFF,
        type: TransactionType.expense,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Shopping',
        icon: CategoryIconSpec(
          codePoint: 0xee91,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFFE040FB,
        type: TransactionType.expense,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Entertainment',
        icon: CategoryIconSpec(
          codePoint: 0xede2,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFFFFAB40,
        type: TransactionType.expense,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Healthcare',
        icon: CategoryIconSpec(
          codePoint: 0xed44,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFF4CAF50,
        type: TransactionType.expense,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Utilities',
        icon: CategoryIconSpec(
          codePoint: 0xecd4,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFF009688,
        type: TransactionType.expense,
        isDefault: true,
      ),
    ];

    // Seed income categories
    const incomeCategoriesToSeed = [
      TransactionCategoryInput(
        name: 'Salary',
        icon: CategoryIconSpec(
          codePoint: 0xec1a,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFF2196F3,
        type: TransactionType.income,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Freelance',
        icon: CategoryIconSpec(
          codePoint: 0xec7b,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFF4CAF50,
        type: TransactionType.income,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Business',
        icon: CategoryIconSpec(
          codePoint: 0xee8f,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFFFF9800,
        type: TransactionType.income,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Investment',
        icon: CategoryIconSpec(
          codePoint: 0xec59,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFF9C27B0,
        type: TransactionType.income,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Rental',
        icon: CategoryIconSpec(
          codePoint: 0xed53,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFFF44336,
        type: TransactionType.income,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Bonus',
        icon: CategoryIconSpec(
          codePoint: 0xed26,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFFFFC107,
        type: TransactionType.income,
        isDefault: true,
      ),
      TransactionCategoryInput(
        name: 'Other',
        icon: CategoryIconSpec(
          codePoint: 0xedda,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
        colorArgb: 0xFF9E9E9E,
        type: TransactionType.income,
        isDefault: true,
      ),
    ];

    for (final category in expenseCategoriesToSeed) {
      await categoriesDao.insertCategory(category);
    }

    for (final category in incomeCategoriesToSeed) {
      await categoriesDao.insertCategory(category);
    }
  }

  Future<void> _migrateToCategoryId(Migrator m) async {
    // Step 1: Create new transactions table with categoryId
    await m.createTable(transactions);

    // Note: Since we're changing from storing category objects to categoryId,
    // existing transaction data would need manual migration if there was any.
    // For a clean migration, we'll start fresh with the new schema.
    // If you need to preserve existing data, you would need to:
    // 1. Read existing transactions
    // 2. Map category objects to category IDs
    // 3. Insert transactions with new schema
  }

  Future<void> _updateCategoryColors() async {
    // Update Healthcare category color from greenAccent (0xFF69F0AE) to
    // green (0xFF4CAF50)
    await customStatement(
      '''
      UPDATE transaction_categories 
      SET color = ? 
      WHERE name = 'Healthcare' AND is_default = 1 AND color = ?
    ''',
      [0xFF4CAF50, 0xFF69F0AE],
    );

    // Update Utilities category color from tealAccent (0xFF64FFDA) to
    // teal (0xFF009688)
    await customStatement(
      '''
      UPDATE transaction_categories 
      SET color = ? 
      WHERE name = 'Utilities' AND is_default = 1 AND color = ?
    ''',
      [0xFF009688, 0xFF64FFDA],
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'munshi_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
