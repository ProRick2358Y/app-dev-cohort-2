import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/todo.dart';

import '../widgets/dashboard_metric_card.dart';

class DashboardScreen
    extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.expenses,
    required this.todos,
  });

  final List<Expense> expenses;
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    final double totalSpent =
    expenses.fold<double>(
      0,
          (
          double sum,
          Expense expense,
          ) {
        return sum + expense.amount;
      },
    );

    final double todaySpent =
    expenses
        .where(
          (Expense expense) {
        return expense.date.year ==
            now.year &&
            expense.date.month ==
                now.month &&
            expense.date.day ==
                now.day;
      },
    )
        .fold<double>(
      0,
          (
          double sum,
          Expense expense,
          ) {
        return sum +
            expense.amount;
      },
    );

    final int completedTasks =
        todos
            .where(
              (Todo todo) {
            return todo.isDone;
          },
        )
            .length;

    final int todayTasks =
        todos
            .where(
              (Todo todo) {
            return todo
                .createdAt.year ==
                now.year &&
                todo.createdAt.month ==
                    now.month &&
                todo.createdAt.day ==
                    now.day;
          },
        )
            .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          DashboardMetricCard(
            label: 'Total Spent',

            value:
            '₹${totalSpent.toStringAsFixed(2)}',

            icon: Icons
                .account_balance_wallet_outlined,

            color: Colors.teal,
          ),

          DashboardMetricCard(
            label: "Today's Spending",

            value:
            '₹${todaySpent.toStringAsFixed(2)}',

            icon: Icons.today_outlined,

            color: Colors.blue,
          ),

          DashboardMetricCard(
            label: 'Tasks Completed',

            value:
            '$completedTasks / ${todos.length}',

            icon:
            Icons.check_circle_outline,

            color: Colors.green,
          ),

          DashboardMetricCard(
            label: 'Tasks Added Today',

            value: '$todayTasks',

            icon: Icons
                .playlist_add_check_outlined,

            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
