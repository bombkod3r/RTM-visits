import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtm_visits/features/customers/domain/entities/customer.dart';
import 'package:rtm_visits/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';

class VisitCard extends StatelessWidget {
  final Visit visit;

  const VisitCard({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        final customer = state.customers?.firstWhere(
          (c) => c.id == visit.customerId,
          orElse: () => Customer(id: 0, name: 'Unknown', createdAt: DateTime.now()),
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              customer?.name ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${DateFormat.yMd().format(visit.visitDate)} - ${visit.status}'),
           
            onTap: () => context.push('/visit_details', extra: visit),
          ),
        );
      },
    );
  }
}
