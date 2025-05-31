import 'package:dartz/dartz.dart';
import 'package:rtm_visits/core/error/failures.dart';
import 'package:rtm_visits/features/activities/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<Activity>>> getAllActivities();
}