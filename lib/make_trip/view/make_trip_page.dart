import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_api/todos_api.dart';
import 'package:travelapp/firestore_service.dart';
import 'package:travelapp/make_trip/bloc/make_trip_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';

class MakeTripPage extends StatefulWidget {
  @override
  _MakeTripPageState createState() => _MakeTripPageState();

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => MakeTripBloc(
            // Pass any necessary dependencies to MakeTripBloc
            ),
        child: MakeTripPage(),
      ),
    );
  }
}

class _MakeTripPageState extends State<MakeTripPage> {
  DateTime _startDate;
  DateTime _endDate;
  _MakeTripPageState()
      : _startDate = DateTime.now(),
        _endDate = DateTime.now().add(Duration(days: 1));

  final List<String> _friendsEmails = [];
  final _emailController = TextEditingController();
  FirestoreService firestoreService = FirestoreService();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _addFriendEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email address')),
      );
      return;
    }
    setState(() {
      _friendsEmails.add(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(  // Add this
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name your Trip:',
                  style: TextStyle(fontSize: 18, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter trip name',
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  ),
                  controller: _nameController,
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a trip name';
                    }
                    return null;
                  },
                ),
                Text(
                  'Destination:',
                  style: TextStyle(fontSize: 18, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter destination',
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  ),
                  controller: _destinationController,
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a destination';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Select Trip Dates:',
                  style: TextStyle(fontSize: 18,),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectStartDate(context),
                      child: Text('Select Start Date'),
                    ),
                    SizedBox(width: 8),
                    Flexible(  // Add this
                      child: Text('Start Date: ${_startDate.toString()}', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectEndDate(context),
                      child: Text('Select End Date'),
                    ),
                    SizedBox(width: 8),
                    Flexible(  // Add this
                      child: Text('End Date: ${_endDate.toString()}', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Add Friends Emails:',
                  style: TextStyle(fontSize: 18, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Add the email to the list
                        _addFriendEmail(_emailController.text);
                        _emailController.clear();
                      },
                    ),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter an email';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 8),
                Text('Friends Emails:'
                    , style: TextStyle(fontSize: 18, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                Column(
                  children: _friendsEmails.map((email) => Text(email, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),)).toList(),
                ),
                // Add a button to submit the form
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate the form
                      if (_formKey.currentState!.validate()) {
                        // Create a new trip
                        final trip = Trip(
                          owner: FirebaseAuth.instance.currentUser!.email!,
                          name: _nameController.text,
                          destination: _destinationController.text,
                          startDate: _startDate,
                          endDate: _endDate,
                          friendsEmails: _friendsEmails,
                          todos: [],
                        );
                        // Add the trip to the database
                        firestoreService.addtrip(trip);
                        // Navigate back to the home page
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Create Trip'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Trip {
  String name;
  String destination;
  DateTime startDate;
  DateTime endDate;
  String owner;
  List<String> friendsEmails;
  List<Todo> todos;
  String id;

  Trip({
    this.id = '',
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.friendsEmails,
    required this.todos,
    required this.owner,
  });
  // implement fromJson and toJson
  factory Trip.fromJson(Map<String, dynamic> json, String key) {
    //make a list of todos  from a json todo which is a list of maps
    List<Todo> todos = [];
    for (var todo in json['todos']) {
      Map<String, dynamic> todoData = todo;
      todoData.map((key, value) {
        value['id'] = key;
        return MapEntry(key, value);
      }).forEach((key, value) {
        todos.add(Todo.fromJson(value));
      });
     }
    return Trip(
        name: json['name'],
        destination: json['destination'],
        startDate: (json['startDate']).toDate(),
        endDate: (json['endDate']).toDate(),
        friendsEmails: List<String>.from(json['friendsEmails']),
        todos: todos,
        owner: json['owner'],
        id: key);
  }
  // implement toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'friendsEmails': friendsEmails,
      'todos': todos,
      'owner': owner,
    };
  }
}