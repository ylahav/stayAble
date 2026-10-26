/// Whole seconds left until [endsAt], rounded up, never negative.
///
/// Workout countdowns are driven by a deadline rather than by counting timer
/// ticks: a timer the OS paused (screen off, app in the background) shows the
/// right value, or finishes, as soon as it ticks again.
int secondsUntil(DateTime endsAt, DateTime now) {
  final ms = endsAt.difference(now).inMilliseconds;
  if (ms <= 0) return 0;
  return (ms + 999) ~/ 1000;
}
