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
  
  //edit the trip
  Future<void> editTrip(Trip trip) {
    return _tripsCollection.doc(trip.id).update({
      'owner': trip.owner,
      'destination': trip.destination,
      'startDate': trip.startDate,
      'endDate': trip.endDate,
      'friendsEmails': trip.friendsEmails,
      'todos': trip.todos,
      'name': trip.name,
    });
  }
  Future<void> addtrip(Trip trip) {
    String email = FirebaseAuth.instance.currentUser!.email!;
    return _tripsCollection.add({
      'owner': trip.owner,
      'destination': trip.destination,
      'startDate': trip.startDate,
      'endDate': trip.endDate,
      'friendsEmails': trip.friendsEmails,
      'todos': trip.todos,
      'name': trip.name,
    })
      ..then((value) => print("Trip added successfully!"))
          .catchError((error) => print("Failed to add user: $error"));
  }
  Future<void> addfriendtoTrip(String? tripId, String friendEmail) {
    if (tripId == null) {
      return Future.error('tripId is null');
    }
    return _tripsCollection.doc(tripId).update({
      'friendsEmails': FieldValue.arrayUnion([friendEmail]),
    });
  }
  Stream<List<Trip>> getTrips() {
    print('called');
    return _tripsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Trip.fromJson(data, doc.id);
      }).toList();
    });
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
    return _todosCollection.doc(email).set({
      todo.id: {
        'title': todo.title,
        'isCompleted': todo.isCompleted,
        'description': todo.description,
      }
    }, SetOptions(merge: true))
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
