import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/emotion_data.dart';
import '../../domain/entities/trade.dart';
import '../../domain/services/trade_calculator.dart';
import 'trade_entry_state.dart';

final tradeEntryViewModelProvider =
    StateNotifierProvider<TradeEntryViewModel, TradeEntryState>(
  (_) => TradeEntryViewModel(),
);

class TradeEntryViewModel extends StateNotifier<TradeEntryState> {
  TradeEntryViewModel() : super(TradeEntryState.initial());

  final _uuid = const Uuid();
  final _imagePicker = ImagePicker();

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateMarket(String market) {
    state = state.copyWith(selectedMarket: market);
  }

  void updateDirection(String direction) {
    state = state.copyWith(selectedDirection: direction);
  }

  void updateResult(String result) {
    state = state.copyWith(selectedResult: result);
  }

  void updateCalculation({
    required double entryPrice,
    required double stopLoss,
    required double exitPrice,
    required double positionSize,
    double? riskAmount,
  }) {
    final calculation = TradeCalculator.calculate(
      entryPrice: entryPrice,
      stopLoss: stopLoss,
      exitPrice: exitPrice,
      positionSize: positionSize,
      riskAmount: riskAmount,
    );
    state = state.copyWith(calculation: calculation);
  }

  Future<void> pickScreenshot() async {
    final selected = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (selected == null) {
      return;
    }

    state = state.copyWith(
      screenshotPaths: [...state.screenshotPaths, selected.path],
    );
  }

  Trade buildTrade({
    required String asset,
    required double entryPrice,
    required double stopLoss,
    required double takeProfit,
    required double exitPrice,
    required double positionSize,
    required double riskAmount,
    required String note,
  }) {
    final calculation = state.calculation;

    return Trade(
      id: _uuid.v4(),
      date: state.selectedDate,
      asset: asset,
      marketType: state.selectedMarket,
      direction: state.selectedDirection,
      entryPrice: entryPrice,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      exitPrice: exitPrice,
      positionSize: positionSize,
      riskAmount: riskAmount > 0 ? riskAmount : calculation.derivedRiskAmount,
      result: state.selectedResult,
      rrRatio: calculation.rrRatio,
      pnl: calculation.pnlAmount,
      note: note,
      screenshotPaths: state.screenshotPaths,
      emotion: const EmotionData(
        preTradeEmotion: 'Neutral',
        postTradeEmotion: 'Neutral',
      ),
      pnlPercent: calculation.pnlPercent,
      riskedCapitalPercent: calculation.riskedCapitalPercent,
    );
  }
}
