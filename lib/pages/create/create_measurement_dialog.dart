import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:intl/intl.dart';
import 'package:lotti/beamer/beamer_delegates.dart';
import 'package:lotti/classes/entity_definitions.dart';
import 'package:lotti/database/database.dart';
import 'package:lotti/get_it.dart';
import 'package:lotti/logic/persistence_logic.dart';
import 'package:lotti/services/nav_service.dart';
import 'package:lotti/themes/theme.dart';
import 'package:lotti/widgets/form_builder/cupertino_datepicker.dart';
import 'package:lotti/widgets/journal/entry_tools.dart';

class MeasurementDialog extends StatefulWidget {
  const MeasurementDialog({
    super.key,
    required this.selectedId,
  });

  final String selectedId;

  @override
  State<MeasurementDialog> createState() => _MeasurementDialogState();
}

class _MeasurementDialogState extends State<MeasurementDialog> {
  final JournalDb _db = getIt<JournalDb>();
  final PersistenceLogic persistenceLogic = getIt<PersistenceLogic>();
  final _formKey = GlobalKey<FormBuilderState>();
  bool dirty = false;

  MeasurableDataType? selected;

  final hotkeyCmdS = HotKey(
    KeyCode.keyS,
    modifiers: [KeyModifier.meta],
    scope: HotKeyScope.inapp,
  );

  final beamBack = dashboardsBeamerDelegate.beamBack;

  Future<void> saveMeasurement() async {
    _formKey.currentState!.save();
    if (validate()) {
      final formData = _formKey.currentState?.value;
      if (selected == null) {
        return;
      }
      final measurement = MeasurementData(
        dataTypeId: selected!.id,
        dateTo: formData!['date'] as DateTime,
        dateFrom: formData['date'] as DateTime,
        value: nf.parse('${formData['value']}'.replaceAll(',', '.')),
      );

      await persistenceLogic.createMeasurementEntry(
        data: measurement,
        comment: formData['comment'] as String,
      );

      setState(() {
        dirty = false;
      });

      beamBack();
    }
  }

  @override
  void initState() {
    super.initState();

    hotKeyManager.register(
      hotkeyCmdS,
      keyDownHandler: (hotKey) => saveMeasurement(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    hotKeyManager.unregister(hotkeyCmdS);
  }

  bool validate() {
    if (_formKey.currentState != null) {
      return _formKey.currentState!.validate();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return StreamBuilder<List<MeasurableDataType>>(
      stream: _db.watchMeasurableDataTypes(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<MeasurableDataType>> snapshot,
      ) {
        final items = snapshot.data ?? [];

        if (items.length == 1) {
          selected = items.first;
        }

        for (final dataType in items) {
          if (dataType.id == widget.selectedId) {
            selected = dataType;
          }
        }

        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          contentPadding: const EdgeInsets.only(
            left: 32,
            right: 32,
            top: 16,
            bottom: 16,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: colorConfig().bodyBgColor.withAlpha(96),
              width: 3,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          backgroundColor: colorConfig().headerBgColor,
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          actions: [
            TextButton(
              key: const Key('measurement_cancel'),
              onPressed: beamBack,
              child: Text(
                localizations.addMeasurementCancelButton,
                style: cancelButtonStyle(),
              ),
            ),
            if (dirty && validate())
              TextButton(
                key: const Key('measurement_save'),
                onPressed: saveMeasurement,
                child: Text(
                  localizations.addMeasurementSaveButton,
                  style: saveButtonStyle(),
                ),
              ),
          ],
          content: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              setState(() {
                dirty = true;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selected?.displayName ?? '',
                      style: TextStyle(
                        color: colorConfig().entryTextColor,
                        fontFamily: 'Oswald',
                        fontSize: 24,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      color: colorConfig().entryTextColor,
                      onPressed: () => beamToNamed(
                        '/settings/measurables/${selected?.id}',
                      ),
                    ),
                  ],
                ),
                if ('${selected?.description}'.isNotEmpty)
                  Text(
                    '${selected?.description}',
                    style: TextStyle(
                      color: colorConfig().entryTextColor,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                FormBuilderCupertinoDateTimePicker(
                  name: 'date',
                  alwaysUse24HourFormat: true,
                  format: DateFormat(
                    "EEEE, MMMM d, yyyy 'at' HH:mm",
                  ),
                  style: inputStyle(),
                  decoration: InputDecoration(
                    labelText: 'Measurement taken',
                    labelStyle: labelStyle(),
                  ),
                  initialValue: DateTime.now(),
                  theme: DatePickerTheme(
                    headerColor: colorConfig().headerBgColor,
                    backgroundColor: colorConfig().bodyBgColor,
                    itemStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    doneStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                FormBuilderTextField(
                  initialValue: '',
                  key: const Key('measurement_value_field'),
                  decoration: InputDecoration(
                    labelText: '${selected?.displayName} '
                        '${'${selected?.unitName}'.isNotEmpty ? '[${selected?.unitName}] ' : ''}',
                    labelStyle: labelStyle(),
                  ),
                  keyboardAppearance: Brightness.dark,
                  style: inputStyle(),
                  autofocus: true,
                  validator: FormBuilderValidators.numeric(),
                  name: 'value',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                FormBuilderTextField(
                  initialValue: '',
                  key: const Key('measurement_comment_field'),
                  decoration: InputDecoration(
                    labelText: localizations.addMeasurementCommentLabel,
                    labelStyle: labelStyle(),
                  ),
                  keyboardAppearance: Brightness.dark,
                  style: inputStyle(),
                  name: 'comment',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}