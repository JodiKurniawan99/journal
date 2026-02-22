import '../../domain/entities/journal.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_local_datasource.dart';
import '../models/journal_hive_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  const JournalRepositoryImpl(this._localDataSource);

  final JournalLocalDataSource _localDataSource;

  @override
  Future<void> addJournal(Journal journal) {
    return _localDataSource.addJournal(JournalHiveModel.fromEntity(journal));
  }

  @override
  Future<List<Journal>> getJournals() async {
    final rows = await _localDataSource.getJournals();
    return rows.map((row) => row.toEntity()).toList(growable: false);
  }
}
