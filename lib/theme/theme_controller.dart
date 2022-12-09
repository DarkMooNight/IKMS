import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ikms/app/data/schema.dart';
import 'package:ikms/main.dart';

class ThemeController extends GetxController {
  ThemeMode get theme => settings.theme == null
      ? ThemeMode.system
      : settings.theme == true
          ? ThemeMode.dark
          : ThemeMode.light;

  void saveTheme(bool isDarkMode) async {
    settings.theme = isDarkMode;
    isar.writeTxn(() async => isar.settings.put(settings));
  }

  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
}