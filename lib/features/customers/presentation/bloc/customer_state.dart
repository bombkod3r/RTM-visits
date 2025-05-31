part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  List<Customer> get customers => [];

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> _customers;

  const CustomerLoaded(List<Customer> customers) : _customers = customers;

  @override
  List<Customer> get customers => _customers;

  @override
  List<Object> get props => [_customers];
}

class CustomerError extends CustomerState {
  final String message;

  const CustomerError({required this.message});

  @override
  List<Object> get props => [message];
}