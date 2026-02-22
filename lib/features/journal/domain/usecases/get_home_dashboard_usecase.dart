import '../entities/home_dashboard.dart';
import 'get_journals_usecase.dart';

class GetHomeDashboardUseCase {
  const GetHomeDashboardUseCase(this._getJournalsUseCase);

  final GetJournalsUseCase _getJournalsUseCase;

  Future<HomeDashboard> call() async {
    final journals = await _getJournalsUseCase();
    final totalTrades = journals.length;
    final totalWins = journals.where((item) => item.isProfit).length;
    final winRate = totalTrades == 0 ? 0.0 : (totalWins / totalTrades) * 100;
    final netProfit = journals.fold<double>(0, (sum, item) => sum + item.profitLoss);

    return HomeDashboard(
      totalTrades: totalTrades,
      winRate: winRate,
      netProfit: netProfit,
      journals: journals,
    );
  }
}
