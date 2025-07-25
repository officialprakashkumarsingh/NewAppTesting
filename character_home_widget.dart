import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'character_service.dart';
import 'character_models.dart';

class CharacterHomeWidget {
  static const String androidProvider = 'CharacterWidgetProvider';
  static const String iosName = 'CharacterWidget';

  static Future<void> update() async {
    final characters = CharacterService()
        .characters
        .map((c) => {'id': c.id, 'name': c.name, 'avatar': c.avatarUrl})
        .toList();
    try {
      await HomeWidget.saveWidgetData<String>(
        'characters',
        jsonEncode(characters),
      );
      await HomeWidget.updateWidget(
        name: androidProvider,
        iOSName: iosName,
      );
    } catch (e) {
      debugPrint('Error updating widget: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> handleCallback(Uri? uri) async {
    if (uri != null && uri.host == 'character') {
      final id = uri.queryParameters['id'];
      if (id != null) {
        CharacterService().setWidgetLaunchCharacter(id);
      }
    }
  }
}
