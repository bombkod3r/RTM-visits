import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/activities/data/datasources/activity_local_data_source.dart';
import 'package:rtm_visits/features/activities/data/datasources/activity_remote_data_source.dart';
import 'package:rtm_visits/features/activities/data/models/activity_model.dart';
import 'package:rtm_visits/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:rtm_visits/features/activities/domain/entities/activity.dart';
import 'activity_repository_test.mocks.dart';

@GenerateMocks([ActivityRemoteDataSource, ActivityLocalDataSource, Connectivity])
void main() {
  late ActivityRepositoryImpl repository;
  late MockActivityRemoteDataSource mockRemoteDataSource;
  late MockActivityLocalDataSource mockLocalDataSource;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockRemoteDataSource = MockActivityRemoteDataSource();
    mockLocalDataSource = MockActivityLocalDataSource();
    mockConnectivity = MockConnectivity();
    repository = ActivityRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectivity: mockConnectivity,
    );
  });

  final tActivityModel = ActivityModel(
    id: 1,
    description: 'Test Activity',
    createdAt: '2023-10-01T10:00:00Z',
  );

  final tActivity = tActivityModel.toEntity();

  group('getAllActivities', () {
    test('should return remote data when device is online', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockRemoteDataSource.getActivities()).thenAnswer((_) async => [tActivityModel]);
      when(mockLocalDataSource.cacheActivities(any)).thenAnswer((_) async => null);

      // act
      final result = await repository.getAllActivities();

      // assert
      expect(result, Right([tActivity]));
      verify(mockRemoteDataSource.getActivities());
      verify(mockLocalDataSource.cacheActivities([tActivityModel]));
    });

    test('should return local data when device is offline', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.none]);
      when(mockLocalDataSource.getActivities()).thenAnswer((_) async => [tActivityModel]);

      // act
      final result = await repository.getAllActivities();

      // assert
      expect(result, Right([tActivity]));
      verify(mockLocalDataSource.getActivities());
      verifyNever(mockRemoteDataSource.getActivities());
    });

    test('should return failure when remote data source throws exception', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockRemoteDataSource.getActivities()).thenThrow(ServerException('Server error'));

      // act
      final result = await repository.getAllActivities();

      // assert
      expect(result, Left(ServerFailure('Failed to fetch activities: ServerException: Server error')));
      verify(mockRemoteDataSource.getActivities());
    });
  });
}