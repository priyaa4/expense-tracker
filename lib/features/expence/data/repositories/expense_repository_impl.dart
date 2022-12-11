import 'package:dartz/dartz.dart';
import 'package:expense_bud/core/data/mappers/expense.dart';

import '../../../../core/domain/entities/expense.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasource/local_datasource.dart';

class ExpenseRepository implements IExpenseRepository {
  final IExpenseLocalDataSource _localDataSource;
  ExpenseRepository(this._localDataSource);

  @override
  Future<Either<Failure, Unit>> createExpenseEntry(
      ExpenseEntity expense) async {
    try {
      await _localDataSource.createExpenseEntry(expense.toModel());
      return const Right(unit);
    } catch (e) {
      return Left(CachePutFailure());
    }
  }

  @override
  Stream<Either<Failure, Map<String, List<ExpenseEntity>>>>
      watchMonthlyEntries() async* {
    try {
      yield* _localDataSource.watchMonthlyEntries().map(
            (event) => Right(
              event.map(
                (key, value) => MapEntry(
                  key,
                  value.map((e) => e.toEntity()).toList(),
                ),
              ),
            ),
          );
    } catch (e) {
      yield Left(CacheGetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> eraseEntries() async {
    try {
      await _localDataSource.eraseEntries();
      return const Right(unit);
    } catch (e) {
      return Left(CacheGetFailure());
    }
  }
}
