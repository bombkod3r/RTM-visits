import 'package:hive/hive.dart';
import 'package:rtm_visits/features/customers/domain/entities/customer.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 2)
class CustomerModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
    };
  }

  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      createdAt: DateTime.parse(createdAt),
    );
  }
}