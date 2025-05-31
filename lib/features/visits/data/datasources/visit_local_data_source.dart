import 'package:hive/hive.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/features/visits/data/models/visit_model.dart';

abstract class VisitLocalDataSource {
  Future<List<VisitModel>> getVisits();
  Future<void> cacheVisits(List<VisitModel> visits);
  Future<void> cacheVisit(VisitModel visit);
  Future<void> deleteVisit(int id);
}

class VisitLocalDataSourceImpl implements VisitLocalDataSource {
  final Box<VisitModel> visitBox;

  VisitLocalDataSourceImpl({required this.visitBox});

  @override
  Future<List<VisitModel>> getVisits() async {
    try {
      return visitBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to fetch visits from cache: $e');
    }
  }

  @override
  Future<void> cacheVisits(List<VisitModel> visits) async {
    try {
      await visitBox.clear();
      await visitBox.addAll(visits);
    } catch (e) {
      throw CacheException('Failed to cache visits: $e');
    }
  }

  @override
  Future<void> cacheVisit(VisitModel visit) async {
    try {
      await visitBox.put(visit.id, visit);
    } catch (e) {
      throw CacheException('Failed to cache visit: $e');
    }
  }

  @override
  Future<void> deleteVisit(int id) async {
    try {
      await visitBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete visit from cache: $e');
    }
  }
}