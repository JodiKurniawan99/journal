import 'package:flutter/material.dart';

import '../../domain/entities/journal.dart';

extension TradeTypeUiX on TradeType {
  String get label => this == TradeType.buy ? 'Buy' : 'Sell';

  IconData get icon => this == TradeType.buy ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
}

extension TradeEmotionUiX on TradeEmotion {
  String get label {
    switch (this) {
      case TradeEmotion.confident:
        return 'Confident';
      case TradeEmotion.fear:
        return 'Fear';
      case TradeEmotion.greedy:
        return 'Greedy';
      case TradeEmotion.calm:
        return 'Calm';
    }
  }

  String get emoji {
    switch (this) {
      case TradeEmotion.confident:
        return '😎';
      case TradeEmotion.fear:
        return '😨';
      case TradeEmotion.greedy:
        return '🤑';
      case TradeEmotion.calm:
        return '😌';
    }
  }
}
