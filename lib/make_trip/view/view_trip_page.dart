import 'package:flutter/material.dart';
import 'package:travelapp/firestore_service.dart';

import 'package:travelapp/edit_todo/view/edit_todo_page.dart';
import 'package:travelapp/make_trip/view/make_trip_page.dart';

class ViewTripPage extends StatefulWidget {
  @override
  _ViewTripPageState createState() => _ViewTripPageState();
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ViewTripPage(),
    );
  }
}

class _ViewTripPageState extends State<ViewTripPage> {
  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Trips'),
      ),
      body: Center(
          child: StreamBuilder(
        stream: firestoreService.getTrips(),
        builder: (BuildContext context, AsyncSnapshot<List<Trip>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.map((Trip trip) {
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.airplanemode_active),
                      title: Text(trip.name),
                      subtitle: Text(trip.destination),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TirpDetails(trip: trip),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      )),
    );
  }
}

class TirpDetails extends StatefulWidget {
  final Trip trip;
  const TirpDetails({Key? key, required this.trip}) : super(key: key);

  @override
  _TirpDetailsState createState() => _TirpDetailsState();
}

class _TirpDetailsState extends State<TirpDetails> {
  final firestoreService = FirestoreService();
  

  void _addFriendEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      print(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email address'),
        ),
      );
      return;
    }
    setState(() {
      widget.trip.friendsEmails.add(email);
      firestoreService.addfriendtoTrip(widget.trip.id, email);
    });
  }

  @override
  Widget build(BuildContext context) {
      final _emailController = TextEditingController();
      final _nameController = TextEditingController(text: widget.trip.name);
      final _destinationController = TextEditingController(text: widget.trip.destination);
      DateTime? _startDate=widget.trip.startDate;
      DateTime? _endDate=widget.trip.endDate;
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.name),
      ),
      //make it scrollable
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
      Center(
        child: Column(
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
              controller: _destinationController,
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
            Text('Friends:'),
            Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.trip.friendsEmails.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(widget.trip.friendsEmails[index],
                        textAlign: TextAlign.center),
                    leadingAndTrailingTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(EditTodoPage.route(trip: widget.trip));
                  },
                  child: const Text('Add Todo'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Add Friend'),
                          content: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Enter friend\'s email',
                            ),
                            controller: _emailController,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                _addFriendEmail(_emailController.text);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Add Friend'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Add Friend'),

                ),
                // make changes here to submit the edited the trip 
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _destinationController.text.isEmpty ||
                        _startDate == null ||
                        _endDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all the fields'),
                        ),
                      );
                      return;
                    }
                    Trip trip = Trip(
                      id: widget.trip.id,
                      owner: widget.trip.owner,
                      name: _nameController.text,
                      destination: _destinationController.text,
                      startDate: _startDate!,
                      endDate: _endDate!,
                      friendsEmails: widget.trip.friendsEmails,
                      todos: widget.trip.todos,
                    );
                    firestoreService.editTrip(trip);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                ),


              ],
            ),
          ],
        ),
      ),
    ),
    ),
    );
  }
}