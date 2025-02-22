import 'dart:convert';
import 'dart:io';

import 'package:mlperfbench/localizations/app_localizations.dart';
import 'package:mlperfbench/resources/resource_manager.dart';
import 'utils.dart';

const _configListFileName = 'benchmarksConfigurations.json';
const _defaultConfigName = 'default';
const _defaultConfigUrl =
    'https://raw.githubusercontent.com/mlcommons/mobile_models/main/v2_0/assets/tasks_flutterapp.pbtxt';

class BenchmarksConfig {
  final String name;
  final String path;

  BenchmarksConfig(this.name, this.path);

  String getType(AppLocalizations stringResources) => isInternetResource(path)
      ? stringResources.internetResource
      : stringResources.localResource;

  Map<String, String> asMap() => {name: path};
}

class ConfigManager {
  final String applicationDirectory;
  final ResourceManager resourceManager;
  final BenchmarksConfig defaultConfig =
      BenchmarksConfig(_defaultConfigName, _defaultConfigUrl);
  String currentConfigName;
  String configPath = '';

  ConfigManager(
      this.applicationDirectory, this.currentConfigName, this.resourceManager);

  Future<BenchmarksConfig?> get currentConfig async =>
      await _getConfig(currentConfigName);

  Future<void> setConfig(BenchmarksConfig config) async {
    if (isInternetResource(config.path)) {
      configPath = await resourceManager.cacheManager.fileCacheHelper
          .get(config.path, true);
    } else {
      configPath = resourceManager.get(config.path);
      if (!await File(configPath).exists()) {
        throw 'local config file is missing: $configPath';
      }
    }

    if (currentConfigName == config.name) {
      return;
    }

    currentConfigName = config.name;

    final nonRemovableResources = <String>[];
    if (isInternetResource(config.path)) {
      nonRemovableResources.add(resourceManager.cacheManager.fileCacheHelper
          .getResourceRelativePath(config.path));
    }

    await resourceManager.cacheManager
        .deleteLoadedResources(nonRemovableResources);
  }

  Future<File> _createOrUpdateConfigListFile() async {
    final file = File('$applicationDirectory/$_configListFileName');
    final jsonEncoder = JsonEncoder.withIndent('  ');

    if (!await file.exists()) {
      print('Create new config file at ' + file.path);
      await file.writeAsString(jsonEncoder.convert(defaultConfig.asMap()));
      return file;
    }

    final configs =
        jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    if (configs[defaultConfig.name] != defaultConfig.path) {
      print('Update default config path in ' + file.path);
      configs[defaultConfig.name] = defaultConfig.path;
      await file.writeAsString(jsonEncoder.convert(configs));
    }

    return file;
  }

  Future<Map<String, dynamic>> _readConfigs() async {
    final file = await _createOrUpdateConfigListFile();
    return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  }

  Future<List<BenchmarksConfig>> getConfigs() async {
    final jsonContent = await _readConfigs();

    final result = <BenchmarksConfig>[];
    for (final e in jsonContent.entries) {
      result.add(BenchmarksConfig(e.key, e.value as String));
    }
    return result;
  }

  Future<void> deleteDefaultConfig() async {
    final fileName = defaultConfig.path.split('/').last;
    var configFile = File('$applicationDirectory/$fileName');
    if (await configFile.exists()) {
      await configFile.delete();
    }
  }

  Future<BenchmarksConfig?> _getConfig(String name) async {
    final jsonContent = await _readConfigs();
    final configPath = jsonContent[name] as String?;

    if (configPath != null) {
      return BenchmarksConfig(name, configPath);
    }
    return null;
  }
}
