enum TradeType { buy, sell }

enum TradeEmotion { confident, fear, greedy, calm }

class Journal {
  const Journal({
    required this.id,
    required this.pair,
    required this.tradeType,
    required this.entryPrice,
    required this.exitPrice,
    required this.date,
    required this.riskRewardRatio,
    required this.emotionBeforeTrade,
    required this.emotionAfterTrade,
    required this.profitLoss,
    this.lotSize,
  });

  final String id;
  final String pair;
  final TradeType tradeType;
  final double entryPrice;
  final double exitPrice;
  final DateTime date;
  final double riskRewardRatio;
  final double? lotSize;
  final TradeEmotion emotionBeforeTrade;
  final TradeEmotion emotionAfterTrade;
  final double profitLoss;

  bool get isProfit => profitLoss >= 0;
}
