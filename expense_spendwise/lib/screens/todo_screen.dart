import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({
    super.key,
    required this.todos,
    required this.onAddTodo,
    required this.onToggleTodo,
    required this.onDeleteTodo,
  });

  final List<Todo> todos;

  final ValueChanged<String> onAddTodo;
  final ValueChanged<int> onToggleTodo;
  final ValueChanged<int> onDeleteTodo;

  @override
  State<TodoScreen> createState() {
    return _TodoScreenState();
  }
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController =
  TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _submitTodo() {
    final String taskTitle =
    _taskController.text.trim();

    if (taskTitle.isEmpty) {
      return;
    }

    widget.onAddTodo(taskTitle);

    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(12),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,

                    decoration:
                    const InputDecoration(
                      labelText: 'New Task',
                      border:
                      OutlineInputBorder(),
                    ),

                    onSubmitted: (_) {
                      _submitTodo();
                    },
                  ),
                ),

                const SizedBox(width: 12),

                FilledButton(
                  onPressed: _submitTodo,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: widget.todos.isEmpty
              ? const Center(
            child: Text(
              'No tasks yet.\nAdd one to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
              : ListView.builder(
            padding:
            const EdgeInsets.all(12),

            itemCount:
            widget.todos.length,

            itemBuilder:
                (BuildContext context,
                int index) {
              final Todo todo =
              widget.todos[index];

              return Dismissible(
                key: ValueKey<Todo>(todo),

                direction:
                DismissDirection
                    .endToStart,

                onDismissed: (_) {
                  widget.onDeleteTodo(
                    index,
                  );
                },

                background: Container(
                  alignment:
                  Alignment.centerRight,

                  padding:
                  const EdgeInsets.only(
                    right: 20,
                  ),

                  color: Colors.red,

                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),

                child: Card(
                  child: TodoTile(
                    todo: todo,

                    onChanged: (_) {
                      widget
                          .onToggleTodo(
                        index,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
