import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/journal_local_datasource.dart';
import '../../data/models/journal_hive_model.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../domain/usecases/add_journal_usecase.dart';
import '../../domain/usecases/get_home_dashboard_usecase.dart';
import '../../domain/usecases/get_journals_usecase.dart';

const journalBoxName = 'journals_box';

final journalBoxProvider = Provider<Box<JournalHiveModel>>((ref) {
  return Hive.box<JournalHiveModel>(journalBoxName);
});

final journalLocalDataSourceProvider = Provider<JournalLocalDataSource>((ref) {
  return JournalLocalDataSource(ref.watch(journalBoxProvider));
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepositoryImpl(ref.watch(journalLocalDataSourceProvider));
});

final getJournalsUseCaseProvider = Provider<GetJournalsUseCase>((ref) {
  return GetJournalsUseCase(ref.watch(journalRepositoryProvider));
});

final addJournalUseCaseProvider = Provider<AddJournalUseCase>((ref) {
  return AddJournalUseCase(ref.watch(journalRepositoryProvider));
});

final getHomeDashboardUseCaseProvider = Provider<GetHomeDashboardUseCase>((ref) {
  return GetHomeDashboardUseCase(ref.watch(getJournalsUseCaseProvider));
});
