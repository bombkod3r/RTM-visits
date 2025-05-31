import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/visits/data/datasources/visit_local_data_source.dart';
import 'package:rtm_visits/features/visits/data/datasources/visit_remote_data_source.dart';
import 'package:rtm_visits/features/visits/data/models/visit_model.dart';
import 'package:rtm_visits/features/visits/data/repositories/visit_repository_impl.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';

import 'visit_repository_test.mocks.dart';

@GenerateMocks([VisitRemoteDataSource, VisitLocalDataSource, Connectivity])
void main() {
  late VisitRepositoryImpl repository;
  late MockVisitRemoteDataSource mockRemoteDataSource;
  late MockVisitLocalDataSource mockLocalDataSource;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockRemoteDataSource = MockVisitRemoteDataSource();
    mockLocalDataSource = MockVisitLocalDataSource();
    mockConnectivity = MockConnectivity();
    repository = VisitRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectivity: mockConnectivity,
    );
  });

  final tVisitModel = VisitModel(
    id: 1,
    customerId: 1,
    visitDate: '2023-10-01T10:00:00Z',
    status: 'Completed',
    location: '123 Main St',
    notes: 'Test visit',
    activitiesDone: ['1'],
    createdAt: '2023-10-01T10:00:00Z',
  );

  final tVisit = tVisitModel.toEntity();

  group('getAllVisits', () {
    test('should return remote data when device is online', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockRemoteDataSource.getVisits()).thenAnswer((_) async => [tVisitModel]);
      when(mockLocalDataSource.cacheVisits(any)).thenAnswer((_) async => null);

      // act
      final result = await repository.getAllVisits();

      // assert
      expect(result, Right([tVisit]));
      verify(mockRemoteDataSource.getVisits());
      verify(mockLocalDataSource.cacheVisits([tVisitModel]));
    });

    test('should return local data when device is offline', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.none]);
      when(mockLocalDataSource.getVisits()).thenAnswer((_) async => [tVisitModel]);

      // act
      final result = await repository.getAllVisits();

      // act

      // assert
      expect(result, Right([tVisit]));
      verify(mockLocalDataSource.getVisits());
      verifyNever(mockRemoteDataSource.getVisits());
    });

    test('should return failure when remote data source throws exception', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockRemoteDataSource.getVisits()).thenThrow(ServerException('Server error'));

      // act
      final result = await repository.getAllVisits();

      // assert
      expect(result, Left(ServerFailure('Failed to fetch visits: ServerException: Server error')));
      verify(mockRemoteDataSource.getVisits());
    });
  });

  group('addVisit', () {
    test('should add visit remotely when online', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockRemoteDataSource.addVisit(any)).thenAnswer((_) async => tVisitModel);
      when(mockLocalDataSource.cacheVisit(any)).thenAnswer((_) async => null);

      // act
      final result = await repository.addVisit(tVisit);

      // assert
      expect(result, Right(tVisit));
      verify(mockRemoteDataSource.addVisit(tVisitModel));
      verify(mockLocalDataSource.cacheVisit(tVisitModel));
    });

    test('should cache visit locally when offline', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.none]);
      when(mockLocalDataSource.cacheVisit(any)).thenAnswer((_) async => null);

      // act
      final result = await repository.addVisit(tVisit);

      // assert
      expect(result, Right(tVisit));
      verify(mockLocalDataSource.cacheVisit(tVisitModel));
      verifyNever(mockRemoteDataSource.addVisit(any));
    });
  });
}