import 'package:expense_bud/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../core/domain/entities/expense.dart';
import '../../../core/util/category_items.dart';
import '../../../core/util/date_formatter.dart';
import '../../../core/widgets/expense_avatar.dart';
import '../../../core/widgets/gap.dart';
import '../../settings/presentation/providers/settings_provider.dart';

class ExpenseListItem extends StatelessWidget {
  ExpenseListItem(this._expense, {Key? key}) : super(key: key);
  final ExpenseEntity _expense;
  final DateFormatter _dateFormatter = DateFormatter.instance;

  @override
  Widget build(BuildContext context) {
    final _categoryItem =
        categoryItems().singleWhere((e) => e.category == _expense.category);
    final money = context.watch<SettingsProvider>().money;
    final showEntryDate =
        context.watch<SettingsProvider>().preference.showEntryDate;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Row(
            children: [
              ExpenseAvatar(_categoryItem.category),
              Gap.md,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _categoryItem.title,
                    style: context.textTheme.bodyText1!
                        .copyWith(fontSize: FontSizes.s16),
                  ),
                  if (showEntryDate)
                    Text(
                      "Added ${_dateFormatter.relativeToNow(_expense.createdAt)}",
                      style: context.textTheme.caption,
                    ),
                ],
              )
            ],
          ),
          const Spacer(),
          Text(
            money.formatValue(_expense.amount),
            style: context.textTheme.bodyText2!.copyWith(
              color: const Color(0xFFE58D67),
            ),
          )
        ],
      ),
    );
  }
}
