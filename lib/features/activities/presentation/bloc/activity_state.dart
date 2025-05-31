part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  List<Activity> get activities => [];

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<Activity> _activities;

  ActivityLoaded({required List<Activity> activities}) : _activities = activities;

  @override
  List<Activity> get activities => _activities;

  @override
  List<Object> get props => [_activities];
}

class ActivityError extends ActivityState {
  final String message;

  const ActivityError({required this.message});

  @override
  List<Object> get props => [message];
}