import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class GetJournalsUseCase {
  const GetJournalsUseCase(this._repository);

  final JournalRepository _repository;

  Future<List<Journal>> call() {
    return _repository.getJournals();
  }
}
