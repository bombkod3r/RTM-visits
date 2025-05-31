import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rtm_visits/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visits/features/visits/domain/entities/visit.dart';
import 'package:rtm_visits/features/visits/presentation/bloc/visit_bloc.dart';
import 'package:rtm_visits/features/visits/presentation/screens/visit_form_screen.dart';
import 'package:rtm_visits/features/visits/presentation/screens/visit_list_screen.dart';

import 'visit_list_screen_test.mocks.dart';

@GenerateMocks([VisitBloc, CustomerBloc])
void main() {
  late MockVisitBloc mockVisitBloc;
  late MockCustomerBloc mockCustomerBloc;

  setUp(() {
    mockVisitBloc = MockVisitBloc();
    mockCustomerBloc = MockCustomerBloc();
  });

  final tVisit = Visit(
    id: 1,
    customerId: 1,
    visitDate: DateTime.now(),
    status: 'Completed',
    location: '123 Main St',
    notes: 'Test visit',
    activitiesDone: ['1'],
    createdAt: DateTime.now(),
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<VisitBloc>.value(value: mockVisitBloc),
          BlocProvider<CustomerBloc>.value(value: mockCustomerBloc),
        ],
        child: const VisitListScreen(),
      ),
    );
  }

  testWidgets('displays loading skeleton when VisitBloc is loading', (WidgetTester tester) async {
    // arrange
    when(mockVisitBloc.state).thenReturn(VisitLoading());
    when(mockCustomerBloc.state).thenReturn(const CustomerLoaded([]));

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // assert
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('displays visits when VisitBloc is loaded', (WidgetTester tester) async {
    // arrange
    when(mockVisitBloc.state).thenReturn(VisitLoaded([tVisit]));
    when(mockCustomerBloc.state).thenReturn(const CustomerLoaded([]));

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // assert
    expect(find.text('Unknown'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('displays error message when VisitBloc has error', (WidgetTester tester) async {
    // arrange
    when(mockVisitBloc.state).thenReturn(const VisitError('Failed to load visits'));
    when(mockCustomerBloc.state).thenReturn(const CustomerLoaded([]));

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // assert
    expect(find.text('Failed to load visits'), findsOneWidget);
  });

  testWidgets('navigates to visit form when add button is tapped', (WidgetTester tester) async {
    // arrange
    when(mockVisitBloc.state).thenReturn(const VisitLoaded([]));
    when(mockCustomerBloc.state).thenReturn(const CustomerLoaded([]));

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(VisitFormScreen), findsOneWidget);
  });
}