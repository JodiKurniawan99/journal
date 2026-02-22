import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/journal.dart';
import '../providers/journal_providers.dart';
import 'home_dashboard_controller.dart';

class AddJournalState {
  const AddJournalState({this.isSubmitting = false, this.errorMessage});

  final bool isSubmitting;
  final String? errorMessage;

  AddJournalState copyWith({bool? isSubmitting, String? errorMessage}) {
    return AddJournalState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class AddJournalController extends Notifier<AddJournalState> {
  @override
  AddJournalState build() => const AddJournalState();

  Future<bool> submit({
    required String pair,
    required TradeType tradeType,
    required double entryPrice,
    required double exitPrice,
    required double riskRewardRatio,
    required TradeEmotion emotionBeforeTrade,
    required TradeEmotion emotionAfterTrade,
    required DateTime date,
    double? lotSize,
  }) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final calculatedProfitLoss = (exitPrice - entryPrice) * (lotSize ?? 1);
      final journal = Journal(
        id: '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9999)}',
        pair: pair,
        tradeType: tradeType,
        entryPrice: entryPrice,
        exitPrice: exitPrice,
        date: date,
        riskRewardRatio: riskRewardRatio,
        lotSize: lotSize,
        emotionBeforeTrade: emotionBeforeTrade,
        emotionAfterTrade: emotionAfterTrade,
        profitLoss: tradeType == TradeType.buy ? calculatedProfitLoss : -calculatedProfitLoss,
      );

      await ref.read(addJournalUseCaseProvider).call(journal);
      ref.invalidate(homeDashboardControllerProvider);
      state = const AddJournalState(isSubmitting: false);
      return true;
    } catch (_) {
      state = const AddJournalState(
        isSubmitting: false,
        errorMessage: 'Failed to save journal.',
      );
      return false;
    }
  }
}

final addJournalControllerProvider = NotifierProvider<AddJournalController, AddJournalState>(
  AddJournalController.new,
);
