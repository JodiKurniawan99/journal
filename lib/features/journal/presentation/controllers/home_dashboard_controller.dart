import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/home_dashboard.dart';
import '../providers/journal_providers.dart';

class HomeDashboardController extends AsyncNotifier<HomeDashboard> {
  @override
  Future<HomeDashboard> build() {
    return ref.watch(getHomeDashboardUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(getHomeDashboardUseCaseProvider).call());
  }
}

final homeDashboardControllerProvider =
    AsyncNotifierProvider<HomeDashboardController, HomeDashboard>(HomeDashboardController.new);
