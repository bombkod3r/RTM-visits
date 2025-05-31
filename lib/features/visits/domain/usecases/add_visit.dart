import 'package:dartz/dartz.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/domain/repositories/visit_repository.dart';

class AddVisit {
  final VisitRepository repository;

  AddVisit(this.repository);

  Future<Either<Failure, Visit>> call(Visit visit) async {
    return await repository.addVisit(visit);
  }
}