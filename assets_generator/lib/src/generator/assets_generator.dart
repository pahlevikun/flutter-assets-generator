import 'package:assets_generator/src/model/dart_class.dart';
import 'package:assets_generator/src/model/resources.dart';
import 'package:assets_generator/src/utils/utils.dart';

List<DartClass?> generateAssetManifest(List<Asset> assets) {
  return [
    _generateNonImageAssetManifest(
      assets.where((item) => item.type != AssetType.image).toList(),
    ),
    _generateImageAssetsManifest(
      assets.where((item) => item.type == AssetType.image).toList(),
    ),
  ].where((it) => it != null).toList();
}

DartClass? _generateNonImageAssetManifest(List<Asset> assets) {
  if (assets.isEmpty) {
    return null;
  }

  final imports = <String>{};

  final classString = StringBuffer("class AssetManifest {\n");
  for (final asset in assets) {
    final type = asset.type;
    if (type is CustomAssetType) {
      imports.add(type.import);
      final custom = type.customClass;
      classString.writeln(
        "  static const $custom ${createVariableName(asset.name ?? '')} = $custom(\"${(asset.path ?? '').replaceAll("../", "")}\");",
      );
    } else {
      classString.writeln(
        "  static const String ${createVariableName(asset.name ?? '')} = \"${(asset.path ?? '').replaceAll("../", "")}\";",
      );
    }
  }
  classString.writeln("}");
  return DartClass(
    code: classString.toString(),
    imports: imports.toList()..sort(),
  );
}

DartClass? _generateImageAssetsManifest(List<Asset> assets) {
  if (assets.isEmpty) {
    return null;
  }
  final classString = StringBuffer("class ImageManifest {\n");
  for (final asset in assets) {
    classString.write(
      "  static AssetImage get ${createVariableName(asset.name ?? '')} => const AssetImage(\"${asset.path}\"",
    );
    if (asset.package != null) {
      classString.write(", package: \"${asset.package}\"");
    }
    classString.writeln(");");
  }
  classString.writeln("}");
  return DartClass(
    imports: ["package:flutter/widgets.dart"],
    code: classString.toString(),
  );
}
