import 'package:lotti/blocs/sync/outbox_cubit.dart';
import 'package:lotti/blocs/sync/outbox_state.dart';
import 'package:lotti/blocs/sync/sync_config_cubit.dart';
import 'package:lotti/blocs/sync/sync_config_state.dart';
import 'package:lotti/database/logging_db.dart';
import 'package:lotti/database/sync_db.dart';
import 'package:lotti/services/sync_config_service.dart';
import 'package:lotti/sync/inbox/inbox_service.dart';
import 'package:lotti/sync/outbox/outbox_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSyncConfigService extends Mock implements SyncConfigService {}

class MockSyncInboxService extends Mock implements InboxService {}

class MockOutboxService extends Mock implements OutboxService {}

class MockSyncConfigCubit extends Mock implements SyncConfigCubit {}

class MockLoggingDb extends Mock implements LoggingDb {}

MockSyncConfigCubit mockSyncConfigCubitWithState(SyncConfigState state) {
  final mock = MockSyncConfigCubit();
  when(() => mock.state).thenReturn(state);

  when(mock.close).thenAnswer((_) async {});

  when(() => mock.stream).thenAnswer(
    (_) => Stream<SyncConfigState>.fromIterable([state]),
  );

  return mock;
}

class MockSyncDatabase extends Mock implements SyncDatabase {}

MockSyncDatabase mockSyncDatabaseWithCount(int count) {
  final mock = MockSyncDatabase();
  when(mock.close).thenAnswer((_) async {});

  when(mock.watchOutboxCount).thenAnswer(
    (_) => Stream<int>.fromIterable([count]),
  );

  return mock;
}

class MockOutboxCubit extends Mock implements OutboxCubit {}

MockOutboxCubit mockOutboxCubit(OutboxState outboxState) {
  final mock = MockOutboxCubit();
  when(() => mock.state).thenReturn(outboxState);

  when(mock.close).thenAnswer((_) async {});

  when(() => mock.stream).thenAnswer(
    (_) => Stream<OutboxState>.fromIterable([outboxState]),
  );

  return mock;
}
