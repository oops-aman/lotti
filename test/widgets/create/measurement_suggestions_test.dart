import 'package:flutter_test/flutter_test.dart';
import 'package:lotti/classes/journal_entities.dart';
import 'package:lotti/database/database.dart';
import 'package:lotti/get_it.dart';
import 'package:lotti/logic/persistence_logic.dart';
import 'package:lotti/themes/themes_service.dart';
import 'package:lotti/widgets/create/suggest_measurement.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';
import '../../test_data/test_data.dart';
import '../../utils/measurable_utils_test.dart';
import '../../widget_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerFallbackValue(FakeMeasurementData());

  group(' - ', () {
    final mockJournalDb = MockJournalDb();
    final mockPersistenceLogic = MockPersistenceLogic();

    when(
      () => mockJournalDb.watchMeasurementsByType(
        rangeStart: any(named: 'rangeStart'),
        rangeEnd: any(named: 'rangeEnd'),
        type: measurableWater.id,
      ),
    ).thenAnswer(
      (_) => Stream<List<JournalEntity>>.fromIterable([
        testMeasurements(
          <num>[111, 500, 250, 500, 250, 500, 250, 500, 100, 100, 50],
        ),
      ]),
    );

    Future<MeasurementEntry?> mockCreateMeasurementEntry() {
      return mockPersistenceLogic.createMeasurementEntry(
        data: any(named: 'data'),
        comment: any(named: 'comment'),
        private: false,
      );
    }

    when(mockCreateMeasurementEntry).thenAnswer((_) async => null);

    setUp(() async {
      getIt
        ..registerSingleton<ThemesService>(ThemesService(watch: false))
        ..registerSingleton<JournalDb>(mockJournalDb)
        ..registerSingleton<PersistenceLogic>(mockPersistenceLogic);
    });
    tearDown(getIt.reset);

    testWidgets(
      '',
      (tester) async {
        await tester.pumpWidget(
          makeTestableWidgetWithScaffold(
            MeasurementSuggestions(
              measurableDataType: measurableWater,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('500 ml'), findsOneWidget);
        expect(find.text('250 ml'), findsOneWidget);
        expect(find.text('100 ml'), findsOneWidget);

        await tester.tap(find.text('500 ml'));
        await tester.pumpAndSettle();

        verify(mockCreateMeasurementEntry).called(1);
      },
    );
  });
}
