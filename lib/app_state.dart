import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'guest_book_message.dart'; // new

enum Attending { yes, no, unknown }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  int _attendees = 0;
  int get attendees => _attendees;

  Attending _attending = Attending.unknown;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;
  Attending get attending => _attending;
  set attending(Attending attending) {
    final userDoc = FirebaseFirestore.instance
        .collection('attendees')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (attending == Attending.yes) {
      userDoc.set(<String, dynamic>{'attending': true});
    } else {
      userDoc.set(<String, dynamic>{'attending': false});
    }
  }

  // Add from here...
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;
  // ...to here.

  //timetable to firestore sync
  StreamSubscription<DocumentSnapshot>? _cellTapsSubscription;
  Map<String, String> _cellTaps = {
    for (int i = 1; i <= 25; i++) i.toString(): ""
  };
  Map<String, String> get cellTaps => _cellTaps;
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
        // Add from here...
        _attendingSubscription = FirebaseFirestore.instance
            .collection('attendees')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.data() != null) {
            if (snapshot.data()!['attending'] as bool) {
              _attending = Attending.yes;
            } else {
              _attending = Attending.no;
            }
          } else {
            _attending = Attending.unknown;
          }
          notifyListeners();
        });
        // ...to here.
        // saveTimeTable(_cellTaps);
      } else {
        _loggedIn = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        _attendingSubscription?.cancel();
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

  // ...to here.
  // addcellTaps to Firestore
  Future<DocumentReference> saveTimeTable(Map<String, String> timetable) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    return FirebaseFirestore.instance
        .collection('timetable')
        .add(<String, dynamic>{
      'courses': timetable,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> saveOrUpdateTimeTable(
      String documentId, Map<String, String> timetable) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    await FirebaseFirestore.instance
        .collection('timetable')
        .doc(documentId)
        .set({
      'courses': timetable,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    }, SetOptions(merge: true));
  }

  Future<bool> checkIfTimeTableExists() async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('guestbook')
          .where('userId', isEqualTo: userId)
          .get();

      // If the query finds any documents, then a timetable exists for the user
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  Future<DocumentSnapshot> fetchTimeTable(String documentId) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('timetable')
        .doc(documentId)
        .get();

    return document;
  }
}
