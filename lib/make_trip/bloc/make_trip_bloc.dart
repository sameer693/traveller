import 'dart:async';
import 'package:bloc/bloc.dart';

// Define the events
abstract class MakeTripEvent {}

class StartTripEvent extends MakeTripEvent {
  final String destination;

  StartTripEvent(this.destination);
}

class EndTripEvent extends MakeTripEvent {}

// Define the states
abstract class MakeTripState {}

class InitialMakeTripState extends MakeTripState {}

class TripInProgressState extends MakeTripState {
  final String destination;

  TripInProgressState(this.destination);
}

class TripCompletedState extends MakeTripState {}

// Define the bloc
class MakeTripBloc extends Bloc<MakeTripEvent, MakeTripState> {
  MakeTripBloc() : super(InitialMakeTripState());

  @override
  Stream<MakeTripState> mapEventToState(MakeTripEvent event) async* {
    if (event is StartTripEvent) {
      yield TripInProgressState(event.destination);
    } else if (event is EndTripEvent) {
      yield TripCompletedState();
    }
  }
}
