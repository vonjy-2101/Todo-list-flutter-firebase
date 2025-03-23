import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import 'add_todo_page.dart';

class HomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: const Text('Todo List'),
        ),
        body: Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
            if (todoProvider.isLoading) {
                return const Center(
                child: CircularProgressIndicator(),
                );
            }

            if (todoProvider.todos.isEmpty) {
                return const Center(
                child: Text('Aucune tâche. Ajoutez-en une !'),
                );
            }

            return ListView.builder(
                itemCount: todoProvider.todos.length,
                itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return Dismissible(
                    key: Key(todo.id),
                    background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                    ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                    todoProvider.deleteTodo(todo.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${todo.title} supprimé')),
                    );
                    },
                    child: ListTile(
                    title: Text(
                        todo.title,
                        style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        ),
                    ),
                    subtitle: Text(todo.description),
                    trailing: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) {
                        todoProvider.toggleTodoStatus(todo);
                        },
                    ),
                    ),
                );
                },
            );
            },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTodoPage()),
            );
            },
            child: const Icon(Icons.add),
        ),
        );
    }
}