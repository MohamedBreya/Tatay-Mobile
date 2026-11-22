import '../../../../core/network/result.dart';
import '../../../../core/network/safe_call.dart';
import '../datasources/config_data_source.dart';
import '../models/app_config_model.dart';

/// `/config` changes rarely, so the last good copy is kept in memory for the session.
class ConfigRepository {
  ConfigRepository(this._source);

  final ConfigDataSource _source;
  AppConfigModel? _cached;

  AppConfigModel? get cached => _cached;

  Future<Result<AppConfigModel>> getConfig({bool forceRefresh = false}) async {
    final cached = _cached;
    if (cached != null && !forceRefresh) return Success(cached);
    final result = await safeCall(_source.getConfig);
    if (result case Success(:final data)) _cached = data;
    return result;
  }
}
