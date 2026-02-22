import 'journal.dart';

class HomeDashboard {
  const HomeDashboard({
    required this.totalTrades,
    required this.winRate,
    required this.netProfit,
    required this.journals,
  });

  final int totalTrades;
  final double winRate;
  final double netProfit;
  final List<Journal> journals;
}
