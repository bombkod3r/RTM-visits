import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/domain/usecases/add_visit.dart';
import 'package:rtm_visits/features/visits/domain/usecases/delete_visit.dart';
import 'package:rtm_visits/features/visits/domain/usecases/get_visits.dart';
import 'package:rtm_visits/features/visits/domain/usecases/update_visit.dart';

part 'visit_event.dart';
part 'visit_state.dart';

class VisitBloc extends Bloc<VisitEvent, VisitState> {
  final GetVisits getVisits;
  final AddVisit addVisit;
  final UpdateVisit updateVisit;
  final DeleteVisit deleteVisit;

  VisitBloc({
    required this.getVisits,
    required this.addVisit,
    required this.updateVisit,
    required this.deleteVisit,
  }) : super(VisitInitial()) {
    on<FetchVisits>(_onFetchVisits);
    on<AddVisitEvent>(_onAddVisit);
    on<UpdateVisitEvent>(_onUpdateVisit);
    on<DeleteVisitEvent>(_onDeleteVisit);
  }

  Future<void> _onFetchVisits(FetchVisits event, Emitter<VisitState> emit) async {
    emit(VisitLoading());
    final result = await getVisits();
    result.fold(
      (failure) => emit(VisitError(failure.message)),
      (visits) => emit(VisitLoaded(visits)),
    );
  }

  Future<void> _onAddVisit(AddVisitEvent event, Emitter<VisitState> emit) async {
    emit(VisitLoading());
    final result = await addVisit(event.visit);
    result.fold(
      (failure) => emit(VisitError(failure.message)),
      (visit) => emit(VisitOperationSuccess(visit)),
    );
    add(FetchVisits());
  }

  Future<void> _onUpdateVisit(UpdateVisitEvent event, Emitter<VisitState> emit) async {
    emit(VisitLoading());
    final result = await updateVisit(event.visit);
    result.fold(
      (failure) => emit(VisitError(failure.message)),
      (visit) => emit(VisitOperationSuccess(visit)),
    );
    add(FetchVisits());
  }

  Future<void> _onDeleteVisit(DeleteVisitEvent event, Emitter<VisitState> emit) async {
    emit(VisitLoading());
    final result = await deleteVisit(event.id);
    result.fold(
      (failure) => emit(VisitError(failure.message)),
      (_) => emit(VisitOperationSuccess(null)),
    );
    add(FetchVisits());
  }
}