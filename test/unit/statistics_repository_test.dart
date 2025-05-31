import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:rtm_visits/features/statistics/domain/entities/statistics.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/domain/repositories/visit_repository.dart';

import 'statistics_repository_test.mocks.dart';


@GenerateMocks([VisitRepository])
void main() {
  late StatisticsRepositoryImpl repository;
  late MockVisitRepository mockVisitRepository;

  setUp(() {
    mockVisitRepository = MockVisitRepository();
    repository = StatisticsRepositoryImpl(visitRepository: mockVisitRepository);
  });

  final tVisit = Visit(
    id: 1,
    customerId: 1,
    visitDate: DateTime.now(),
    status: 'Completed',
    location: '123 Main St',
    notes: 'Test visit',
    activitiesDone: ['1'],
    createdAt: DateTime.now(),
  );

  final tStatistics = Statistics(
    totalVisits: 1,
    completedVisits: 1,
    pendingVisits: 0,
    cancelledVisits: 0,
  );

  group('getStatistics', () {
    test('should return statistics when visits are fetched successfully', () async {
      // arrange
      when(mockVisitRepository.getAllVisits()).thenAnswer((_) async => Right([tVisit]));

      // act
      final result = await repository.getStatistics();

      // assert
      expect(result, Right(tStatistics));
      verify(mockVisitRepository.getAllVisits());
    });

    test('should return failure when visit repository fails', () async {
      // arrange
      when(mockVisitRepository.getAllVisits()).thenAnswer((_) async => Left(ServerFailure('Failed to fetch visits')));

      // act
      final result = await repository.getStatistics();

      // assert
      expect(result, Left(ServerFailure('Failed to fetch visits')));
      verify(mockVisitRepository.getAllVisits());
    });
  });
}