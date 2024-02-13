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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.name),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Destination: ${widget.trip.destination}'),
            Text('Start Date: ${widget.trip.startDate}'),
            Text('End Date: ${widget.trip.endDate}'),
            Text('Friends:'),
            Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.trip.friendsEmails.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(widget.trip.friendsEmails[index], textAlign: TextAlign.center),
                
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(EditTodoPage.route());
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}