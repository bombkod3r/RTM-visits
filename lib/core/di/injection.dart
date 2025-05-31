import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:rtm_visits/core/network/dio_client.dart';
import 'package:rtm_visits/features/activities/data/datasources/activity_local_data_source.dart';
import 'package:rtm_visits/features/activities/data/datasources/activity_remote_data_source.dart';
import 'package:rtm_visits/features/activities/data/models/activity_model.dart';
import 'package:rtm_visits/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:rtm_visits/features/activities/domain/repositories/activity_repository.dart';
import 'package:rtm_visits/features/activities/domain/usecases/get_activities.dart';
import 'package:rtm_visits/features/activities/presentation/bloc/activity_bloc.dart';
import 'package:rtm_visits/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:rtm_visits/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:rtm_visits/features/customers/data/models/customer_model.dart';
import 'package:rtm_visits/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:rtm_visits/features/customers/domain/repositories/customer_repository.dart';
import 'package:rtm_visits/features/customers/domain/usecases/get_customers.dart';
import 'package:rtm_visits/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visits/features/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:rtm_visits/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:rtm_visits/features/statistics/domain/usecases/get_statistics.dart';
import 'package:rtm_visits/features/statistics/presentation/bloc/statistics_bloc.dart';
import 'package:rtm_visits/features/visits/data/datasources/visit_local_data_source.dart';
import 'package:rtm_visits/features/visits/data/datasources/visit_remote_data_source.dart';
import 'package:rtm_visits/features/visits/data/models/visit_model.dart';
import 'package:rtm_visits/features/visits/data/repositories/visit_repository_impl.dart';
import 'package:rtm_visits/features/visits/domain/repositories/visit_repository.dart';
import 'package:rtm_visits/features/visits/domain/usecases/add_visit.dart';
import 'package:rtm_visits/features/visits/domain/usecases/delete_visit.dart';
import 'package:rtm_visits/features/visits/domain/usecases/get_visits.dart';
import 'package:rtm_visits/features/visits/domain/usecases/update_visit.dart';
import 'package:rtm_visits/features/visits/presentation/bloc/visit_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => DioClient.create());
  sl.registerLazySingleton(() => Connectivity());
  final visitBox = await Hive.openBox<VisitModel>('visits');
  sl.registerLazySingleton(() => visitBox);
  final customerBox = await Hive.openBox<CustomerModel>('customers');
  sl.registerLazySingleton(() => customerBox);
  final activityBox = await Hive.openBox<ActivityModel>('activities');
  sl.registerLazySingleton(() => activityBox);

  // Visits
  sl.registerLazySingleton<VisitRemoteDataSource>(() => VisitRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<VisitLocalDataSource>(() => VisitLocalDataSourceImpl(visitBox: sl()));
  sl.registerLazySingleton<VisitRepository>(() => VisitRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        connectivity: sl(),
      ));
  sl.registerLazySingleton(() => GetVisits(sl()));
  sl.registerLazySingleton(() => AddVisit(sl()));
  sl.registerLazySingleton(() => UpdateVisit(sl()));
  sl.registerLazySingleton(() => DeleteVisit(sl()));
  sl.registerFactory(() => VisitBloc(
        getVisits: sl(),
        addVisit: sl(),
        updateVisit: sl(),
        deleteVisit: sl(),
      ));

  // Customers
  sl.registerLazySingleton<CustomerRemoteDataSource>(() => CustomerRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<CustomerLocalDataSource>(() => CustomerLocalDataSourceImpl(customerBox: sl()));
  sl.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        connectivity: sl(),
      ));
  sl.registerLazySingleton(() => GetCustomers(sl()));
  sl.registerFactory(() => CustomerBloc(getCustomers: sl()));

  // Activities
  sl.registerLazySingleton<ActivityRemoteDataSource>(() => ActivityRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<ActivityLocalDataSource>(() => ActivityLocalDataSourceImpl(activityBox: sl()));
  sl.registerLazySingleton<ActivityRepository>(() => ActivityRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        connectivity: sl(),
      ));
  sl.registerLazySingleton(() => GetActivities(sl()));
  sl.registerFactory(() => ActivityBloc(getActivities: sl()));

  // Statistics
  sl.registerLazySingleton<StatisticsRepository>(() => StatisticsRepositoryImpl(visitRepository: sl()));
  sl.registerLazySingleton(() => GetStatistics(sl()));
  sl.registerFactory(() => StatisticsBloc(getStatistics: sl()));
}