import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lotti/classes/geolocation.dart';
import 'package:lotti/classes/journal_entities.dart';
import 'package:lotti/database/database.dart';
import 'package:lotti/get_it.dart';
import 'package:lotti/theme.dart';
import 'package:lotti/widgets/journal/duration_widget.dart';
import 'package:lotti/widgets/journal/entry_datetime_modal.dart';
import 'package:lotti/widgets/journal/entry_tools.dart';
import 'package:lotti/widgets/misc/map_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EntryDetailHeader extends StatefulWidget {
  final JournalEntity item;
  final Function saveFn;
  final bool popOnDelete;

  const EntryDetailHeader({
    Key? key,
    required this.item,
    required this.saveFn,
    required this.popOnDelete,
  }) : super(key: key);

  @override
  State<EntryDetailHeader> createState() => _EntryDetailHeaderState();
}

class _EntryDetailHeaderState extends State<EntryDetailHeader> {
  bool mapVisible = false;

  final JournalDb db = getIt<JournalDb>();
  late final Stream<JournalEntity?> stream =
      db.watchEntityById(widget.item.meta.id);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    Geolocation? loc = widget.item.geolocation;

    return StreamBuilder<JournalEntity?>(
        stream: stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<JournalEntity?> snapshot,
        ) {
          JournalEntity? liveEntity = snapshot.data;
          if (liveEntity == null) {
            return const SizedBox.shrink();
          }

          return Container(
            color: AppColors.headerBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Visibility(
                  visible: mapVisible,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: MapWidget(
                      geolocation: widget.item.geolocation,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          builder: (BuildContext context) {
                            return EntryDateTimeModal(
                              item: liveEntity,
                            );
                          },
                        );
                      },
                      child: Text(
                        df.format(liveEntity.meta.dateFrom),
                        style: textStyle,
                      ),
                    ),
                    DurationWidget(
                      item: liveEntity,
                      style: textStyle,
                      showControls: true,
                      saveFn: widget.saveFn,
                    ),
                    Visibility(
                      visible: loc != null && loc.longitude != 0,
                      child: TextButton(
                        onPressed: () => setState(() {
                          mapVisible = !mapVisible;
                        }),
                        child: Text(
                          '📍 ${formatLatLon(loc?.latitude)}, '
                          '${formatLatLon(loc?.longitude)}',
                          style: textStyle,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(mapVisible
                          ? MdiIcons.chevronDoubleUp
                          : MdiIcons.chevronDoubleDown),
                      iconSize: 24,
                      tooltip: mapVisible
                          ? localizations.journalHideMapHint
                          : localizations.journalShowMapHint,
                      color: AppColors.entryTextColor,
                      onPressed: () {
                        setState(() {
                          mapVisible = !mapVisible;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}