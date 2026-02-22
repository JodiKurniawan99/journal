import 'journal_model.dart';

class HomeDashboardModel {
  const HomeDashboardModel({
    required this.totalTrades,
    required this.winRate,
    required this.netProfit,
    required this.journals,
  });

  final int totalTrades;
  final double winRate;
  final double netProfit;
  final List<JournalModel> journals;
}
