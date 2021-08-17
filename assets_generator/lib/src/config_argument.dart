import 'package:yaml/yaml.dart';

import 'model/resources.dart';
import 'utils/utils.dart';

class ConfigArgument {
  String? pubSpecFileName;
  String customPackage = '';
  String outputFile = "lib/src/assets_generated_manifest.dart";
  List<String> ignoreAssets = [];
  List<CustomAssetType> assetClasses = [];

  ConfigArgument(this.pubSpecFileName);

  parseConfig(YamlMap yaml) {
    final assetGeneratorConfig = safeCast<YamlMap>(yaml["assets_generator"]);
    if (assetGeneratorConfig == null) {
      return ConfigArgument(pubSpecFileName);
    }

    ignoreAssets = _ignoreResources(assetGeneratorConfig);
    customPackage = safeCast<String>(assetGeneratorConfig["package"]) ?? customPackage;
    outputFile = safeCast<String>(assetGeneratorConfig['output']) ?? outputFile;

    final assetClasses = safeCast<YamlMap>(assetGeneratorConfig['asset_classes']);
    this.assetClasses = _parseCustomAsset(assetClasses);

    return this;
  }

  List<CustomAssetType> _parseCustomAsset(YamlMap? assetClasses) {
    if (assetClasses == null) {
      return [];
    }
    final classes = <CustomAssetType>[];
    for (final key in assetClasses.keys) {
      final keyString = safeCast<String>(key);
      if (keyString == null) {
        continue;
      }
      final Object value = assetClasses[key];
      var import = CustomAssetType.defaultImport;
      String className = '';
      if (value is YamlMap) {
        className = safeCast<String>(value['class']) ?? '';
        import = safeCast<String>(value['import']) ?? import;
      } else if (value is String) {
        className = value;
      } else {
        assert(false);
      }

      classes.add(CustomAssetType(className, keyString, import));
    }
    return classes;
  }

  List<String> _ignoreResources(YamlMap assetGeneratorConfig) {
    final ignoreRaw = safeCast<YamlList>(assetGeneratorConfig['ignore']);
    return ignoreRaw
            ?.map((x) => safeCast<String>(x) ?? '')
            .where((it) => it.isNotEmpty)
            .toList() ??
        [];
  }
}
