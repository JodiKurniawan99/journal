import 'package:flutter/material.dart';

import '../data/home_repository.dart';
import '../domain/models/home_dashboard_model.dart';
import '../domain/models/journal_model.dart';
import '../../add_journal/add_journal_page.dart';
import 'extensions/home_context_extensions.dart';
import 'widgets/journal_card.dart';
import 'widgets/stats_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, HomeRepository repository = const MockHomeRepository()})
      : _repository = repository;

  final HomeRepository _repository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeDashboardModel _dashboard;
  late final List<JournalModel> _journals;

  @override
  void initState() {
    super.initState();
    _dashboard = widget._repository.getDashboard();
    _journals = List<JournalModel>.of(_dashboard.journals);
  }

  Future<void> _onNewTradePressed() async {
    final createdJournal = await Navigator.of(context).push<JournalModel>(
      PageRouteBuilder<JournalModel>(
        pageBuilder: (_, animation, __) {
          return FadeTransition(opacity: animation, child: const AddJournalPage());
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    if (createdJournal == null || !mounted) {
      return;
    }

    setState(() {
      _journals.insert(0, createdJournal);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trade saved successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const _HomeHeader(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              avatar: const Icon(Icons.trending_up_rounded, size: 16),
              label: Text('${_dashboard.winRate.toStringAsFixed(1)}%'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onNewTradePressed,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Trade'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              sliver: SliverToBoxAdapter(child: _StatsSection(dashboard: _dashboard)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Recent Journals',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (_journals.isEmpty)
              const SliverFillRemaining(hasScrollBody: false, child: _EmptyState())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == _journals.length - 1 ? 0 : 12,
                      ),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOut,
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(opacity: value, child: child);
                        },
                        child: JournalCard(
                          key: ValueKey(_journals[index].date),
                          journal: _journals[index],
                          onTap: () {},
                        ),
                      ),
                    );
                  }, childCount: _journals.length),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trading Journal'),
        SizedBox(height: 2),
        Text('Track. Improve. Win.', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.dashboard});

  final HomeDashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          StatsCard(
            icon: Icons.candlestick_chart_rounded,
            label: 'Total Trades',
            value: dashboard.totalTrades.toString(),
            gradient: LinearGradient(
              colors: [context.colorScheme.primary, context.colorScheme.primaryContainer],
            ),
          ),
          const SizedBox(width: 12),
          StatsCard(
            icon: Icons.emoji_events_rounded,
            label: 'Win Rate',
            value: '${dashboard.winRate.toStringAsFixed(1)}%',
            gradient: LinearGradient(
              colors: [context.colorScheme.tertiary, context.colorScheme.secondary],
            ),
          ),
          const SizedBox(width: 12),
          StatsCard(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Net Profit',
            value: dashboard.netProfit.asSignedCurrency,
            gradient: LinearGradient(
              colors: [context.colorScheme.secondary, context.colorScheme.secondaryContainer],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 54, color: context.colorScheme.primary),
            const SizedBox(height: 14),
            Text('No journals yet', style: context.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Tap "New Trade" to record your first setup.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
