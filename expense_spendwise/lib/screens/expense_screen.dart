import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';

class ExpenseScreen extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onAddExpense;
  final Function(Expense) onDeleteExpense;

  const ExpenseScreen({
    super.key,
    required this.expenses,
    required this.onAddExpense,
    required this.onDeleteExpense,
  });

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _titleController =
  TextEditingController();

  final TextEditingController _amountController =
  TextEditingController();

  ExpenseCategory _selectedCategory = ExpenseCategory.other;

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitExpense() {
    final enteredTitle = _titleController.text.trim();

    final enteredAmount =
    double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0) {
      return;
    }

    final expense = Expense(
      title: enteredTitle,
      amount: enteredAmount,
      category: _selectedCategory,
      date: _selectedDate,
    );

    widget.onAddExpense(expense);

    _titleController.clear();
    _amountController.clear();

    setState(() {
      _selectedCategory = ExpenseCategory.other;
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpendWise'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Expense title',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<ExpenseCategory>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items:
                  ExpenseCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (category) {
                    if (category == null) {
                      return;
                    }

                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: _selectDate,
                      child: const Text('Select Date'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submitExpense,
                    child: const Text('Add Expense'),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: widget.expenses.isEmpty
                ? const Center(
              child: Text('No expenses yet'),
            )
                : ListView.builder(
              itemCount: widget.expenses.length,
              itemBuilder: (context, index) {
                final expense =
                widget.expenses[index];

                return Dismissible(
                  key: ValueKey(expense),
                  direction:
                  DismissDirection.endToStart,
                  onDismissed: (direction) {
                    widget.onDeleteExpense(expense);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding:
                    const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ExpenseCard(
                    expense: expense,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
