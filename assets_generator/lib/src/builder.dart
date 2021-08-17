import 'dart:io';

import 'package:assets_generator/src/config_argument.dart';
import 'package:yaml/yaml.dart';

import 'model/resources.dart';
import 'parser/assets_parser.dart';
import 'parser/fonts_parser.dart';

Resources parseResources(ConfigArgument arguments) {
  final pubSpecFile = File(arguments.pubSpecFileName ?? '').absolute;
  if (!pubSpecFile.existsSync()) {
    exit(1);
  }

  final yaml = loadYaml(pubSpecFile.readAsStringSync()) as YamlMap;

  return Resources(
    fonts: parseFonts(yaml),
    assets: parseAssets(
      yaml,
      arguments.ignoreAssets,
      arguments.assetClasses,
      arguments.customPackage,
    ),
  );
}
