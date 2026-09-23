import 'package:flutter_test/flutter_test.dart';

import 'package:stayable/domain/entities/localized_text.dart';

void main() {
  test('LocalizedText resolves English and Hebrew', () {
    const text = LocalizedText(en: 'Squat', he: 'סקווט');
    expect(text.resolve('en'), 'Squat');
    expect(text.resolve('he'), 'סקווט');
  });
}
