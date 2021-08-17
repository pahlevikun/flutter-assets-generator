#!/usr/bin/env dart

import 'dart:io';

import 'package:args/args.dart';
import 'package:assets_generator/assets_generator.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  print("Generating assets...");

  final arguments = CommandLineArguments()..parse(args);

  final configRaw = safeCast<YamlMap>(
    loadYaml(File(arguments.yamlFileName).absolute.readAsStringSync()),
  );
  final ConfigArgument config = ConfigArgument(arguments.yamlFileName).parseConfig(
    configRaw ?? YamlMap(),
  );

  final res = parseResources(config);
  final contents = generateFile(res, config);

  final outputFile = File(config.outputFile);
  outputFile.writeAsStringSync(contents);

  print("${outputFile.path} generated successfully");
}

class CommandLineArguments {
  String yamlFileName = '';
  String outputFilename = '';

  void parse(List<String> args) {
    ArgParser()
      ..addOption(
        "yaml",
        defaultsTo: 'pubspec.yaml',
        callback: (value) => yamlFileName = safeCast(value),
        help: 'Specify the yaml file, default is pubscpec.yaml.',
      )
      ..parse(args);
  }
}
