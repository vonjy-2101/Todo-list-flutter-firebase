import 'package:todo_list_firebase/domain/entities/todo.dart';

abstract class TodoRepository {
    Stream<List<Todo>> getTodos();
    Future<void> addTodo(Todo todo);
    Future<void> updateTodo(Todo todo);
    Future<void> deleteTodo(String id);
}