import '../../../../core/data/models/expence.dart';
import '../../domain/entities/insight.dart';

class InsightModel extends InsightEntity {
  InsightModel(
    List<ExpenseModel> cur,
    List<ExpenseModel> prev,
  ) : super(
          cur.map((e) => e.toEntity()).toList(),
          prev.map((e) => e.toEntity()).toList(),
        );
}
