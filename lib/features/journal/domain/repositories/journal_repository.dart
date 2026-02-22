import '../entities/journal.dart';

abstract interface class JournalRepository {
  Future<List<Journal>> getJournals();

  Future<void> addJournal(Journal journal);
}
