import 'package:flutter/material.dart';

import '../domain/models/journal_model.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final _formKey = GlobalKey<FormState>();
  late final AddJournalFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddJournalFormController()..addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _controller.selectedDate,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );

    if (selected != null) {
      _controller.setDate(selected);
    }
  }

  Future<void> _saveTrade() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    _controller.setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final journal = _controller.buildJournal();
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(journal);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Trade Journal')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionCard(
                  title: 'Trade Info',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller.pairController,
                        focusNode: _controller.pairFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _controller.tradeTypeFocus.requestFocus(),
                        decoration: _inputDecoration('Pair Name'),
                        validator: _controller.validateRequired,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<TradeType>(
                        value: _controller.tradeType,
                        focusNode: _controller.tradeTypeFocus,
                        decoration: _inputDecoration('Trade Type'),
                        items: TradeType.values
                            .map(
                              (type) => DropdownMenuItem<TradeType>(
                                value: type,
                                child: Text(type == TradeType.buy ? 'Buy' : 'Sell'),
                              ),
                            )
                            .toList(),
                        onChanged: _controller.setTradeType,
                        validator: _controller.validateTradeType,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controller.entryPriceController,
                        focusNode: _controller.entryPriceFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (_) => _controller.exitPriceFocus.requestFocus(),
                        decoration: _inputDecoration('Entry Price'),
                        validator: (value) =>
                            _controller.validateNumber(value, label: 'Entry price'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controller.exitPriceController,
                        focusNode: _controller.exitPriceFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (_) => _controller.lotSizeFocus.requestFocus(),
                        decoration: _inputDecoration('Exit Price'),
                        validator: _controller.validateExitPrice,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controller.lotSizeController,
                        focusNode: _controller.lotSizeFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (_) => _controller.riskRewardFocus.requestFocus(),
                        decoration: _inputDecoration('Lot Size (optional)'),
                        validator: (value) => _controller.validateOptionalNumber(
                          value,
                          label: 'Lot size',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controller.riskRewardController,
                        focusNode: _controller.riskRewardFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (_) => _controller.profitLossFocus.requestFocus(),
                        decoration: _inputDecoration('Risk/Reward Ratio'),
                        validator: (value) =>
                            _controller.validateNumber(value, label: 'Risk/Reward ratio'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Psychology',
                  child: Column(
                    children: [
                      DropdownButtonFormField<TradeEmotion>(
                        value: _controller.emotionBefore,
                        decoration: _inputDecoration('Emotion Before Trade'),
                        items: TradeEmotion.values
                            .map(
                              (emotion) => DropdownMenuItem<TradeEmotion>(
                                value: emotion,
                                child: Text(emotion.label),
                              ),
                            )
                            .toList(),
                        onChanged: _controller.setEmotionBefore,
                        validator: _controller.validateEmotion,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<TradeEmotion>(
                        value: _controller.emotionAfter,
                        decoration: _inputDecoration('Emotion After Trade'),
                        items: TradeEmotion.values
                            .map(
                              (emotion) => DropdownMenuItem<TradeEmotion>(
                                value: emotion,
                                child: Text(emotion.label),
                              ),
                            )
                            .toList(),
                        onChanged: _controller.setEmotionAfter,
                        validator: _controller.validateEmotion,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Result',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller.profitLossController,
                        focusNode: _controller.profitLossFocus,
                        textInputAction: TextInputAction.done,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _inputDecoration('Profit/Loss (optional manual)'),
                        validator: (value) => _controller.validateOptionalNumber(
                          value,
                          label: 'Profit/Loss',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Auto calc preview: ${_controller.calculatedProfitLoss.toStringAsFixed(2)}',
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration: _inputDecoration('Trade Date'),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text(_controller.formattedDate),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton(
                      onPressed: _controller.canSubmit && !_controller.isLoading
                          ? _saveTrade
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: colorScheme.onPrimary,
                        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                        disabledForegroundColor: colorScheme.onSurfaceVariant,
                        shadowColor: Colors.transparent,
                      ),
                      child: _controller.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Trade'),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class AddJournalFormController extends ChangeNotifier {
  AddJournalFormController() {
    pairController.addListener(_onFieldChanged);
    entryPriceController.addListener(_onFieldChanged);
    exitPriceController.addListener(_onFieldChanged);
    lotSizeController.addListener(_onFieldChanged);
    riskRewardController.addListener(_onFieldChanged);
    profitLossController.addListener(_onFieldChanged);
  }

  final TextEditingController pairController = TextEditingController();
  final TextEditingController entryPriceController = TextEditingController();
  final TextEditingController exitPriceController = TextEditingController();
  final TextEditingController lotSizeController = TextEditingController();
  final TextEditingController riskRewardController = TextEditingController();
  final TextEditingController profitLossController = TextEditingController();

  final FocusNode pairFocus = FocusNode();
  final FocusNode tradeTypeFocus = FocusNode();
  final FocusNode entryPriceFocus = FocusNode();
  final FocusNode exitPriceFocus = FocusNode();
  final FocusNode lotSizeFocus = FocusNode();
  final FocusNode riskRewardFocus = FocusNode();
  final FocusNode profitLossFocus = FocusNode();

  TradeType? tradeType;
  TradeEmotion? emotionBefore;
  TradeEmotion? emotionAfter;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  bool get canSubmit {
    return pairController.text.trim().isNotEmpty &&
        tradeType != null &&
        _parseNumber(entryPriceController.text) != null &&
        _parseNumber(exitPriceController.text) != null &&
        _parseNumber(exitPriceController.text) != 0 &&
        _parseNumber(riskRewardController.text) != null &&
        emotionBefore != null &&
        emotionAfter != null &&
        !isLoading;
  }

  double get calculatedProfitLoss {
    final entry = _parseNumber(entryPriceController.text) ?? 0;
    final exit = _parseNumber(exitPriceController.text) ?? 0;
    final lot = _parseNumber(lotSizeController.text) ?? 1;

    if (tradeType == TradeType.sell) {
      return (entry - exit) * lot;
    }

    return (exit - entry) * lot;
  }

  String get formattedDate {
    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    return '$day/$month/${selectedDate.year}';
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? validateNumber(String? value, {required String label}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    if (_parseNumber(value) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  String? validateOptionalNumber(String? value, {required String label}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (_parseNumber(value) == null) {
      return '$label must be a valid number';
    }
    return null;
  }

  String? validateExitPrice(String? value) {
    final numberError = validateNumber(value, label: 'Exit price');
    if (numberError != null) {
      return numberError;
    }

    final parsed = _parseNumber(value ?? '');
    if (parsed == 0) {
      return 'Exit price cannot be 0';
    }
    return null;
  }

  String? validateTradeType(TradeType? value) {
    if (value == null) {
      return 'Trade type is required';
    }
    return null;
  }

  String? validateEmotion(TradeEmotion? value) {
    if (value == null) {
      return 'Please select an emotion';
    }
    return null;
  }

  void setTradeType(TradeType? value) {
    tradeType = value;
    notifyListeners();
  }

  void setEmotionBefore(TradeEmotion? value) {
    emotionBefore = value;
    notifyListeners();
  }

  void setEmotionAfter(TradeEmotion? value) {
    emotionAfter = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    selectedDate = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  JournalModel buildJournal() {
    final manualPnl = _parseNumber(profitLossController.text);
    return JournalModel(
      pair: pairController.text.trim(),
      tradeType: tradeType!,
      entryPrice: _parseNumber(entryPriceController.text)!,
      exitPrice: _parseNumber(exitPriceController.text)!,
      date: selectedDate,
      riskRewardRatio: _parseNumber(riskRewardController.text)!,
      lotSize: _parseNumber(lotSizeController.text),
      emotionBeforeTrade: emotionBefore!,
      emotionAfterTrade: emotionAfter!,
      profitLoss: manualPnl ?? calculatedProfitLoss,
    );
  }

  double? _parseNumber(String value) {
    return double.tryParse(value.trim());
  }

  void _onFieldChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    pairController.dispose();
    entryPriceController.dispose();
    exitPriceController.dispose();
    lotSizeController.dispose();
    riskRewardController.dispose();
    profitLossController.dispose();
    pairFocus.dispose();
    tradeTypeFocus.dispose();
    entryPriceFocus.dispose();
    exitPriceFocus.dispose();
    lotSizeFocus.dispose();
    riskRewardFocus.dispose();
    profitLossFocus.dispose();
    super.dispose();
  }
}
