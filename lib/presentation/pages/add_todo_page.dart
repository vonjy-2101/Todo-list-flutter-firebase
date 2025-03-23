import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';

class AddTodoPage extends StatefulWidget {
    @override
    _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    @override
    void dispose() {
        _titleController.dispose();
        _descriptionController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: const Text('Ajouter une tâche'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un titre';
                    }
                    return null;
                    },
                ),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () {
                    if (_formKey.currentState!.validate()) {
                        final todoProvider = Provider.of<TodoProvider>(
                        context,
                        listen: false,
                        );
                        
                        todoProvider.addTodo(
                        _titleController.text,
                        _descriptionController.text,
                        );
                        
                        Navigator.pop(context);
                    }
                    },
                    child: const Text('Ajouter'),
                ),
                ],
            ),
            ),
        ),
        );
    }
}