import 'package:flutter/material.dart';
import 'package:lotti/classes/entity_definitions.dart';
import 'package:lotti/themes/theme.dart';
import 'package:lotti/widgets/journal/entry_tools.dart';
import 'package:lotti/widgets/settings/settings_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HabitsTypeCard extends StatelessWidget {
  const HabitsTypeCard({
    super.key,
    required this.item,
    required this.index,
  });

  final HabitDefinition item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SettingsNavCard(
      path: '/settings/habits/${item.id}',
      title: item.name,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: fromNullableBool(item.private),
            child: Icon(
              MdiIcons.security,
              color: styleConfig().alarm,
              size: settingsIconSize,
            ),
          ),
        ],
      ),
    );
  }
}
