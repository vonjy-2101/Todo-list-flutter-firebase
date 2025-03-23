import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
    TodoModel({
        required String id,
        required String title,
        required String description,
        required bool isCompleted,
        required DateTime createdAt,
    }) : super(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            createdAt: createdAt,
            );

    factory TodoModel.fromJson(Map<String, dynamic> json) {
        return TodoModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        isCompleted: json['isCompleted'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        );
    }

    Map<String, dynamic> toJson() {
        return {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'createdAt': Timestamp.fromDate(createdAt),
        };
    }

    factory TodoModel.fromFirestore(DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return TodoModel(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        isCompleted: data['isCompleted'] ?? false,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
    }
}