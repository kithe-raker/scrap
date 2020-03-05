import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImgCacheManager extends BaseCacheManager {
  static const key = "img";
  static const int maxCache = 2;
  static const Duration time = Duration(days: 1);

  ImgCacheManager()
      : super(
          key,
          maxNrOfCacheObjects: maxCache,
          maxAgeCacheObject: time,
        );

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }
}
