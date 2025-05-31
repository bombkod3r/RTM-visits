part of 'visit_bloc.dart';

abstract class VisitState extends Equatable {
  const VisitState();

  @override
  List<Object> get props => [];
}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitLoaded extends VisitState {
  final List<Visit> visits;

  const VisitLoaded(this.visits);

  @override
  List<Object> get props => [visits];
}

class VisitOperationSuccess extends VisitState {
  final Visit? visit;

  const VisitOperationSuccess(this.visit);

  @override
  List<Object> get props => [visit ?? Object()];
}

class VisitError extends VisitState {
  final String message;

  const VisitError(this.message);

  @override
  List<Object> get props => [message];
}