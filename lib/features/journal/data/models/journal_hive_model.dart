import 'package:hive/hive.dart';

import '../../domain/entities/journal.dart';

class JournalHiveModel {
  JournalHiveModel({
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
  final String tradeType;
  final double entryPrice;
  final double exitPrice;
  final DateTime date;
  final double riskRewardRatio;
  final double? lotSize;
  final String emotionBeforeTrade;
  final String emotionAfterTrade;
  final double profitLoss;

  Journal toEntity() {
    return Journal(
      id: id,
      pair: pair,
      tradeType: TradeType.values.firstWhere((value) => value.name == tradeType),
      entryPrice: entryPrice,
      exitPrice: exitPrice,
      date: date,
      riskRewardRatio: riskRewardRatio,
      lotSize: lotSize,
      emotionBeforeTrade: TradeEmotion.values.firstWhere((value) => value.name == emotionBeforeTrade),
      emotionAfterTrade: TradeEmotion.values.firstWhere((value) => value.name == emotionAfterTrade),
      profitLoss: profitLoss,
    );
  }

  factory JournalHiveModel.fromEntity(Journal entity) {
    return JournalHiveModel(
      id: entity.id,
      pair: entity.pair,
      tradeType: entity.tradeType.name,
      entryPrice: entity.entryPrice,
      exitPrice: entity.exitPrice,
      date: entity.date,
      riskRewardRatio: entity.riskRewardRatio,
      lotSize: entity.lotSize,
      emotionBeforeTrade: entity.emotionBeforeTrade.name,
      emotionAfterTrade: entity.emotionAfterTrade.name,
      profitLoss: entity.profitLoss,
    );
  }
}

class JournalHiveModelAdapter extends TypeAdapter<JournalHiveModel> {
  @override
  final int typeId = 1;

  @override
  JournalHiveModel read(BinaryReader reader) {
    final itemCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var index = 0; index < itemCount; index++) reader.readByte(): reader.read(),
    };

    return JournalHiveModel(
      id: fields[0] as String,
      pair: fields[1] as String,
      tradeType: fields[2] as String,
      entryPrice: fields[3] as double,
      exitPrice: fields[4] as double,
      date: fields[5] as DateTime,
      riskRewardRatio: fields[6] as double,
      lotSize: fields[7] as double?,
      emotionBeforeTrade: fields[8] as String,
      emotionAfterTrade: fields[9] as String,
      profitLoss: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, JournalHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pair)
      ..writeByte(2)
      ..write(obj.tradeType)
      ..writeByte(3)
      ..write(obj.entryPrice)
      ..writeByte(4)
      ..write(obj.exitPrice)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.riskRewardRatio)
      ..writeByte(7)
      ..write(obj.lotSize)
      ..writeByte(8)
      ..write(obj.emotionBeforeTrade)
      ..writeByte(9)
      ..write(obj.emotionAfterTrade)
      ..writeByte(10)
      ..write(obj.profitLoss);
  }
}
