import 'emotion_data.dart';

class Trade {
  Trade({
    required this.id,
    required this.date,
    required this.asset,
    required this.marketType,
    required this.direction,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,
    required this.exitPrice,
    required this.positionSize,
    required this.riskAmount,
    required this.result,
    required this.rrRatio,
    required this.pnl,
    required this.note,
    required this.screenshotPaths,
    required this.emotion,
    required this.pnlPercent,
    required this.riskedCapitalPercent,
  });

  final String id;
  final DateTime date;
  final String asset;
  final String marketType;
  final String direction;
  final double entryPrice;
  final double stopLoss;
  final double takeProfit;
  final double exitPrice;
  final double positionSize;
  final double riskAmount;
  final String result;
  final double rrRatio;
  final double pnl;
  final String note;
  final List<String> screenshotPaths;
  final EmotionData emotion;
  final double pnlPercent;
  final double riskedCapitalPercent;
}
