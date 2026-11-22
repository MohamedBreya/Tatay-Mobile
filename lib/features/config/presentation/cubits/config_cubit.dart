import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/models/app_config_model.dart';
import '../../data/repositories/config_repository.dart';
import 'config_state.dart';

/// App-wide `/config`: payment number, support phone, timings and policy texts.
class ConfigCubit extends Cubit<ConfigState> {
  ConfigCubit(this._repository) : super(const ConfigLoading());

  final ConfigRepository _repository;

  AppConfigModel? get config => switch (state) {
    ConfigLoaded(:final config) => config,
    _ => _repository.cached,
  };

  Future<void> load({bool force = false}) async {
    if (state is! ConfigLoaded) emit(const ConfigLoading());
    final result = await _repository.getConfig(forceRefresh: force);
    switch (result) {
      case Success(:final data):
        emit(ConfigLoaded(data));
      case Failure(:final failure):
        if (state is! ConfigLoaded) emit(ConfigError(failure));
    }
  }
}
