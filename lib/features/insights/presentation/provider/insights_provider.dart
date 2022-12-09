import 'package:flutter/foundation.dart';

import '../../../../core/util/async_value.dart';
import '../../domain/entities/insight.dart';
import '../../domain/entities/insight_period.dart';
import '../../domain/usercases/get_insights_usecase.dart';

class InsightsProvider with ChangeNotifier {
  final GetInsightsUsecase _getInsightsUsecase;
  InsightsProvider({required GetInsightsUsecase getInsightsUsecase})
      : _getInsightsUsecase = getInsightsUsecase;

  InsightPeriod _insightPeriod = InsightPeriod.thisMonth;
  InsightPeriod get insightPeriod => _insightPeriod;
  set insightPeriod(InsightPeriod value) {
    _insightPeriod = value;
    notifyListeners();
  }

  AsyncValue<InsightEntity> _asyncValueOfInsight = AsyncValue.loading();

  AsyncValue<InsightEntity> get asyncValueOfInsight => _asyncValueOfInsight;
  set asyncValueOfInsight(AsyncValue<InsightEntity> value) {
    _asyncValueOfInsight = value;
    notifyListeners();
  }

  void getInsights() async {
    final failureOrInsight = await _getInsightsUsecase(insightPeriod);
    failureOrInsight.fold((failure) => null, (data) {
      asyncValueOfInsight = AsyncValue.done(data);
    });
  }
}
