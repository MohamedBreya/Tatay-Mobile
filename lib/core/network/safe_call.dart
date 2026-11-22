import 'api_failure_mapper.dart';
import 'result.dart';

/// Runs a data-source call and wraps the outcome in a [Result].
Future<Result<T>> safeCall<T>(Future<T> Function() call) async {
  try {
    return Success(await call());
  } catch (error) {
    return Failure(ApiFailureMapper.map(error));
  }
}
