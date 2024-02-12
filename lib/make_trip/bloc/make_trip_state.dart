import 'package:equatable/equatable.dart';

abstract class MakeTripState extends Equatable {
  const MakeTripState();

  @override
  List<Object> get props => [];
}

class MakeTripInitial extends MakeTripState {}

class MakeTripLoading extends MakeTripState {}

class MakeTripSuccess extends MakeTripState {
  final String message;

  const MakeTripSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class MakeTripFailure extends MakeTripState {
  final String error;

  const MakeTripFailure(this.error);

  @override
  List<Object> get props => [error];
}
