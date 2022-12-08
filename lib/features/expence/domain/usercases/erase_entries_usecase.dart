import 'package:dartz/dartz.dart';

import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/expense_repository.dart';

class EraseEntriesUsecase implements NoArgsUsecaseOfFuture<Unit> {
  final IExpenseRepository _expenseRepository;
  EraseEntriesUsecase(this._expenseRepository);

  @override
  Future<Either<Failure, Unit>> call() {
    return _expenseRepository.eraseEntries();
  }
}
