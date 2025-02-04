import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lotti/classes/tag_type_definitions.dart';
import 'package:lotti/services/nav_service.dart';
import 'package:lotti/themes/theme.dart';
import 'package:lotti/themes/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.tagEntity,
    required this.onTapRemove,
  });

  final TagEntity tagEntity;
  final void Function()? onTapRemove;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(chipBorderRadius),
      child: Container(
        padding: chipPaddingClosable,
        color: getTagColor(tagEntity),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onDoubleTap: () => beamToNamed('/settings/tags/${tagEntity.id}'),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  tagEntity.tag,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Oswald',
                    color: styleConfig().tagTextColor,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onTapRemove,
              padding: const EdgeInsets.only(left: 4),
              constraints: const BoxConstraints(maxHeight: 16, maxWidth: 20),
              icon: Icon(
                MdiIcons.close,
                size: 16,
                color: styleConfig().tagTextColor,
              ),
              tooltip: localizations.journalTagsRemoveHint,
            ),
          ],
        ),
      ),
    );
  }
}
