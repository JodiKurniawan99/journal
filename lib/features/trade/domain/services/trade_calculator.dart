class TradeCalculation {
  const TradeCalculation({
    required this.rrRatio,
    required this.pnlPercent,
    required this.pnlAmount,
    required this.riskedCapitalPercent,
    required this.derivedRiskAmount,
  });

  final double rrRatio;
  final double pnlPercent;
  final double pnlAmount;
  final double riskedCapitalPercent;
  final double derivedRiskAmount;
}

class TradeCalculator {
  const TradeCalculator._();

  static TradeCalculation calculate({
    required double entryPrice,
    required double stopLoss,
    required double exitPrice,
    required double positionSize,
    double? riskAmount,
  }) {
    final priceRisk = (entryPrice - stopLoss).abs();
    final priceReward = (exitPrice - entryPrice).abs();
    final rrRatio = priceRisk == 0 ? 0 : priceReward / priceRisk;
    final pnlAmount = (exitPrice - entryPrice) * positionSize;
    final exposure = entryPrice * positionSize;
    final pnlPercent = exposure == 0 ? 0 : (pnlAmount / exposure) * 100;
    final derivedRiskAmount = priceRisk * positionSize;
    final usedRiskAmount = riskAmount == null || riskAmount <= 0
        ? derivedRiskAmount
        : riskAmount;
    final riskedCapitalPercent = exposure == 0 ? 0 : (usedRiskAmount / exposure) * 100;

    return TradeCalculation(
      rrRatio: rrRatio,
      pnlPercent: pnlPercent,
      pnlAmount: pnlAmount,
      riskedCapitalPercent: riskedCapitalPercent,
      derivedRiskAmount: derivedRiskAmount,
    );
  }
}
