import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtm_visits/features/statistics/domain/entities/statistics.dart';
import 'package:rtm_visits/features/statistics/domain/usecases/get_statistics.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetStatistics getStatistics;

  StatisticsBloc({required this.getStatistics}) : super(StatisticsInitial()) {
    on<FetchStatistics>(_onFetchStatistics);
  }

  Future<void> _onFetchStatistics(FetchStatistics event, Emitter<StatisticsState> emit) async {
    emit(StatisticsLoading());
    final result = await getStatistics();
    result.fold(
      (failure) => emit(StatisticsError(failure.message)),
      (statistics) => emit(StatisticsLoaded(statistics)),
    );
  }
}