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
              return ListTile(
                title: Text(trip.name),
                subtitle: Text(trip.destination),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).push(
                    ViewTripDetailsPage.route(trip),
                  );
                },
              );
            }).toList(),
          );
        },
      )),
    );
  }
}

class ViewTripDetailsPage extends StatefulWidget {
  final Trip trip;
  ViewTripDetailsPage({required this.trip});
  static Route<void> route(Trip trip) {
    return MaterialPageRoute(
      builder: (context) => ViewTripDetailsPage(trip: trip),
    );
  }

  @override
  _ViewTripDetailsPageState createState() => _ViewTripDetailsPageState();
}

class _ViewTripDetailsPageState extends State<ViewTripDetailsPage> {
  @override
  Widget build(BuildContext context) {
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
            Text('Friends: ${widget.trip.friendsEmails}'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(EditTodoPage.route());
              },
              child: Text('Add Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
