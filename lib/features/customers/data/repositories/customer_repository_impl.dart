import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:rtm_visits/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:rtm_visits/features/customers/domain/entities/customer.dart';
import 'package:rtm_visits/features/customers/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;
  final CustomerLocalDataSource localDataSource;
  final Connectivity connectivity;

  CustomerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Customer>>> getAllCustomers() async {
    try {
      if ((await connectivity.checkConnectivity()).contains(ConnectivityResult.none)) {
        final localCustomers = await localDataSource.getCustomers();
        return Right(localCustomers.map((model) => model.toEntity()).toList());
      }

      final remoteCustomers = await remoteDataSource.getCustomers();
      await localDataSource.cacheCustomers(remoteCustomers);
      return Right(remoteCustomers.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to fetch customers: $e'));
    }
  }
}
