import 'dart:io';
import 'base_command.dart';
import 'package:yaml/yaml.dart';
import "./utils/structureutils.dart";


class AppCommand extends BaseCommand {

  final String name = "setup_app";
  final String description = "Convert a flutter app to adhara app";

  AppCommand() {
    argParser.addOption('name', abbr: 'n', help: 'create an app with this name');
  }

  void run() async {
    if(!(await hasAdharaDependency())){
      return;
    }
    await copyAssets();
    await copyAppScripts();
    print(argResults['name']);
  }

  Future<bool> hasAdharaDependency() async {
    String contents = await new File("pubspec.yaml").readAsString();
    YamlMap doc = loadYaml(contents);
    if(doc["dependencies"]["adhara"]==null){
      print("Add adhara as a dependency in pubspec.yaml\n"
          " Deatils about latest version can be found at https://pub.dev/packages/adhara");
      return false;
    }
    return true;
  }

  Future copyAssets() async {
    print("creating default assets...");
    await copyDirectory(Directory(resolveToTemplatesPath(['assets'])), Directory('assets'));
  }

  Future copyAppScripts() async {
    print("creating default scripts...");
    await copyDirectory(Directory(resolveToTemplatesPath(['lib'])), Directory('lib'));
  }

}