import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lotti/classes/config.dart';
import 'package:lotti/database/database.dart';
import 'package:lotti/get_it.dart';
import 'package:lotti/themes/themes.dart';
import 'package:lotti/utils/color.dart';
import 'package:lotti/utils/consts.dart';

class ThemesService {
  ThemesService({bool watch = true}) {
    current = darkTheme;

    if (watch) {
      _colorConfigController = StreamController<ColorConfig>.broadcast();
      _colorMapController = StreamController<Map<String, dynamic>>.broadcast();
      _updateController = StreamController<DateTime>.broadcast();
      publishLastUpdated();
      getIt<JournalDb>()
          .watchConfigFlag(showBrightSchemeFlagName)
          .listen((bright) {
        current = bright ? brightTheme : darkTheme;
        publishColorConfig();
      });
    }
  }

  late ColorConfig current;
  late final StreamController<ColorConfig> _colorConfigController;
  late final StreamController<Map<String, dynamic>> _colorMapController;
  late final StreamController<DateTime> _updateController;

  void publishColorsMap() {
    _colorMapController.add(getColorsMap());
  }

  void publishLastUpdated() {
    _updateController.add(DateTime.now());
  }

  void publishColorConfig() {
    _colorConfigController.add(current);
    publishColorsMap();
    publishLastUpdated();
  }

  Stream<ColorConfig> getColorConfigStream() {
    return _colorConfigController.stream;
  }

  Stream<Color> watchColorByKey(String colorKey) {
    Future<void>.delayed(const Duration(milliseconds: 1))
        .then((value) => publishColorsMap());
    return _colorMapController.stream.map((colorsMap) {
      final cssHex = colorsMap[colorKey].toString();
      return colorFromCssHex(cssHex);
    });
  }

  Stream<DateTime> getLastUpdateStream() {
    return _updateController.stream;
  }

  List<String> colorNames() {
    return getColorsMap().keys.sorted();
  }

  Map<String, dynamic> getColorsMap() {
    return current.toJson();
  }

  void setTheme(ColorConfig updated) {
    current = updated;
    publishColorConfig();
  }

  void setColor(String colorKey, Color color) {
    final colorsMap = getColorsMap()..[colorKey] = colorToCssHex(color);
    setTheme(ColorConfig.fromJson(colorsMap));
  }
}
