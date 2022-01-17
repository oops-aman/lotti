import 'dart:convert';

import 'package:lotti/classes/entity_definitions.dart';
import 'package:lotti/classes/geolocation.dart';
import 'package:lotti/classes/journal_entities.dart';

import 'database.dart';

JournalDbEntity toDbEntity(JournalEntity entity) {
  final DateTime createdAt = entity.meta.createdAt;
  final subtype = entity
      .maybeMap(
        quantitative: (qd) => qd.data.dataType,
        measurement: (qd) => qd.data.dataType.name,
        survey: (SurveyEntry surveyEntry) =>
            surveyEntry.data.taskResult.identifier,
        orElse: () => '',
      )
      .toLowerCase();

  Geolocation? geolocation;
  entity.mapOrNull(
    journalAudio: (item) => geolocation = item.geolocation,
    journalImage: (item) => geolocation = item.geolocation,
    journalEntry: (item) => geolocation = item.geolocation,
    measurement: (item) => geolocation = item.geolocation,
  );

  String id = entity.meta.id;
  JournalDbEntity dbEntity = JournalDbEntity(
    id: id,
    createdAt: createdAt,
    updatedAt: createdAt,
    dateFrom: entity.meta.dateFrom,
    deleted: entity.meta.deletedAt != null,
    starred: entity.meta.starred ?? false,
    private: entity.meta.private ?? false,
    flag: entity.meta.flag?.index ?? 0,
    dateTo: entity.meta.dateTo,
    type: entity.runtimeType.toString().replaceFirst(r'_$', ''),
    subtype: subtype,
    serialized: json.encode(entity),
    schemaVersion: 0,
    longitude: geolocation?.longitude,
    latitude: geolocation?.latitude,
    geohashString: geolocation?.geohashString,
  );

  return dbEntity;
}

JournalEntity fromSerialized(String serialized) {
  return JournalEntity.fromJson(json.decode(serialized));
}

JournalEntity fromDbEntity(JournalDbEntity dbEntity) {
  return fromSerialized(dbEntity.serialized);
}

List<JournalEntity> entityStreamMapper(List<JournalDbEntity> dbEntities) {
  return dbEntities.map((e) => fromDbEntity(e)).toList();
}

MeasurableDataType measurableDataType(MeasurableDbEntity dbEntity) {
  return MeasurableDataType.fromJson(json.decode(dbEntity.serialized));
}

List<MeasurableDataType> measurableDataTypeStreamMapper(
    List<MeasurableDbEntity> dbEntities) {
  return dbEntities.map((e) => measurableDataType(e)).toList();
}

MeasurableDbEntity measurableDbEntity(MeasurableDataType dataType) {
  return MeasurableDbEntity(
    id: dataType.id,
    uniqueName: dataType.name,
    createdAt: dataType.createdAt,
    updatedAt: dataType.updatedAt,
    serialized: jsonEncode(dataType),
    version: dataType.version,
    status: 0,
    private: dataType.private ?? false,
    deleted: dataType.deletedAt != null,
  );
}

TagDefinitionDbEntity tagDefinitionDbEntity(TagDefinition tagDefinition) {
  return TagDefinitionDbEntity(
    tag: tagDefinition.tag,
    private: tagDefinition.private,
    createdAt: tagDefinition.createdAt,
    updatedAt: tagDefinition.updatedAt,
    serialized: jsonEncode(tagDefinition),
  );
}
