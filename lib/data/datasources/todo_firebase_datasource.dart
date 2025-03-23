import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class TodoFirebaseDataSource {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _todosCollection = FirebaseFirestore.instance.collection('todos');

    Stream<List<TodoModel>> getTodos() {
        return _todosCollection
            .orderBy('createdAt', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => TodoModel.fromFirestore(doc))
                .toList());
    }

    Future<void> addTodo(TodoModel todo) async {
        Map<String, dynamic> todoData = todo.toJson();
        todoData.remove('id');
        
        await _todosCollection.add(todoData);
    }

    Future<void> updateTodo(TodoModel todo) async {
        await _todosCollection.doc(todo.id).update(todo.toJson());
    }

    Future<void> deleteTodo(String id) async {
        await _todosCollection.doc(id).delete();
    }
}