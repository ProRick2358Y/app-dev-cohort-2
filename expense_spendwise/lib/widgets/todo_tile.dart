import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onChanged,
  });

  final Todo todo;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: todo.isDone,
      onChanged: onChanged,

      activeColor: const Color(0xFFD95C8A),

      title: Text(
        todo.title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF5A3A4A),

          decoration: todo.isDone
              ? TextDecoration.lineThrough
              : null,
        ),
      ),

      subtitle: Text(
        'Added on ${DateFormat.yMMMd().format(todo.createdAt)}',
      ),
    );
  }
}
