part of 'visit_bloc.dart';

abstract class VisitEvent extends Equatable {
  const VisitEvent();

  @override
  List<Object> get props => [];
}

class FetchVisits extends VisitEvent {}

class AddVisitEvent extends VisitEvent {
  final Visit visit;

  const AddVisitEvent(this.visit);

  @override
  List<Object> get props => [visit];
}

class UpdateVisitEvent extends VisitEvent {
  final Visit visit;

  const UpdateVisitEvent(this.visit);

  @override
  List<Object> get props => [visit];
}

class DeleteVisitEvent extends VisitEvent {
  final int id;

  const DeleteVisitEvent(this.id);

  @override
  List<Object> get props => [id];
}