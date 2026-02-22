import 'package:flutter/material.dart';

extension HomeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;
}

extension ProfitFormattingX on num {
  String get asSignedCurrency {
    final sign = this >= 0 ? '+' : '-';
    return '$sign${abs().toStringAsFixed(2)}';
  }
}
