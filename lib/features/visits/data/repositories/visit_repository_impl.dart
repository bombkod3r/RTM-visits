import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/visits/data/datasources/visit_local_data_source.dart';
import 'package:rtm_visits/features/visits/data/datasources/visit_remote_data_source.dart';
import 'package:rtm_visits/features/visits/data/models/visit_model.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/domain/repositories/visit_repository.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitRemoteDataSource remoteDataSource;
  final VisitLocalDataSource localDataSource;
  final Connectivity connectivity;

  VisitRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Visit>>> getAllVisits() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        final localVisits = await localDataSource.getVisits();
        return Right(localVisits.map((model) => model.toEntity()).toList());
      }
      final remoteVisits = await remoteDataSource.getVisits();
      await localDataSource.cacheVisits(remoteVisits);
      return Right(remoteVisits.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to fetch visits: $e'));
    }
  }

  @override
  Future<Either<Failure, Visit>> addVisit(Visit visit) async {
    try {
      final model = VisitModel.fromEntity(visit);
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await localDataSource.cacheVisit(model);
        return Right(model.toEntity());
      }
      final remoteVisit = await remoteDataSource.addVisit(model);
      await localDataSource.cacheVisit(remoteVisit);
      return Right(remoteVisit.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to add visit: $e'));
    }
  }

  @override
  Future<Either<Failure, Visit>> updateVisit(Visit visit) async {
    try {
      final model = VisitModel.fromEntity(visit);
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await localDataSource.cacheVisit(model);
        return Right(model.toEntity());
      }
      final remoteVisit = await remoteDataSource.updateVisit(model);
      await localDataSource.cacheVisit(remoteVisit);
      return Right(remoteVisit.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to update visit: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVisit(int id) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await localDataSource.deleteVisit(id);
        return const Right(unit);
      }
      await remoteDataSource.deleteVisit(id);
      await localDataSource.deleteVisit(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Failed to delete visit: $e'));
    }
  }
}