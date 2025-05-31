import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtm_visits/features/activities/presentation/bloc/activity_bloc.dart';
import 'package:rtm_visits/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/presentation/bloc/visit_bloc.dart';

class VisitFormScreen extends StatefulWidget {
  final Visit? visit;

  const VisitFormScreen({super.key, this.visit});

  @override
  State<VisitFormScreen> createState() => _VisitFormScreenState();
}

class _VisitFormScreenState extends State<VisitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late DateTime _visitDate;
  late String _status;
  late int _customerId;
  late List<String> _selectedActivities;
  
  // Status options with corresponding colors and icons
  final Map<String, Map<String, dynamic>> _statusOptions = {
    'Pending': {
      'color': Colors.orange,
      'icon': Icons.pending,
    },
    'Completed': {
      'color': Colors.green,
      'icon': Icons.check_circle,
    },
    'Cancelled': {
      'color': Colors.red,
      'icon': Icons.cancel,
    },
  };

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.visit?.location ?? '');
    _notesController = TextEditingController(text: widget.visit?.notes ?? '');
    _visitDate = widget.visit?.visitDate ?? DateTime.now();
    _status = widget.visit?.status ?? 'Pending';
    _customerId = widget.visit?.customerId ?? 0;
    _selectedActivities = widget.visit?.activitiesDone ?? [];
    context.read<CustomerBloc>().add(FetchCustomers());
    context.read<ActivityBloc>().add(FetchActivities());
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final visit = Visit(
        id: widget.visit?.id ?? DateTime.now().millisecondsSinceEpoch,
        customerId: _customerId,
        visitDate: _visitDate,
        status: _status,
        location: _locationController.text,
        notes: _notesController.text,
        activitiesDone: _selectedActivities,
        createdAt: widget.visit?.createdAt ?? DateTime.now(),
      );
      if (widget.visit == null) {
        context.read<VisitBloc>().add(AddVisitEvent(visit));
      } else {
        context.read<VisitBloc>().add(UpdateVisitEvent(visit));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          widget.visit == null ? 'Add Visit' : 'Edit Visit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Customer Selection Card
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 16),
                      BlocBuilder<CustomerBloc, CustomerState>(
                        builder: (context, state) {
                          final customers = state.customers ?? [];
                          return DropdownButtonFormField<int>(
                            value: _customerId == 0 ? null : _customerId,
                            decoration: InputDecoration(
                              labelText: 'Select Customer',
                              prefixIcon: Icon(Icons.person, color: Colors.blue),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                            items: customers.map((customer) {
                              return DropdownMenuItem(
                                value: customer.id,
                                child: Text(customer.name),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _customerId = value!),
                            validator: (value) => value == null ? 'Please select a customer' : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Visit Details Card
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visit Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Location field
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Notes field
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          hintText: 'Add any additional details...',
                          prefixIcon: Icon(Icons.note, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Visit date picker
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _visitDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_visitDate),
                            );
                            if (time != null) {
                              setState(() {
                                _visitDate = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.blue),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Visit Date & Time',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMd().add_jm().format(_visitDate),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Status selection
                      DropdownButtonFormField<String>(
                        value: _status,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(
                            _statusOptions[_status]?['icon'] ?? Icons.help,
                            color: _statusOptions[_status]?['color'] ?? Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        items: _statusOptions.keys.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Row(
                              children: [
                                Icon(
                                  _statusOptions[status]!['icon'],
                                  color: _statusOptions[status]!['color'],
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(status),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _status = value!),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Activities Card
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activities',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: BlocBuilder<ActivityBloc, ActivityState>(
                              builder: (context, state) {
                                final activities = state.activities ?? [];
                                return Text(
                                  '${_selectedActivities.length}/${activities.length}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),
                      
                      BlocBuilder<ActivityBloc, ActivityState>(
                        builder: (context, state) {
                          final activities = state.activities ?? [];
                          if (activities.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: Colors.orange,
                                      size: 48,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'No activities available',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          return Column(
                            children: [
                              // Select All / Clear All button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_selectedActivities.length == activities.length) {
                                          _selectedActivities.clear();
                                        } else {
                                          _selectedActivities = activities
                                              .map((a) => a.id.toString())
                                              .toList();
                                        }
                                      });
                                    },
                                    child: Text(
                                      _selectedActivities.length == activities.length
                                          ? 'Clear All'
                                          : 'Select All',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Activity list
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: activities.length,
                                itemBuilder: (context, index) {
                                  final activity = activities[index];
                                  final isSelected = _selectedActivities.contains(activity.id.toString());
                                  
                                  return CheckboxListTile(
                                    title: Text(activity.description),
                                    value: isSelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          _selectedActivities.add(activity.id.toString());
                                        } else {
                                          _selectedActivities.remove(activity.id.toString());
                                        }
                                      });
                                    },
                                    secondary: CircleAvatar(
                                      backgroundColor: Colors.blue[100],
                                      foregroundColor: Colors.blue,
                                      radius: 16,
                                      child: Text('${index + 1}'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.visit == null ? Icons.add : Icons.save),
                      SizedBox(width: 8),
                      Text(
                        widget.visit == null ? 'Add Visit' : 'Update Visit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}