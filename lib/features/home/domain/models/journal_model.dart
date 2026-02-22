import 'package:flutter/material.dart';

enum TradeType { buy, sell }

class JournalModel {
  const JournalModel({
    required this.pair,
    required this.tradeType,
    required this.entryPrice,
    required this.exitPrice,
    required this.date,
    required this.riskRewardRatio,
    required this.emotionEmoji,
    required this.profitLoss,
  });

  final String pair;
  final TradeType tradeType;
  final double entryPrice;
  final double exitPrice;
  final DateTime date;
  final double riskRewardRatio;
  final String emotionEmoji;
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
}
