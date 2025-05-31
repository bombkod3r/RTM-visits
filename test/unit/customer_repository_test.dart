import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:rtm_visits/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:rtm_visits/features/customers/data/models/customer_model.dart';
import 'package:rtm_visits/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:rtm_visits/features/customers/domain/entities/customer.dart';
import 'customer_repository_test.mocks.dart';

@GenerateMocks([CustomerRemoteDataSource, CustomerLocalDataSource, Connectivity])
void main() {
  late CustomerRepositoryImpl repository;
  late MockCustomerRemoteDataSource mockRemoteDataSource;
  late MockCustomerLocalDataSource mockLocalDataSource;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockRemoteDataSource = MockCustomerRemoteDataSource();
    mockLocalDataSource = MockCustomerLocalDataSource();
    mockConnectivity = MockConnectivity();
    repository = CustomerRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectivity: mockConnectivity,
    );
  });

  final tCustomerModel = CustomerModel(
    id: 1,
    name: 'Test Customer',
    createdAt: '2023-10-01T10:00:00Z',
  );

  final tCustomer = tCustomerModel.toEntity();

  group('getAllCustomers', () {
    test('should return remote data when device is online', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockRemoteDataSource.getCustomers()).thenAnswer((_) async => [tCustomerModel]);
      when(mockLocalDataSource.cacheCustomers(any)).thenAnswer((_) async => null);

      // act
      final result = await repository.getAllCustomers();

      // assert
      expect(result, Right([tCustomer]));
      verify(mockRemoteDataSource.getCustomers());
      verify(mockLocalDataSource.cacheCustomers([tCustomerModel]));
    });

    test('should return local data when device is offline', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.none]);
      when(mockLocalDataSource.getCustomers()).thenAnswer((_) async => [tCustomerModel]);

      // act
      final result = await repository.getAllCustomers();

      // assert
      expect(result, Right([tCustomer]));
      verify(mockLocalDataSource.getCustomers());
      verifyNever(mockRemoteDataSource.getCustomers());
    });

    test('should return failure when remote data source throws exception', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockRemoteDataSource.getCustomers()).thenThrow(ServerException('Server error'));

      // act
      final result = await repository.getAllCustomers();

      // assert
      expect(result, Left(ServerFailure('Failed to fetch customers: ServerException: Server error')));
      verify(mockRemoteDataSource.getCustomers());
    });
  });
}