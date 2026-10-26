import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/core/time/countdown.dart';

void main() {
  final start = DateTime(2026, 10, 15, 9);
  final endsAt = start.add(const Duration(seconds: 30));

  test('full seconds at the start', () {
    expect(secondsUntil(endsAt, start), 30);
  });

  test('rounds a partial second up', () {
    expect(secondsUntil(endsAt, start.add(const Duration(milliseconds: 250))), 30);
    expect(secondsUntil(endsAt, start.add(const Duration(milliseconds: 29001))), 1);
  });

  test('catches up after the app was paused', () {
    expect(secondsUntil(endsAt, start.add(const Duration(seconds: 25))), 5);
  });

  test('zero at and after the deadline', () {
    expect(secondsUntil(endsAt, endsAt), 0);
    expect(secondsUntil(endsAt, endsAt.add(const Duration(minutes: 3))), 0);
  });
}
