import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/remote/local_accounts.dart';

void main() {
  test('hashes a local password and verifies it', () {
    const salt = 'salt-1';
    final hash = hashLocalPassword('secret', salt);
    final account = LocalAccountRecord(
      id: 'local-user-1',
      name: 'Ada',
      email: 'ada@example.com',
      salt: salt,
      hash: hash,
    );
    expect(account.matches('secret'), isTrue);
    expect(account.matches('wrong'), isFalse);
  });

  test('round-trips local accounts and normalizes email', () {
    final account = LocalAccountRecord(
      id: 'local-user-2',
      name: 'Ada',
      email: 'Ada@Example.com',
      salt: 'salt-2',
      hash: hashLocalPassword('secret', 'salt-2'),
    );
    final encoded = encodeLocalAccounts({
      normalizeLocalEmail(account.email): account,
    });
    final parsed = parseLocalAccounts(encoded);
    expect(parsed['ada@example.com']?.id, 'local-user-2');
    expect(isLocalSessionToken(localSessionToken('local-user-2')), isTrue);
    expect(localUserIdFromToken(localSessionToken('local-user-2')), 'local-user-2');
  });
}
