import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtm_visits/features/activities/domain/entities/activity.dart';
import 'package:rtm_visits/features/activities/domain/usecases/get_activities.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetActivities getActivities;

  ActivityBloc({required this.getActivities}) : super(ActivityInitial()) {
    on<FetchActivities>((event, emit) async {
      emit(ActivityLoading());
      final result = await getActivities();
      result.fold(
        (failure) => emit(ActivityError(message: failure.message)),
        (activities) => emit(ActivityLoaded(activities: activities)),
      );
    });
  }
}