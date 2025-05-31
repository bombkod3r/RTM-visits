import 'package:hive/hive.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/features/activities/data/models/activity_model.dart';
import 'package:rtm_visits/features/activities/data/models/activity_model.dart';

abstract class ActivityLocalDataSource {
  Future<List<ActivityModel>> getActivities();
  Future<void> cacheActivities(List<ActivityModel> activities);
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  final Box<ActivityModel> activityBox;

  ActivityLocalDataSourceImpl({required this.activityBox});

  @override
  Future<List<ActivityModel>> getActivities() async {
    try {
      return activityBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to fetch activities from cache: $e');
    }
  }

  @override
  Future<void> cacheActivities(List<ActivityModel> activities) async {
    try {
      await activityBox.clear();
      await activityBox.addAll(activities);
    } catch (e) {
      throw CacheException('Failed to cache activities: $e');
    }
  }
}