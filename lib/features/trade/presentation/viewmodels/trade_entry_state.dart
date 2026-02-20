import '../../domain/services/trade_calculator.dart';

class TradeEntryState {
  const TradeEntryState({
    required this.selectedDate,
    required this.selectedMarket,
    required this.selectedDirection,
    required this.selectedResult,
    required this.screenshotPaths,
    required this.calculation,
  });

  factory TradeEntryState.initial() => TradeEntryState(
        selectedDate: DateTime.now(),
        selectedMarket: marketTypes.first,
        selectedDirection: directions.first,
        selectedResult: results.first,
        screenshotPaths: const [],
        calculation: const TradeCalculation(
          rrRatio: 0,
          pnlPercent: 0,
          pnlAmount: 0,
          riskedCapitalPercent: 0,
          derivedRiskAmount: 0,
        ),
      );

  final DateTime selectedDate;
  final String selectedMarket;
  final String selectedDirection;
  final String selectedResult;
  final List<String> screenshotPaths;
  final TradeCalculation calculation;

  TradeEntryState copyWith({
    DateTime? selectedDate,
    String? selectedMarket,
    String? selectedDirection,
    String? selectedResult,
    List<String>? screenshotPaths,
    TradeCalculation? calculation,
  }) {
    return TradeEntryState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      selectedDirection: selectedDirection ?? this.selectedDirection,
      selectedResult: selectedResult ?? this.selectedResult,
      screenshotPaths: screenshotPaths ?? this.screenshotPaths,
      calculation: calculation ?? this.calculation,
    );
  }
}

const marketTypes = ['Forex', 'Crypto', 'Stocks', 'Futures'];
const directions = ['Buy / Long', 'Sell / Short'];
const results = ['Win', 'Loss', 'Break-even'];
