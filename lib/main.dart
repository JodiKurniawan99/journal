import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'features/journal/data/models/journal_hive_model.dart';
import 'features/journal/presentation/providers/journal_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(JournalHiveModelAdapter());
  await Hive.openBox<JournalHiveModel>(journalBoxName);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
