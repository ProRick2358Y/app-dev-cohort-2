import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/expense.dart';
import 'models/todo.dart';

import 'screens/dashboard_screen.dart';
import 'screens/expense_screen.dart';
import 'screens/todo_screen.dart';

void main() {
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor:
          const Color(0xFFD95C8A),
        ),
      ),

      home: const SpendWiseHome(),
    );
  }
}

class SpendWiseHome extends StatefulWidget {
  const SpendWiseHome({super.key});

  @override
  State<SpendWiseHome> createState() {
    return _SpendWiseHomeState();
  }
}

class _SpendWiseHomeState
    extends State<SpendWiseHome> {
  static const String _expensesKey =
      'spendwise_expenses';

  static const String _todosKey =
      'spendwise_todos';

  int _selectedTab = 0;

  final List<Expense> _expenses =
  <Expense>[];

  final List<Todo> _todos =
  <Todo>[];

  @override
  void initState() {
    super.initState();

    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final SharedPreferences prefs =
    await SharedPreferences
        .getInstance();

    final List<String> savedExpenses =
        prefs.getStringList(
          _expensesKey,
        ) ??
            <String>[];

    final List<String> savedTodos =
        prefs.getStringList(
          _todosKey,
        ) ??
            <String>[];

    final List<Expense>
    loadedExpenses =
    savedExpenses.map(
          (String expenseString) {
        final Map<String, dynamic>
        expenseMap =
        jsonDecode(
          expenseString,
        );

        return Expense.fromJson(
          expenseMap,
        );
      },
    ).toList();

    final List<Todo> loadedTodos =
    savedTodos.map(
          (String todoString) {
        final Map<String, dynamic>
        todoMap =
        jsonDecode(
          todoString,
        );

        return Todo.fromJson(
          todoMap,
        );
      },
    ).toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _expenses.clear();
      _expenses.addAll(
        loadedExpenses,
      );

      _todos.clear();
      _todos.addAll(
        loadedTodos,
      );
    });
  }

  Future<void> _saveData() async {
    final SharedPreferences prefs =
    await SharedPreferences
        .getInstance();

    final List<String> expenseStrings =
    _expenses.map(
          (Expense expense) {
        final Map<String, dynamic>
        expenseMap =
        expense.toJson();

        return jsonEncode(
          expenseMap,
        );
      },
    ).toList();

    final List<String> todoStrings =
    _todos.map(
          (Todo todo) {
        final Map<String, dynamic>
        todoMap =
        todo.toJson();

        return jsonEncode(
          todoMap,
        );
      },
    ).toList();

    await prefs.setStringList(
      _expensesKey,
      expenseStrings,
    );

    await prefs.setStringList(
      _todosKey,
      todoStrings,
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });

    _saveData();
  }

  void _deleteExpense(Expense expense) {
    setState(() {
      _expenses.remove(expense);
    });

    _saveData();
  }

  void _addTodo(String title) {
    setState(() {
      _todos.add(
        Todo(
          title: title,
          createdAt: DateTime.now(),
        ),
      );
    });

    _saveData();
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone =
      !_todos[index].isDone;
    });

    _saveData();
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });

    _saveData();
  }

  void _openDashboard() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (BuildContext context) {
          return DashboardScreen(
            expenses: _expenses,
            todos: _todos,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedTab == 0
              ? 'Expenses'
              : 'Todo List',
        ),

        actions: [
          IconButton(
            onPressed: _openDashboard,

            icon: const Icon(
              Icons.dashboard_outlined,
            ),

            tooltip: 'Dashboard',
          ),
        ],
      ),

      body: _selectedTab == 0
          ? ExpenseScreen(
        expenses: _expenses,
        onAddExpense: _addExpense,
        onDeleteExpense:
        _deleteExpense,
      )
          : TodoScreen(
        todos: _todos,
        onAddTodo: _addTodo,
        onToggleTodo: _toggleTodo,
        onDeleteTodo: _deleteTodo,
      ),

      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: _selectedTab,

        onTap: (int index) {
          setState(() {
            _selectedTab = index;
          });
        },

        items:
        const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons
                  .account_balance_wallet_outlined,
            ),
            label: 'Expenses',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.checklist_outlined,
            ),
            label: 'Todo',
          ),
        ],
      ),
    );
  }
}