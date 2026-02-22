import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class AddJournalUseCase {
  const AddJournalUseCase(this._repository);

  final JournalRepository _repository;

  Future<void> call(Journal journal) {
    return _repository.addJournal(journal);
  }
}
