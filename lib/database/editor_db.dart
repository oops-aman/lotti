import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lotti/utils/file_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'editor_db.g.dart';

@DriftDatabase(include: {'editor_db.drift'})
class EditorDb extends _$EditorDb {
  EditorDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertDraftState({
    required String entryId,
    required String draftDeltaJson,
  }) async {
    await (update(editorDrafts)
          ..where(
            (EditorDrafts draft) => draft.status.equals('DRAFT'),
          ))
        .write(const EditorDraftsCompanion(status: Value('ARCHIVED')));

    final draftState = EditorDraftState(
      id: uuid.v1(),
      status: 'DRAFT',
      entryId: entryId,
      createdAt: DateTime.now(),
      delta: draftDeltaJson,
    );
    return into(editorDrafts).insert(draftState);
  }

  Future<List<EditorDraftState>> getSortedLinkedEntityIds(
      String entryId) async {
    List<EditorDraftState> dbEntities = [];
//        await latestEditorState(entryId, 0, 1).get();
    return dbEntities;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'editor_drafts.sqlite'));
    return NativeDatabase(file);
  });
}
