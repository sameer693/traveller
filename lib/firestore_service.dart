import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:travelapp/app/bloc/app_bloc.dart';
  import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelapp/make_trip/view/make_trip_page.dart';
class FirestoreService {
  //get email from

  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');

  Future<void>addtrip(Trip trip) {
    String email = FirebaseAuth.instance.currentUser!.email!;
    return _tripsCollection.doc(email).set({trip.name:{
      'destination': trip.destination,
      'startDate': trip.startDate,
      'endDate': trip.endDate,
      'friendsEmails': trip.friendsEmails,
      'todos': trip.todos,
    }}
    ,SetOptions(merge: true))
      ..then((value) => print("Trip added successfully!"))
          .catchError((error) => print("Failed to add user: $error"));
  }

  Stream<List<Todo>> getTodos() {
    return _todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Todo(
          id: doc.id,
          title: data['title'],
          isCompleted: data['isCompleted'],
        );
      }).toList();
    });
  }

  Future<void> addTodo(Todo todo) {
    String email = FirebaseAuth.instance.currentUser!.email!;
    return _todosCollection.doc(email).set({todo.id:{
      'title': todo.title,
      'isCompleted': todo.isCompleted,
      'description' :todo.description,
      
    }}
    ,SetOptions(merge: true))
      ..then((value) => print("User added successfully!"))
          .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateTodo(Todo todo) {
    return _todosCollection.doc(todo.id).update({
      'title': todo.title,
      'isCompleted': todo.isCompleted,
    });
  }

  Future<void> deleteTodo(String todoId) {
    return _todosCollection.doc(todoId).delete();
  }
}
