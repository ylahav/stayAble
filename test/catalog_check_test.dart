import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/remote/catalog_check.dart';

void main() {
  test('weekly check is due after seven days or when never checked', () {
    final now = DateTime.utc(2026, 9, 25);
    expect(catalogCheckDue(now: now, lastCheck: null), isTrue);
    expect(
      catalogCheckDue(now: now, lastCheck: DateTime.utc(2026, 9, 18)),
      isTrue,
    );
    expect(
      catalogCheckDue(now: now, lastCheck: DateTime.utc(2026, 9, 19)),
      isFalse,
    );
  });

  test('compares remote catalog ids against the local set', () {
    const remote = PublicCatalogStatus(
      ids: ['ex-squat', 'ex-plank', 'ex-new'],
    );
    final update = CatalogUpdate.compare(
      localIds: {'ex-squat', 'ex-plank'},
      remote: remote,
      lastSignature: 'ex-plank,ex-squat|',
    );
    expect(update.newCount, 1);
    expect(update.hasUpdates, isFalse);
    expect(update.available, isTrue);
  });

  test('notifies when existing exercises changed but none are new', () {
    final remote = PublicCatalogStatus(
      ids: const ['ex-squat'],
      updatedAt: DateTime.utc(2026, 9, 20),
    );
    final update = CatalogUpdate.compare(
      localIds: {'ex-squat'},
      remote: remote,
      lastSignature: 'ex-squat|2026-01-01T00:00:00.000Z',
    );
    expect(update.newCount, 0);
    expect(update.hasUpdates, isTrue);
  });
}
