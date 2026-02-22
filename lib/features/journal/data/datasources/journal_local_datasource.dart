import 'package:hive/hive.dart';

import '../models/journal_hive_model.dart';

class JournalLocalDataSource {
  const JournalLocalDataSource(this._box);

  final Box<JournalHiveModel> _box;

  Future<List<JournalHiveModel>> getJournals() async {
    final items = _box.values.toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<void> addJournal(JournalHiveModel model) async {
    await _box.put(model.id, model);
  }
}
