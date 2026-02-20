import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../viewmodels/trade_entry_state.dart';
import '../viewmodels/trade_entry_view_model.dart';

class TradeEntryPage extends ConsumerStatefulWidget {
  const TradeEntryPage({super.key});

  @override
  ConsumerState<TradeEntryPage> createState() => _TradeEntryPageState();
}

class _TradeEntryPageState extends ConsumerState<TradeEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _assetController = TextEditingController();
  final _entryController = TextEditingController();
  final _stopLossController = TextEditingController();
  final _takeProfitController = TextEditingController();
  final _exitController = TextEditingController();
  final _positionSizeController = TextEditingController();
  final _riskAmountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _assetController.dispose();
    _entryController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _exitController.dispose();
    _positionSizeController.dispose();
    _riskAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tradeEntryViewModelProvider);
    final vm = ref.read(tradeEntryViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Manual Trade Entry')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Section(
                title: 'Trade Setup',
                child: Column(
                  children: [
                    _dateField(context, state.selectedDate),
                    const SizedBox(height: 12),
                    _textField(_assetController, 'Asset (BTCUSDT, AAPL)'),
                    const SizedBox(height: 12),
                    _dropdown(
                      value: state.selectedMarket,
                      label: 'Market Type',
                      options: marketTypes,
                      onChanged: vm.updateMarket,
                    ),
                    const SizedBox(height: 12),
                    _dropdown(
                      value: state.selectedDirection,
                      label: 'Direction',
                      options: directions,
                      onChanged: vm.updateDirection,
                    ),
                    const SizedBox(height: 12),
                    _numberField(_entryController, 'Entry Price'),
                    const SizedBox(height: 12),
                    _numberField(_stopLossController, 'Stop Loss'),
                    const SizedBox(height: 12),
                    _numberField(_takeProfitController, 'Take Profit'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Risk Management',
                child: Column(
                  children: [
                    _numberField(_positionSizeController, 'Position Size'),
                    const SizedBox(height: 12),
                    _numberField(
                      _riskAmountController,
                      'Risk Amount (optional)',
                      required: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Result',
                child: Column(
                  children: [
                    _numberField(_exitController, 'Exit Price'),
                    const SizedBox(height: 12),
                    _dropdown(
                      value: state.selectedResult,
                      label: 'Result',
                      options: results,
                      onChanged: vm.updateResult,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Notes',
                child: Column(
                  children: [
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Trade notes',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: vm.pickScreenshot,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Attach Screenshot'),
                      ),
                    ),
                    if (state.screenshotPaths.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${state.screenshotPaths.length} screenshot(s) selected',
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _CalculationCard(state: state),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _save(context),
                  child: const Text('Save Trade'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateField(BuildContext context, DateTime selectedDate) {
    final vm = ref.read(tradeEntryViewModelProvider.notifier);
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate == null || !context.mounted) {
          return;
        }

        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDate),
        );

        if (pickedTime == null) {
          return;
        }

        final combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        vm.updateDate(combined);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Date & Time',
        ),
        child: Text(DateFormat('yyyy-MM-dd HH:mm').format(selectedDate)),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      validator: (value) => (value == null || value.trim().isEmpty)
          ? '$label is required'
          : null,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      onChanged: (_) => _recalculate(),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label, {
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (!required && (value == null || value.trim().isEmpty)) {
          return null;
        }
        final parsed = double.tryParse(value ?? '');
        if (parsed == null) {
          return '$label must be a valid number';
        }
        return null;
      },
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      onChanged: (_) => _recalculate(),
    );
  }

  Widget _dropdown({
    required String value,
    required String label,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: options
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }

  void _recalculate() {
    final entry = double.tryParse(_entryController.text);
    final stop = double.tryParse(_stopLossController.text);
    final exit = double.tryParse(_exitController.text);
    final position = double.tryParse(_positionSizeController.text);
    final risk = double.tryParse(_riskAmountController.text);
    if (entry == null || stop == null || exit == null || position == null) {
      return;
    }

    ref.read(tradeEntryViewModelProvider.notifier).updateCalculation(
          entryPrice: entry,
          stopLoss: stop,
          exitPrice: exit,
          positionSize: position,
          riskAmount: risk,
        );
  }

  void _save(BuildContext context) {
    _recalculate();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final vm = ref.read(tradeEntryViewModelProvider.notifier);
    final trade = vm.buildTrade(
      asset: _assetController.text.trim(),
      entryPrice: double.parse(_entryController.text),
      stopLoss: double.parse(_stopLossController.text),
      takeProfit: double.parse(_takeProfitController.text),
      exitPrice: double.parse(_exitController.text),
      positionSize: double.parse(_positionSizeController.text),
      riskAmount: double.tryParse(_riskAmountController.text) ?? 0,
      note: _notesController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Trade saved with ID: ${trade.id}')),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _CalculationCard extends StatelessWidget {
  const _CalculationCard({required this.state});

  final TradeEntryState state;

  @override
  Widget build(BuildContext context) {
    final calc = state.calculation;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Real-time Calculation Preview',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('R:R Ratio: ${calc.rrRatio.toStringAsFixed(2)}'),
            Text('P/L %: ${calc.pnlPercent.toStringAsFixed(2)}%'),
            Text('P/L Amount: ${calc.pnlAmount.toStringAsFixed(2)}'),
            Text(
              'Risked Capital %: ${calc.riskedCapitalPercent.toStringAsFixed(2)}%',
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: BarChart(
                BarChartData(
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: calc.rrRatio)]),
                    BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(toY: calc.pnlPercent.abs())],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [BarChartRodData(toY: calc.riskedCapitalPercent.abs())],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
