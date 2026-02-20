import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_page.dart';
import '../features/trade/presentation/pages/trade_entry_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: '/trade/new',
      builder: (_, __) => const TradeEntryPage(),
    ),
  ],
);
