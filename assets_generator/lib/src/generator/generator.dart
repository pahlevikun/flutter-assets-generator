import 'package:assets_generator/src/config_argument.dart';
import 'package:assets_generator/src/generator/assets_generator.dart';
import 'package:assets_generator/src/generator/fonts_generator.dart';
import 'package:assets_generator/src/model/dart_class.dart';
import 'package:assets_generator/src/model/resources.dart';

String generateFile(Resources res, ConfigArgument arguments) {
  var classes = <DartClass?>[];
  classes.add(generateFontManifest(res.fonts ?? []));
  classes.addAll(generateAssetManifest(res.assets?.assets ?? []));

  classes = classes.where((item) => item != null).toList();

  final fullCode = StringBuffer("");
  final imports = classes.expand((it) => it?.imports ?? []).toSet().toList();
  imports.sort();
  for (final import in imports) {
    fullCode.writeln("import '$import';");
  }

  if (fullCode.isNotEmpty) {
    fullCode.write("\n");
  }

  for (final dartClass in classes) {
    fullCode.writeln(dartClass?.code);
  }
  return fullCode.toString();
}
