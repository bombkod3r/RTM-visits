import 'package:dio/dio.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/features/visits/data/models/visit_model.dart';

abstract class VisitRemoteDataSource {
  Future<List<VisitModel>> getVisits();
  Future<VisitModel> addVisit(VisitModel visit);
  Future<VisitModel> updateVisit(VisitModel visit);
  Future<void> deleteVisit(int id);
}

class VisitRemoteDataSourceImpl implements VisitRemoteDataSource {
  final Dio dio;

  VisitRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VisitModel>> getVisits() async {
    try {
      final response = await dio.get('/visits?select=*');
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => VisitModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch visits: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<VisitModel> addVisit(VisitModel visit) async {
    try {
      final response = await dio.post(
        '/visits',
        data: visit.toJson(),
        options: Options(headers: {'Prefer': 'return=representation'}),
      );
      if (response.statusCode == 201) {
        return VisitModel.fromJson(response.data[0]);
      } else {
        throw ServerException('Failed to add visit: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<VisitModel> updateVisit(VisitModel visit) async {
    try {
      final response = await dio.patch(
        '/visits?id=eq.${visit.id}',
        data: visit.toJson(),
        options: Options(headers: {'Prefer': 'return=representation'}),
      );
      if (response.statusCode == 200) {
        return VisitModel.fromJson(response.data[0]);
      } else {
        throw ServerException('Failed to update visit: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<void> deleteVisit(int id) async {
    try {
      final response = await dio.delete('/visits?id=eq.$id');
      if (response.statusCode != 204) {
        throw ServerException('Failed to delete visit: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }
}