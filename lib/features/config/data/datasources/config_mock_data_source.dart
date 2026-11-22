import '../../../../core/mock/mock_database.dart';
import '../models/app_config_model.dart';
import 'config_data_source.dart';

class ConfigMockDataSource implements ConfigDataSource {
  ConfigMockDataSource(this._db);

  final MockDatabase _db;

  @override
  Future<AppConfigModel> getConfig() async {
    await _db.behavior.latency();
    return AppConfigModel.fromJson(_db.config);
  }
}
