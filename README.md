# Documentation - Application Todo List avec Flutter et Firebase

## 1. Introduction

Cette application Todo List est développée avec Flutter et Firebase en suivant les principes de la Clean Architecture. Elle permet aux utilisateurs de créer, lire, mettre à jour et supprimer des tâches avec une synchronisation en temps réel grâce à Firebase Firestore.

## 2. Architecture du projet

L'application est structurée selon les principes de la Clean Architecture, divisant le code en couches distinctes avec des responsabilités spécifiques :

### Structure des dossiers

```
lib/
  ├── core/
  │   ├── error/
  │   │   └── exceptions.dart
  │   └── utils/
  │       └── constants.dart
  ├── data/
  │   ├── datasources/
  │   │   └── todo_firebase_datasource.dart
  │   ├── models/
  │   │   └── todo_model.dart
  │   └── repositories/
  │       └── todo_repository_impl.dart
  ├── domain/
  │   ├── entities/
  │   │   └── todo.dart
  │   ├── repositories/
  │   │   └── todo_repository.dart
  │   └── usecases/
  │       ├── add_todo.dart
  │       ├── delete_todo.dart
  │       ├── get_todos.dart
  │       └── update_todo.dart
  ├── presentation/
  │   ├── providers/
  │   │   └── todo_provider.dart
  │   └── pages/
  │       ├── home_page.dart
  │       └── add_todo_page.dart
  └── main.dart
```

### Couches de l'architecture

1. **Domain** : Contient la logique métier de l'application
   - **Entities** : Définition des objets métier
   - **Repositories** : Interfaces déclarant les méthodes d'accès aux données
   - **Usecases** : Cas d'utilisation spécifiques de l'application

2. **Data** : Implémente l'accès aux données
   - **Models** : Extensions des entités avec des méthodes de conversion
   - **Datasources** : Accès direct aux sources de données (Firebase)
   - **Repositories** : Implémentation des interfaces de repository

3. **Presentation** : Interface utilisateur et gestion d'état
   - **Providers** : Gestion de l'état avec le pattern Provider
   - **Pages** : Écrans de l'application

## 3. Configuration requise

### Prérequis

- Flutter SDK (version 3.0.0 ou supérieure)
- Dart SDK (version 2.17.0 ou supérieure)
- Compte Firebase
- Firebase CLI
- FlutterFire CLI

### Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.15.0
  cloud_firestore: ^4.8.4
  provider: ^6.0.5
  uuid: ^3.0.6
```

## 4. Installation et configuration

### Étape 1 : Cloner le projet

```bash
git clone https://github.com/votre-username/flutter-todo-firebase.git
cd flutter-todo-firebase
```

### Étape 2 : Installer les dépendances

```bash
flutter pub get
```

### Étape 3 : Configurer Firebase

1. Créer un projet Firebase dans la [console Firebase](https://console.firebase.google.com/)
2. Installer les outils Firebase CLI et FlutterFire CLI :
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```
3. Se connecter à Firebase et configurer le projet :
   ```bash
   firebase login
   flutterfire configure --project=votre-projet-firebase
   ```

### Étape 4 : Lancer l'application

```bash
flutter run
```

## 5. Fonctionnalités principales

### Gestion des tâches (todos)

- **Affichage** : Liste des tâches avec indicateur de complétion
- **Ajout** : Création de nouvelles tâches avec titre et description
- **Modification** : Changement du statut d'une tâche (complétée/non complétée)
- **Suppression** : Retrait d'une tâche par glissement (swipe)

### Synchronisation en temps réel

Toutes les modifications sont instantanément synchronisées avec Firebase Firestore et reflétées dans l'interface utilisateur grâce à l'utilisation des Streams.

## 6. Composants clés et leur rôle

### Todo (Entity)

Définit la structure de base d'une tâche avec ses propriétés :

```dart
class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  
  // ...
}
```

### TodoModel

Extension de l'entité Todo avec des méthodes pour la conversion de/vers Firebase :

```dart
class TodoModel extends Todo {
  // Méthodes de conversion
  factory TodoModel.fromFirestore(DocumentSnapshot doc) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

### TodoRepository (Interface)

Définit le contrat pour les opérations sur les todos :

```dart
abstract class TodoRepository {
  Stream<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}
```

### TodoFirebaseDataSource

Gère les interactions directes avec Firebase Firestore :

```dart
class TodoFirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _todosCollection = FirebaseFirestore.instance.collection('todos');
  
  // Méthodes d'accès à Firestore
  Stream<List<TodoModel>> getTodos() { ... }
  Future<void> addTodo(TodoModel todo) { ... }
  // ...
}
```

### TodoRepositoryImpl

Implémente l'interface TodoRepository en utilisant le DataSource :

```dart
class TodoRepositoryImpl implements TodoRepository {
  final TodoFirebaseDataSource dataSource;
  
  // Implémentation des méthodes
  @override
  Stream<List<Todo>> getTodos() { ... }
  // ...
}
```

### TodoProvider

Gère l'état de l'application et fait le lien avec l'UI :

```dart
class TodoProvider with ChangeNotifier {
  final TodoRepository repository;
  List<Todo> _todos = [];
  
  // Méthodes pour manipuler les todos
  Future<void> addTodo(String title, String description) { ... }
  // ...
}
```

## 7. Flux de données

1. **UI → Provider** : L'utilisateur interagit avec l'interface
2. **Provider → Repository** : Le provider appelle les méthodes du repository
3. **Repository → DataSource** : Le repository délègue l'accès aux données au datasource
4. **DataSource → Firebase** : Le datasource communique avec Firestore

Pour les mises à jour en temps réel, le flux inverse se produit :
1. **Firebase → DataSource** : Firestore émet des mises à jour via Stream
2. **DataSource → Repository → Provider → UI** : Les mises à jour remontent à l'interface

## 8. Bonnes pratiques et extensibilité

### Extension des fonctionnalités

Pour ajouter de nouvelles fonctionnalités, suivez ces étapes :

1. Définir les entités dans la couche domain
2. Créer des modèles correspondants dans la couche data
3. Étendre les interfaces repository et leur implémentation
4. Ajouter des usecases si nécessaire
5. Mettre à jour ou créer des providers pour la gestion d'état
6. Développer l'interface utilisateur

### Cas d'utilisation (Usecases)

Pour les opérations complexes, créez des usecases dédiés :

```dart
class GetFilteredTodos {
  final TodoRepository repository;
  
  GetFilteredTodos(this.repository);
  
  Stream<List<Todo>> call({DateTime? date, int limit = 10}) {
    // Logique de filtrage
  }
}
```

## 9. Sécurité et confidentialité

### Informations sensibles

Les fichiers suivants ne doivent jamais être partagés publiquement (à ajouter au .gitignore) :

- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- `firebase_options.dart`
- Tout fichier contenant des clés API ou secrets

### Règles Firestore

Configurez des règles de sécurité appropriées dans la console Firebase pour protéger vos données :

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /todos/{todo} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 10. Ressources additionnelles

- [Documentation Flutter](https://flutter.dev/docs)
- [Documentation Firebase](https://firebase.google.com/docs)
- [Guide Provider pour Flutter](https://pub.dev/packages/provider)
- [Principes de Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
