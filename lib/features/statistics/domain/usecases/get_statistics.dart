import 'package:dartz/dartz.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/statistics/domain/entities/statistics.dart';
import 'package:rtm_visits/features/statistics/domain/repositories/statistics_repository.dart';

class GetStatistics {
  final StatisticsRepository repository;

  GetStatistics(this.repository);

  Future<Either<Failure, Statistics>> call() async {
    return await repository.getStatistics();
  }
}