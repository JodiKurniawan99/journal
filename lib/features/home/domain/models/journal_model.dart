import 'package:flutter/material.dart';

enum TradeType { buy, sell }

enum TradeEmotion {
  confident('Confident', '😎'),
  fear('Fear', '😨'),
  greedy('Greedy', '🤑'),
  calm('Calm', '😌');

  const TradeEmotion(this.label, this.emoji);

  final String label;
  final String emoji;
}

class JournalModel {
  const JournalModel({
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

  String get formattedProfitLoss {
    final sign = isProfit ? '+' : '';
    return '$sign${profitLoss.toStringAsFixed(2)}';
  }

  String get tradeTypeLabel {
    switch (tradeType) {
      case TradeType.buy:
        return 'Buy';
      case TradeType.sell:
        return 'Sell';
    }
  }

  IconData get tradeTypeIcon {
    switch (tradeType) {
      case TradeType.buy:
        return Icons.arrow_upward_rounded;
      case TradeType.sell:
        return Icons.arrow_downward_rounded;
    }
  }

  String get emotionEmoji => emotionAfterTrade.emoji;
}
