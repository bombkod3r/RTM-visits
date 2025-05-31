import 'package:dartz/dartz.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/domain/repositories/visit_repository.dart';

class UpdateVisit {
  final VisitRepository repository;

  UpdateVisit(this.repository);

  Future<Either<Failure, Visit>> call(Visit visit) async {
    return await repository.updateVisit(visit);
  }
}