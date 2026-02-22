import 'package:flutter/material.dart';

import '../../domain/entities/journal.dart';
import '../extensions/journal_ui_extensions.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({super.key, required this.journal});

  final Journal journal;

  @override
  Widget build(BuildContext context) {
    final pnlColor = journal.isProfit ? Colors.green : Colors.red;
    return Card(
      child: ListTile(
        title: Text(journal.pair),
        subtitle: Text('${journal.tradeType.label} • ${journal.emotionAfterTrade.emoji}'),
        leading: Icon(journal.tradeType.icon),
        trailing: Text(
          '${journal.isProfit ? '+' : ''}${journal.profitLoss.toStringAsFixed(2)}',
          style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
