import 'package:hive/hive.dart';

import '../../../../core/data/datasource/local_datasource.dart';
import '../../../../core/data/models/expence.dart';
import '../../../../core/failure/exceptions.dart';

abstract class IExpenseLocalDataSource {
  Stream<Map<String, List<ExpenseModel>>> watchMonthlyEntries();
  Future<ExpenseModel> createExpenseEntry(ExpenseModel expense);
  Future<void> eraseEntries();
}

class ExpenseLocalDataSource extends LocalDataSource
    implements IExpenseLocalDataSource {
  final Box _box;
  ExpenseLocalDataSource(this._box) : super(_box);

  @override
  Future<ExpenseModel> createExpenseEntry(ExpenseModel expense) async {
    try {
      final monthKey = getMonthKey(expense.createdAt);
      final dayKey = getDayKey(expense.createdAt);
      if (has(monthKey)) {
        final month = _box.get(monthKey)! as Map;
        if (month.containsKey(dayKey)) {
          final items = month[dayKey];
          final updatedItems = [expense, ...items];
          await _box.put(monthKey, {...month, dayKey: updatedItems});
        } else {
          await _box.put(monthKey, {
            ...month,
            dayKey: [expense]
          });
        }
      } else {
        await _box.put(monthKey, {
          dayKey: [expense]
        });
      }
      return expense;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Stream<Map<String, List<ExpenseModel>>> watchMonthlyEntries() async* {
    yield _getMonthlyEntries();
    yield* _box
        .watch()
        .map((_) => _getMonthlyEntries())
        .handleError((e, s) => throw CacheException());
  }

  @override
  Future<void> eraseEntries() async {
    try {
      await _box.clear();
    } catch (e) {
      throw CacheException();
    }
  }

  Map<String, List<ExpenseModel>> _getMonthlyEntries() {
    final today = DateTime.now().toIso8601String();
    final key = getMonthKey(today);
    final currentMonth = _box.get(key, defaultValue: {}) as Map;
    Map<String, List<ExpenseModel>> mapEntry = {};
    currentMonth.keys.toList().cast<String>()
      ..sort((a, b) => b.compareTo(a))
      ..forEach((k) {
        mapEntry[k] = (currentMonth[k] as List).cast<ExpenseModel>();
      });
    return mapEntry;
  }
}
