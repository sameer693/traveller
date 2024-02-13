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
  DateTime? _startDate;
  DateTime? _endDate;
  _MakeTripPageState()
      : _startDate = DateTime.now(),
        _endDate = DateTime.now().add(Duration(days: 1));

  final List<String> _friendsEmails = [];
  final _emailController = TextEditingController();
  FirestoreService firestoreService = FirestoreService();
  final _nameController = TextEditingController();

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
      firstDate: _startDate ?? DateTime.now(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name your Trip:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter trip name',
              ),
              controller: _nameController,
            ),
            Text(
              'Destination:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter destination',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select Trip Dates:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text('Select Start Date'),
                ),
                SizedBox(width: 8),
                Text(_startDate != null
                    ? 'Start Date: ${_startDate.toString()}'
                    : 'Start Date: Not Selected'),
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
                Text(_endDate != null
                    ? 'End Date: ${_endDate.toString()}'
                    : 'End Date: Not Selected'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Add Friends Emails:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Add the email to the list
                    _addFriendEmail(_emailController.text);
                    _emailController.clear();
                  },
                ),
              ),
            ),
            SizedBox(height: 8),
            Text('Friends Emails:'),
            Column(
              children: _friendsEmails.map((email) => Text(email)).toList(),
            ),
            // Add a button to submit the form
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Create a new trip
                  final trip = Trip(
                    owner: FirebaseAuth.instance.currentUser!.email!,
                    name: _nameController.text,
                    destination: 'destination',
                    startDate: _startDate!,
                    endDate: _endDate!,
                    friendsEmails: _friendsEmails,
                    todos: [],
                  );
                  // Add the trip to the database
                  firestoreService.addtrip(trip);
                  // Navigate back to the home page
                  Navigator.of(context).pop();
                },
                child: Text('Create Trip'),
              ),
            )
          ],
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
  String? id;

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
    print(json.toString());
    print(key);
    print(json['startDate'].toString());
    return Trip(
        name: json['name'],
        destination: json['destination'],
        startDate: (json['startDate']).toDate(),
        endDate: (json['endDate']).toDate(),
        friendsEmails: List<String>.from(json['friendsEmails']),
        todos: List<Todo>.from(json['todos']),
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
