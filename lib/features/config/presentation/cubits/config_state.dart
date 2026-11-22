import '../../../../core/network/api_failure.dart';
import '../../data/models/app_config_model.dart';

sealed class ConfigState {
  const ConfigState();
}

final class ConfigLoading extends ConfigState {
  const ConfigLoading();
}

final class ConfigLoaded extends ConfigState {
  const ConfigLoaded(this.config);

  final AppConfigModel config;
}

final class ConfigError extends ConfigState {
  const ConfigError(this.failure);

  final ApiFailure failure;
}
