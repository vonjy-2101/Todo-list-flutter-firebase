import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

class TodoProvider with ChangeNotifier {
    final TodoRepository repository;
    List<Todo> _todos = [];
    bool _isLoading = false;

    TodoProvider({required this.repository}) {
        _listenToTodos();
    }

    List<Todo> get todos => _todos;
    bool get isLoading => _isLoading;

    void _listenToTodos() {
        repository.getTodos().listen((todos) {
        _todos = todos;
        notifyListeners();
        });
    }

    Future<void> addTodo(String title, String description) async {
        try {
        _isLoading = true;
        notifyListeners();
        
        final todo = Todo(
            id: const Uuid().v4(),
            title: title,
            description: description,
            isCompleted: false,
            createdAt: DateTime.now(),
        );
        
        await repository.addTodo(todo);
        } finally {
        _isLoading = false;
        notifyListeners();
        }
    }

    Future<void> toggleTodoStatus(Todo todo) async {
        try {
        _isLoading = true;
        notifyListeners();
        
        final updatedTodo = Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            isCompleted: !todo.isCompleted,
            createdAt: todo.createdAt,
        );
        
        await repository.updateTodo(updatedTodo);
        } finally {
        _isLoading = false;
        notifyListeners();
        }
    }

    Future<void> deleteTodo(String id) async {
        try {
        _isLoading = true;
        notifyListeners();
        
        await repository.deleteTodo(id);
        } finally {
        _isLoading = false;
        notifyListeners();
        }
    }
}