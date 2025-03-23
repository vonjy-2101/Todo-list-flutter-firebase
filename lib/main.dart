import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_firebase/core/config/firebase_options.dart';
import 'package:todo_list_firebase/data/datasources/todo_firebase_datasource.dart';
import 'package:todo_list_firebase/data/repositories/todo_repository_impl.dart';
import 'package:todo_list_firebase/presentation/pages/home_page.dart';
import 'package:todo_list_firebase/presentation/providers/todo_provider.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MultiProvider(
            providers: [
                ChangeNotifierProvider(
                    create: (_) => TodoProvider(
                            repository: TodoRepositoryImpl(
                            dataSource: TodoFirebaseDataSource(),
                        ),
                    ),
                ),
            ],
            child: MaterialApp(
                title: 'Flutter Firebase Todo',
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: HomePage(),
            ),
        );
    }
}
