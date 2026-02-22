import '../domain/models/home_dashboard_model.dart';
import '../domain/models/journal_model.dart';

abstract interface class HomeRepository {
  const HomeRepository();

  HomeDashboardModel getDashboard();
}

final class MockHomeRepository implements HomeRepository {
  const MockHomeRepository();

  @override
  HomeDashboardModel getDashboard() {
    return const HomeDashboardModel(
      totalTrades: 148,
      winRate: 62.4,
      netProfit: 4870.50,
      journals: _mockJournals,
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
    emotionBeforeTrade: TradeEmotion.calm,
    emotionAfterTrade: TradeEmotion.calm,
    profitLoss: 510.32,
  ),
  JournalModel(
    pair: 'ETH/USDT',
    tradeType: TradeType.sell,
    entryPrice: 3220,
    exitPrice: 3306.50,
    date: DateTime(2026, 1, 10),
    riskRewardRatio: 1.8,
    emotionBeforeTrade: TradeEmotion.fear,
    emotionAfterTrade: TradeEmotion.fear,
    profitLoss: -220.15,
  ),
  JournalModel(
    pair: 'SOL/USDT',
    tradeType: TradeType.buy,
    entryPrice: 138.20,
    exitPrice: 146.30,
    date: DateTime(2026, 1, 8),
    riskRewardRatio: 3.1,
    emotionBeforeTrade: TradeEmotion.confident,
    emotionAfterTrade: TradeEmotion.greedy,
    profitLoss: 305.75,
  ),
];
