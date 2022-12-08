import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/expense.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/expense_repository.dart';

class CreateExpenseEntryUsecase
    implements UsecaseOfFuture<Unit, ExpenseEntity> {
  final IExpenseRepository _expenseRepository;
  CreateExpenseEntryUsecase(this._expenseRepository);

  @override
  Future<Either<Failure, Unit>> call(ExpenseEntity param) {
    return _expenseRepository.createExpenseEntry(param);
  }
}
