import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalSettingsStore {
  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'guardian_settings.json'));
  }

  Future<Map<String, dynamic>> read() async {
    try {
      final file = await _file();
      if (!await file.exists()) return {};
      return Map<String, dynamic>.from(jsonDecode(await file.readAsString()));
    } catch (_) {
      return {};
    }
  }

  Future<void> write(Map<String, dynamic> value) async {
    final file = await _file();
    await file.parent.create(recursive: true);
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(jsonEncode(value), flush: true);
    await temp.rename(file.path);
  }
}

final localSettingsProvider = Provider((_) => LocalSettingsStore());
final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    Future.microtask(_load);
    return ThemeMode.dark;
  }

  Future<void> _load() async {
    final data = await ref.read(localSettingsProvider).read();
    final raw = data['themeMode']?.toString();
    if (raw != null && ThemeMode.values.any((m) => m.name == raw)) {
      state = ThemeMode.values.byName(raw);
    }
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final store = ref.read(localSettingsProvider);
    final data = await store.read();
    data['themeMode'] = mode.name;
    await store.write(data);
  }
}
