import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtm_visits/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/presentation/screens/visit_details_screen.dart';
import 'package:rtm_visits/features/visits/presentation/screens/visit_form_screen.dart';
import 'package:rtm_visits/features/visits/presentation/screens/visit_list_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

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

    return MaterialApp.router(
      routerConfig: router,
      theme: Theme.of(context),
      debugShowCheckedModeBanner: false,
    );
  }
}