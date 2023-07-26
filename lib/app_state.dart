import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'guest_book_message.dart';
import 'model/timetable_events_set.dart'; // new

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  final List<TimetableEventsSet> eventSets = [];

  TimetableEventsSet? _currentEventsSet;
  TimetableEventsSet? get currentEventsSet => _currentEventsSet;
  set currentEventsSet(TimetableEventsSet? value) {
    _currentEventsSet = value;
    notifyListeners();
  }

  void loadEventsSets() {
    // fetch events sets from firestore
    notifyListeners();
  }

  void removeEventSet(String setId) {
    eventSets.removeWhere((set) => set.id == setId);
    notifyListeners();
  }

  // Add from here...
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;
  // ...to here.

  late List<String> docIDs = [];

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    // Creates a stream of user changes to Firebase Auth and listens to it Fires
    // rebuild to listeners whenever there's a change in the user's login state.
    FirebaseAuth.instance.userChanges().asyncMap((user) async {
      if (user != null) {
        _loggedIn = true;
      }
      return user;
    }).listen((user) {
      if (user != null) {
        _loggedIn = true;
        _guestBookSubscription?.cancel(); // prevents multiple streams
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _guestBookMessages = [];
          for (final document in snapshot.docs) {
            _guestBookMessages.add(
              GuestBookMessage(
                name: document.data()['name'] as String,
                message: document.data()['text'] as String,
                time: "time",
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
