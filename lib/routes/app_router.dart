import 'package:go_router/go_router.dart';

import '../features/journal/presentation/pages/add_journal_page.dart';
import '../features/journal/presentation/pages/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: '/add-journal',
      builder: (_, __) => const AddJournalPage(),
    ),
  ],
);
