import 'package:assets_generator/src/model/dart_class.dart';
import 'package:assets_generator/src/utils/utils.dart';

DartClass? generateFontManifest(List<String> fonts) {
  if (fonts.isEmpty) {
    return null;
  }
  final classString = StringBuffer("class FontManifest {\n");
  for (final font in fonts) {
    classString.writeln("  static const String ${createVariableName(font)} = \"$font\";");
  }
  classString.writeln("}");
  return DartClass(code: classString.toString());
}
