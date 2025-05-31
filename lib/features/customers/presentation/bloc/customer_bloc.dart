import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtm_visits/features/customers/domain/entities/customer.dart';
import 'package:rtm_visits/features/customers/domain/usecases/get_customers.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomers getCustomers;

  CustomerBloc({required this.getCustomers}) : super(CustomerInitial()) {
    on<FetchCustomers>((event, emit) async {
      emit(CustomerLoading());
      final result = await getCustomers();
      result.fold(
        (failure) => emit(CustomerError(message: failure.message)),
        (customers) => emit(CustomerLoaded(customers)),
      );
    });
  }
}