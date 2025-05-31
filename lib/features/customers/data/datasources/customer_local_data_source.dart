import 'package:hive/hive.dart';
import 'package:rtm_visits/core/error/exceptions.dart';
import 'package:rtm_visits/features/customers/data/models/customer_model.dart';

abstract class CustomerLocalDataSource {
  Future<List<CustomerModel>> getCustomers();
  Future<void> cacheCustomers(List<CustomerModel> customers);
}

class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  final Box<CustomerModel> customerBox;

  CustomerLocalDataSourceImpl({required this.customerBox});

  @override
  Future<List<CustomerModel>> getCustomers() async {
    try {
      return customerBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to fetch customers from cache: $e');
    }
  }

  @override
  Future<void> cacheCustomers(List<CustomerModel> customers) async {
    try {
      await customerBox.clear();
      await customerBox.addAll(customers);
    } catch (e) {
      throw CacheException('Failed to cache customers: $e');
    }
  }
}