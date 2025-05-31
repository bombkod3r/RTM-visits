import 'package:hive/hive.dart';
import 'package:rtm_visits/features/activities/domain/entities/activity.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 3)
class ActivityModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String createdAt;

  ActivityModel({
    required this.id,
    required this.description,
    required this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      description: json['description'],
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'created_at': createdAt,
    };
  }

  Activity toEntity() {
    return Activity(
      id: id,
      description: description,
      createdAt: DateTime.parse(createdAt),
    );
  }
}