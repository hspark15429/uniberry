import 'package:gtk_flutter/model/timetable_event.dart';

class TimetableEventsSet {
  final String id;
  final List<TimetableEvent> events;

  TimetableEventsSet({required this.id, required this.events});
}
