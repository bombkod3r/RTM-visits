import 'package:dio/dio.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/features/customers/data/models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers();
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final Dio dio;

  CustomerRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CustomerModel>> getCustomers() async {
    try {
      final response = await dio.get('/customers?select=*');
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => CustomerModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch customers: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }
}