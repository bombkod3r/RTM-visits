import 'package:hive/hive.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';

part 'visit_model.g.dart';

@HiveType(typeId: 1)
class VisitModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int customerId;
  @HiveField(2)
  final String visitDate;
  @HiveField(3)
  final String status;
  @HiveField(4)
  final String location;
  @HiveField(5)
  final String notes;
  @HiveField(6)
  final List<String> activitiesDone;
  @HiveField(7)
  final String createdAt;

  VisitModel({
    required this.id,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
    required this.createdAt,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      customerId: json['customer_id'],
      visitDate: json['visit_date'],
      status: json['status'],
      location: json['location'],
      notes: json['notes'],
      activitiesDone: List<String>.from(json['activities_done'] ?? []),
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'visit_date': visitDate,
      'status': status,
      'location': location,
      'notes': notes,
      'activities_done': activitiesDone,
    };
  }

  Visit toEntity() {
    return Visit(
      id: id,
      customerId: customerId,
      visitDate: DateTime.parse(visitDate),
      status: status,
      location: location,
      notes: notes,
      activitiesDone: activitiesDone,
      createdAt: DateTime.parse(createdAt),
    );
  }

  factory VisitModel.fromEntity(Visit visit) {
    return VisitModel(
      id: visit.id,
      customerId: visit.customerId,
      visitDate: visit.visitDate.toIso8601String(),
      status: visit.status,
      location: visit.location,
      notes: visit.notes,
      activitiesDone: visit.activitiesDone,
      createdAt: visit.createdAt.toIso8601String(),
    );
  }
}