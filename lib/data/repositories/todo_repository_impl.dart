import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_firebase_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
    final TodoFirebaseDataSource dataSource;

    TodoRepositoryImpl({required this.dataSource});

    @override
    Stream<List<Todo>> getTodos() {
        return dataSource.getTodos();
    }

    @override
    Future<void> addTodo(Todo todo) async {
        final todoModel = TodoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        createdAt: todo.createdAt,
        );
        
        await dataSource.addTodo(todoModel);
    }

    @override
    Future<void> updateTodo(Todo todo) async {
        final todoModel = TodoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        createdAt: todo.createdAt,
        );
        
        await dataSource.updateTodo(todoModel);
    }

    @override
    Future<void> deleteTodo(String id) async {
        await dataSource.deleteTodo(id);
    }
}