import 'package:flutter/material.dart';

import '../domain/models/journal_model.dart';
import 'widgets/journal_card.dart';
import 'widgets/stats_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journals = _mockJournals;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trading Journal'),
            SizedBox(height: 2),
            Text('Track. Improve. Win.', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Chip(
              avatar: Icon(Icons.trending_up_rounded, size: 16),
              label: Text('+12.5%'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const AddJournalPage()),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Trade'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 124,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatsCard(
                        icon: Icons.candlestick_chart_rounded,
                        label: 'Total Trades',
                        value: '148',
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.primaryContainer],
                        ),
                      ),
                      const SizedBox(width: 12),
                      StatsCard(
                        icon: Icons.emoji_events_rounded,
                        label: 'Win Rate',
                        value: '62.4%',
                        gradient: LinearGradient(
                          colors: [colorScheme.tertiary, colorScheme.secondary],
                        ),
                      ),
                      const SizedBox(width: 12),
                      StatsCard(
                        icon: Icons.account_balance_wallet_rounded,
                        label: 'Net Profit',
                        value: '+4,870.50',
                        gradient: LinearGradient(
                          colors: [colorScheme.secondary, colorScheme.secondaryContainer],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Recent Journals',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (journals.isEmpty)
              const SliverFillRemaining(hasScrollBody: false, child: _EmptyState())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: journals.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: JournalCard(journal: journals[index], onTap: () {}),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 54, color: colorScheme.primary),
            const SizedBox(height: 14),
            Text('No journals yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Tap "New Trade" to record your first setup.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class AddJournalPage extends StatelessWidget {
  const AddJournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Trade Journal')),
      body: const Center(child: Text('AddJournalPage')),
    );
  }
}

const List<JournalModel> _mockJournals = [
  JournalModel(
    pair: 'BTC/USDT',
    tradeType: TradeType.buy,
    entryPrice: 64120.50,
    exitPrice: 65380.20,
    date: DateTime(2026, 1, 12),
    riskRewardRatio: 2.4,
    emotionEmoji: '😌',
    profitLoss: 510.32,
  ),
  JournalModel(
    pair: 'ETH/USDT',
    tradeType: TradeType.sell,
    entryPrice: 3220,
    exitPrice: 3306.50,
    date: DateTime(2026, 1, 10),
    riskRewardRatio: 1.8,
    emotionEmoji: '😬',
    profitLoss: -220.15,
  ),
  JournalModel(
    pair: 'SOL/USDT',
    tradeType: TradeType.buy,
    entryPrice: 138.20,
    exitPrice: 146.30,
    date: DateTime(2026, 1, 8),
    riskRewardRatio: 3.1,
    emotionEmoji: '🔥',
    profitLoss: 305.75,
  ),
];
