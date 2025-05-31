import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtm_visits/features/activities/domain/entities/activity.dart';
import 'package:rtm_visits/features/activities/presentation/bloc/activity_bloc.dart';
import 'package:rtm_visits/features/customers/domain/entities/customer.dart';
import 'package:rtm_visits/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/presentation/bloc/visit_bloc.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color darkBlue = Color(0xFF1E40AF);
  static const Color blueGray = Color(0xFF64748B);
  static const Color lightGray = Color(0xFFF8FAFC);
  static const Color gray = Color(0xFFE2E8F0);
  static const Color black = Color(0xFF1F2937);
  static const Color green = Color(0xFF10B981);
  static const Color red = Color(0xFFEF4444);
  static const Color orange = Color(0xFFF59E0B);
}

class VisitDetailsScreen extends StatelessWidget {
  final Visit visit;

  const VisitDetailsScreen({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _buildAppBar(context),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, customerState) {
          final customer = customerState.customers?.firstWhere(
            (c) => c.id == visit.customerId,
            orElse: () => Customer(id: 0, name: 'Unknown', createdAt: DateTime.now()),
          );
          
          return BlocBuilder<ActivityBloc, ActivityState>(
            builder: (context, activityState) {
              final activities = activityState.activities ?? [];
              
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomerCard(customer),
                    SizedBox(height: 16),
                    _buildVisitInfoCard(),
                    SizedBox(height: 16),
                    _buildNotesCard(),
                    SizedBox(height: 16),
                    _buildActivitiesCard(activities),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Visit Details',
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.blue,
      foregroundColor: AppColors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.pushNamed(context, '/visit_form', arguments: visit),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  Widget _buildCustomerCard(Customer? customer) {
    final visitDate = DateFormat('MMM dd, yyyy - hh:mm a').format(visit.visitDate);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.blue,
              child: Text(
                customer?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer?.name ?? 'Unknown Customer',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: AppColors.blueGray),
                      SizedBox(width: 4),
                      Text(
                        visitDate,
                        style: TextStyle(
                          color: AppColors.blueGray,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.blue),
                SizedBox(width: 8),
                Text(
                  'Visit Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow('Status', visit.status, _getStatusColor(visit.status)),
            SizedBox(height: 12),
            _buildInfoRow('Location', visit.location, AppColors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color statusColor) {
    return Row(
      children: [
        Container(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.blueGray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(': ', style: TextStyle(color: AppColors.blueGray)),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note_alt_outlined, color: AppColors.blue),
                SizedBox(width: 8),
                Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: visit.notes.isEmpty ? AppColors.gray.withOpacity(0.3) : AppColors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: visit.notes.isEmpty ? AppColors.gray : AppColors.blue.withOpacity(0.3),
                ),
              ),
              child: Text(
                visit.notes.isEmpty ? 'No notes available' : visit.notes,
                style: TextStyle(
                  color: visit.notes.isEmpty ? AppColors.blueGray : AppColors.black,
                  fontSize: 14,
                  fontStyle: visit.notes.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesCard(List<Activity> activities) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.task_alt, color: AppColors.blue),
                SizedBox(width: 8),
                Text(
                  'Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (visit.activitiesDone.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      color: AppColors.blueGray,
                      size: 48,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No activities completed',
                      style: TextStyle(
                        color: AppColors.blueGray,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...visit.activitiesDone.asMap().entries.map((entry) {
                final index = entry.key;
                final activityId = entry.value;
                final activity = activities.firstWhere(
                  (a) => a.id.toString() == activityId,
                  orElse: () => Activity(id: 0, description: 'Unknown Activity', createdAt: DateTime.now()),
                );
                
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.green,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          activity.description,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: AppColors.green,
                        size: 20,
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.green;
      case 'pending':
        return AppColors.orange;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.blue;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.red),
            SizedBox(width: 8),
            Text('Delete Visit?'),
          ],
        ),
        content: Text('This action cannot be undone. All visit data will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.blueGray),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<VisitBloc>().add(DeleteVisitEvent(visit.id));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}