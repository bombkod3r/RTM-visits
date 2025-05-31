import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:rtm_visits/core/di/injection.dart';
import 'package:rtm_visits/core/theme/app_theme.dart';
import 'package:rtm_visits/features/activities/data/models/activity_model.dart';
import 'package:rtm_visits/features/customers/data/models/customer_model.dart';
import 'package:rtm_visits/features/visits/data/models/visit_model.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/presentation/bloc/visit_bloc.dart';
import 'package:rtm_visits/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visits/features/activities/presentation/bloc/activity_bloc.dart';
import 'package:rtm_visits/features/statistics/presentation/bloc/statistics_bloc.dart';
import 'package:rtm_visits/features/visits/presentation/screens/visit_list_screen.dart';
import 'package:rtm_visits/features/visits/presentation/screens/visit_form_screen.dart';
import 'package:rtm_visits/features/visits/presentation/screens/visit_details_screen.dart';
import 'package:rtm_visits/features/statistics/presentation/screens/statistics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityModelAdapter());
  Hive.registerAdapter(CustomerModelAdapter());
  Hive.registerAdapter(VisitModelAdapter());

  // Initialize dependency injection
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const VisitListScreen(),
        ),
        GoRoute(
          path: '/visit_form',
          builder: (context, state) {
            final visit = state.extra as Visit?;
            return VisitFormScreen(visit: visit);
          },
        ),
        GoRoute(
          path: '/visit_details',
          builder: (context, state) {
            final visit = state.extra as Visit;
            return VisitDetailsScreen(visit: visit);
          },
        ),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<VisitBloc>()),
        BlocProvider(create: (context) => sl<CustomerBloc>()),
        BlocProvider(create: (context) => sl<ActivityBloc>()),
        BlocProvider(create: (context) => sl<StatisticsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'RTM Visit Tracker',
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}