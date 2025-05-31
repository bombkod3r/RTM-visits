import 'package:dartz/dartz.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/statistics/domain/entities/statistics.dart';
import 'package:rtm_visits/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:rtm_visits/features/visits/domain/repositories/visit_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final VisitRepository visitRepository;

  StatisticsRepositoryImpl({required this.visitRepository});

  @override
  Future<Either<Failure, Statistics>> getStatistics() async {
    try {
      final visitsResult = await visitRepository.getAllVisits();
      return visitsResult.fold(
        (failure) => Left(failure),
        (visits) {
          final totalVisits = visits.length;
          final completedVisits = visits.where((v) => v.status == 'Completed').length;
          final pendingVisits = visits.where((v) => v.status == 'Pending').length;
          final cancelledVisits = visits.where((v) => v.status == 'Cancelled').length;

          final stats = Statistics(
            totalVisits: totalVisits,
            completedVisits: completedVisits,
            pendingVisits: pendingVisits,
            cancelledVisits: cancelledVisits,
          );
          return Right(stats);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to fetch statistics: $e'));
    }
  }
}