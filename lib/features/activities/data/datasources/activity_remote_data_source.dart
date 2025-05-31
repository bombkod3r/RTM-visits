import 'package:dio/dio.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/features/activities/data/models/activity_model.dart';

abstract class ActivityRemoteDataSource {
  Future<List<ActivityModel>> getActivities();
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final Dio dio;

  ActivityRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ActivityModel>> getActivities() async {
    try {
      final response = await dio.get('/activities?select=*');
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => ActivityModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch activities: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }
}