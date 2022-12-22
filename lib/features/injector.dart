import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../core/data/models/expense.dart';
import '../core/util/device.dart';
import 'expence/data/datasource/local_datasource.dart';
import 'expence/data/repositories/expense_repository_impl.dart';
import 'expence/domain/repositories/expense_repository.dart';
import 'expence/domain/usercases/create_entry_usecase.dart';
import 'expence/domain/usercases/erase_entries_usecase.dart';
import 'expence/domain/usercases/get_expenses_usecase.dart';
import 'expence/presentation/provider/expense_provider.dart';
import 'insights/data/datasource/local_datasource.dart';
import 'insights/data/repositories/insight_repository_impl.dart';
import 'insights/domain/repositories/insight_repository.dart';
import 'insights/domain/usercases/get_insights_usecase.dart';
import 'insights/presentation/provider/insights_provider.dart';
import 'settings/data/datasources/user_preference_local_datasource.dart';
import 'settings/data/models/currency.dart';
import 'settings/data/models/user_preference.dart';
import 'settings/data/user_preference_repository_impl.dart';
import 'settings/domain/repositories/user_preference_repository.dart';
import 'settings/domain/usercases/get_user_preference_usecase.dart';
import 'settings/domain/usercases/update_user_preference_usecase.dart';
import 'settings/presentation/providers/settings_provider.dart';

final getIt = GetIt.I;

Future<void> initApp() async {
  final storage = await getStorageDirectory();
  Hive.init(storage);
  Hive.registerAdapter<ExpenseModel>(ExpenseModelAdapter());
  Hive.registerAdapter<UserPreferenceModel>(UserPreferenceModelAdapter());
  Hive.registerAdapter<CurrencyModel>(CurrencyModelAdapter());

  final _expenseDb = await Hive.openBox("expenses.db");
  final _preferenceDb = await Hive.openBox("preferences.db");

  /// datasources
  getIt.registerSingleton<IExpenseLocalDataSource>(
      ExpenseLocalDataSource(_expenseDb));
  getIt.registerSingleton<IInsightLocalDataSource>(
      InsightLocalDataSource(_expenseDb));
  getIt.registerSingleton<IUserPreferenceLocalDataSource>(
      UserPreferenceLocalDataSource(_preferenceDb));

  /// repositories
  getIt.registerSingleton<IExpenseRepository>(ExpenseRepository(getIt()));
  getIt.registerSingleton<IInsightRepository>(InsightRepository(getIt()));
  getIt.registerSingleton<IUserPreferenceRepository>(
      UserPreferenceRepository(getIt()));

  /// usecases
  getIt.registerSingleton<GetExpensesUsecase>(GetExpensesUsecase(getIt()));
  getIt.registerSingleton<CreateExpenseEntryUsecase>(
      CreateExpenseEntryUsecase(getIt()));
  getIt.registerSingleton<EraseEntriesUsecase>(EraseEntriesUsecase(getIt()));
  getIt.registerSingleton<GetUserPreferenceUsecase>(
      GetUserPreferenceUsecase(getIt()));
  getIt.registerSingleton<UpdateUserPreferenceUsecase>(
      UpdateUserPreferenceUsecase(getIt()));
  getIt.registerSingleton<GetInsightsUsecase>(GetInsightsUsecase(getIt()));

  /// providers
  getIt.registerSingleton<SettingsProvider>(
    SettingsProvider(
      getUserPreferenceUsecase: getIt(),
      updateUserPreferenceUsecase: getIt(),
    )..getUserPref(),
  );

  getIt.registerSingleton<ExpenseProvider>(
    ExpenseProvider(
      getExpensesUsecase: getIt(),
      createExpenseEntryUsecase: getIt(),
      eraseEntriesUsecase: getIt(),
    ),
  );
  getIt.registerSingleton<InsightsProvider>(
    InsightsProvider(
      getInsightsUsecase: getIt(),
    ),
  );
}
