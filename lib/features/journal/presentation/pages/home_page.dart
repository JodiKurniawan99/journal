import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/home_dashboard_controller.dart';
import '../widgets/journal_card.dart';
import '../widgets/stats_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(homeDashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trading Journal')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-journal'),
        label: const Text('New Trade'),
        icon: const Icon(Icons.add),
      ),
      body: dashboardAsync.when(
        data: (dashboard) => RefreshIndicator(
          onRefresh: () => ref.read(homeDashboardControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  StatsCard(title: 'Trades', value: '${dashboard.totalTrades}'),
                  StatsCard(title: 'Win Rate', value: '${dashboard.winRate.toStringAsFixed(1)}%'),
                  StatsCard(title: 'Net P/L', value: dashboard.netProfit.toStringAsFixed(2)),
                ],
              ),
              const SizedBox(height: 16),
              ...dashboard.journals.map((journal) => JournalCard(journal: journal)),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
