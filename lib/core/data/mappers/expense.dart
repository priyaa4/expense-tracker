import 'package:expense_bud/core/domain/entities/expense.dart';

import '../../util/category_items.dart';
import '../models/expense.dart';

extension ExpenseModelExtension on ExpenseModel {
  ExpenseEntity toEntity() => ExpenseEntity(
        createdAt: createdAt,
        updatedAt: updatedAt,
        amount: amount,
        category: ExpenseCategory.values.singleWhere((e) => e.name == category),
      );
}

extension ExpenseEntityExtension on ExpenseEntity {
  ExpenseModel toModel() => ExpenseModel(
        createdAt: createdAt,
        updatedAt: updatedAt,
        amount: amount,
        category: category.name,
      );
}
