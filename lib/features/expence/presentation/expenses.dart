import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_bud/core/util/extensions.dart';
import 'package:expense_bud/features/expence/presentation/provider/expense_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../config/constant.dart';
import '../../../config/theme.dart';
import '../../../core/widgets/gap.dart';
import '../../settings/domain/entities/user_preference.dart';
import '../../settings/presentation/providers/settings_provider.dart';
import 'add_entry.dart';
import 'expense_tab.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ExpenseProvider>().getEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            expandedHeight: 220,
            backgroundColor: AppColors.kPrimary,
            actions: [
              IconButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => const AddEntryPage(),
                  );
                },
                icon: const Icon(
                  PhosphorIcons.plusFill,
                  color: Colors.white,
                ),
              )
            ],
            flexibleSpace: const _FlexibleSpaceBar(),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              const ExpenseTab(),
            ],
          )),
        ],
      ),
    );
  }
}

class _FlexibleSpaceBar extends StatelessWidget {
  const _FlexibleSpaceBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final prefs = settingsProvider.preference;
    final money = settingsProvider.money;
    int inboxAmount = 0;
    switch (prefs.inboxAmount) {
      case InboxAmount.today:
        inboxAmount = expenseProvider.getDailyTotal();
        break;
      case InboxAmount.month:
        inboxAmount = expenseProvider.getMonthlyTotal();
        break;
      default:
        inboxAmount = expenseProvider.getWeeklyTotal();
    }

    return FlexibleSpaceBar(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: Platform.isIOS
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            prefs.inboxAmount.title,
            style: context.textTheme.overline!.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: FontSizes.s8,
            ),
          ),
          const Gap(2),
          AutoSizeText(
            money.formatValue(inboxAmount),
            style: context.textTheme.headline4!
                .copyWith(color: Colors.white, fontSize: FontSizes.s28),
            maxLines: 1,
          ),
        ],
      ),
      titlePadding: const EdgeInsets.only(
        left: Insets.lg,
        right: Insets.lg,
        bottom: Insets.lg,
      ),
    );
  }
}
