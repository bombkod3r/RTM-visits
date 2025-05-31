import 'package:equatable/equatable.dart';

class Statistics extends Equatable {
  final int totalVisits;
  final int completedVisits;
  final int pendingVisits;
  final int cancelledVisits;

  const Statistics({
    required this.totalVisits,
    required this.completedVisits,
    required this.pendingVisits,
    required this.cancelledVisits,
  });

  @override
  List<Object> get props => [totalVisits, completedVisits, pendingVisits, cancelledVisits];
}