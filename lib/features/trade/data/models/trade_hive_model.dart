import '../../domain/entities/emotion_data.dart';
import '../../domain/entities/trade.dart';

class TradeHiveModel {
  TradeHiveModel({
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
    required this.preTradeEmotion,
    required this.postTradeEmotion,
    required this.emotionTags,
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
  final String preTradeEmotion;
  final String postTradeEmotion;
  final List<String> emotionTags;
  final double pnlPercent;
  final double riskedCapitalPercent;

  Trade toEntity() {
    return Trade(
      id: id,
      date: date,
      asset: asset,
      marketType: marketType,
      direction: direction,
      entryPrice: entryPrice,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      exitPrice: exitPrice,
      positionSize: positionSize,
      riskAmount: riskAmount,
      result: result,
      rrRatio: rrRatio,
      pnl: pnl,
      note: note,
      screenshotPaths: screenshotPaths,
      emotion: EmotionData(
        preTradeEmotion: preTradeEmotion,
        postTradeEmotion: postTradeEmotion,
        tags: emotionTags,
      ),
      pnlPercent: pnlPercent,
      riskedCapitalPercent: riskedCapitalPercent,
    );
  }

  factory TradeHiveModel.fromEntity(Trade trade) {
    return TradeHiveModel(
      id: trade.id,
      date: trade.date,
      asset: trade.asset,
      marketType: trade.marketType,
      direction: trade.direction,
      entryPrice: trade.entryPrice,
      stopLoss: trade.stopLoss,
      takeProfit: trade.takeProfit,
      exitPrice: trade.exitPrice,
      positionSize: trade.positionSize,
      riskAmount: trade.riskAmount,
      result: trade.result,
      rrRatio: trade.rrRatio,
      pnl: trade.pnl,
      note: trade.note,
      screenshotPaths: trade.screenshotPaths,
      preTradeEmotion: trade.emotion.preTradeEmotion,
      postTradeEmotion: trade.emotion.postTradeEmotion,
      emotionTags: trade.emotion.tags,
      pnlPercent: trade.pnlPercent,
      riskedCapitalPercent: trade.riskedCapitalPercent,
    );
  }
}
