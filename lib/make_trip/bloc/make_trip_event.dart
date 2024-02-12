import 'package:equatable/equatable.dart';

abstract class MakeTripEvent extends Equatable {
  const MakeTripEvent();

  @override
  List<Object> get props => [];
}

class CreateTrip extends MakeTripEvent {
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;

  const CreateTrip({
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [destination, startDate, endDate];
}

class UpdateTrip extends MakeTripEvent {
  final String destination;
  final DateTime startDate;
  final DateTime endDate;

  const UpdateTrip({
    required this.destination,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [destination, startDate, endDate];
}

class DeleteTrip extends MakeTripEvent {
  final String tripId;

  const DeleteTrip({required this.tripId});

  @override
  List<Object> get props => [tripId];
}
