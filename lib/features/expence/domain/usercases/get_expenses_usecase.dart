import 'package:dartz/dartz.dart';

import 'package:expense_bud/core/failure/failure.dart';
import 'package:expense_bud/core/domain/usecases/usecase.dart';
import 'package:expense_bud/core/domain/entities/expense.dart';

import '../repositories/expense_repository.dart';

class GetExpensesUsecase
    implements NoArgsUsecaseOfStream<Map<String, List<ExpenseEntity>>> {
  final IExpenseRepository _expenseRepository;
  GetExpensesUsecase(this._expenseRepository);

  @override
  Stream<Either<Failure, Map<String, List<ExpenseEntity>>>> call() {
    return _expenseRepository.watchMonthlyEntries();
  }
}
