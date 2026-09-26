import 'package:flutter_test/flutter_test.dart';

import 'package:stayable/domain/entities/app_user.dart';
import 'package:stayable/domain/entities/auth_session.dart';
import 'package:stayable/domain/entities/localized_text.dart';

void main() {
  test('LocalizedText resolves English and Hebrew', () {
    const text = LocalizedText(en: 'Squat', he: 'סקווט');
    expect(text.resolve('en'), 'Squat');
    expect(text.resolve('he'), 'סקווט');
  });

  test('age is computed from birthday', () {
    expect(ageYearsFromBirthDate(null), isNull);
    expect(
      ageYearsFromBirthDate(DateTime(1986, 9, 25), DateTime(2026, 9, 25)),
      40,
    );
    expect(
      ageYearsFromBirthDate(DateTime(1986, 9, 26), DateTime(2026, 9, 25)),
      39,
    );
  });

  test('AuthException prints the failure', () {
    expect(
      const AuthException(AuthFailure.invalidCredentials).toString(),
      'AuthException.invalidCredentials',
    );
  });
}
