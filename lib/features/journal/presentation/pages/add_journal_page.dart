import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/journal.dart';
import '../controllers/add_journal_controller.dart';
import '../extensions/journal_ui_extensions.dart';

class AddJournalPage extends ConsumerStatefulWidget {
  const AddJournalPage({super.key});

  @override
  ConsumerState<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends ConsumerState<AddJournalPage> {
  final _formKey = GlobalKey<FormState>();
  final _pairController = TextEditingController();
  final _entryController = TextEditingController();
  final _exitController = TextEditingController();
  final _rrController = TextEditingController();
  final _lotSizeController = TextEditingController();
  TradeType _tradeType = TradeType.buy;
  TradeEmotion _emotionBefore = TradeEmotion.calm;
  TradeEmotion _emotionAfter = TradeEmotion.calm;

  @override
  void dispose() {
    _pairController.dispose();
    _entryController.dispose();
    _exitController.dispose();
    _rrController.dispose();
    _lotSizeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await ref.read(addJournalControllerProvider.notifier).submit(
      pair: _pairController.text.trim(),
      tradeType: _tradeType,
      entryPrice: double.parse(_entryController.text),
      exitPrice: double.parse(_exitController.text),
      riskRewardRatio: double.parse(_rrController.text),
      emotionBeforeTrade: _emotionBefore,
      emotionAfterTrade: _emotionAfter,
      date: DateTime.now(),
      lotSize: _lotSizeController.text.isEmpty ? null : double.parse(_lotSizeController.text),
    );

    if (result && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addJournalControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Journal')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _pairController,
              decoration: const InputDecoration(labelText: 'Pair (e.g. BTC/USDT)'),
              validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
            ),
            DropdownButtonFormField(
              value: _tradeType,
              decoration: const InputDecoration(labelText: 'Trade Type'),
              items: TradeType.values
                  .map((item) => DropdownMenuItem(value: item, child: Text(item.label)))
                  .toList(),
              onChanged: (value) => setState(() => _tradeType = value!),
            ),
            TextFormField(
              controller: _entryController,
              decoration: const InputDecoration(labelText: 'Entry Price'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid number' : null,
            ),
            TextFormField(
              controller: _exitController,
              decoration: const InputDecoration(labelText: 'Exit Price'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid number' : null,
            ),
            TextFormField(
              controller: _rrController,
              decoration: const InputDecoration(labelText: 'Risk/Reward Ratio'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid number' : null,
            ),
            TextFormField(
              controller: _lotSizeController,
              decoration: const InputDecoration(labelText: 'Lot Size (optional)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            DropdownButtonFormField(
              value: _emotionBefore,
              decoration: const InputDecoration(labelText: 'Emotion Before'),
              items: TradeEmotion.values
                  .map((item) => DropdownMenuItem(value: item, child: Text(item.label)))
                  .toList(),
              onChanged: (value) => setState(() => _emotionBefore = value!),
            ),
            DropdownButtonFormField(
              value: _emotionAfter,
              decoration: const InputDecoration(labelText: 'Emotion After'),
              items: TradeEmotion.values
                  .map((item) => DropdownMenuItem(value: item, child: Text(item.label)))
                  .toList(),
              onChanged: (value) => setState(() => _emotionAfter = value!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: state.isSubmitting ? null : _submit,
              child: state.isSubmitting
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Save'),
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
