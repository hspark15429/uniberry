class TimetableEvent {
  final String id;
  final String period; // Mon1, Fri5 etc.
  final String description;

  TimetableEvent(
      {required this.id, required this.period, required this.description});
}
