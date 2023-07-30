// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, left: 24, bottom: 8),
              child: ElevatedButton(
                  onPressed: () {
                    context.go('/top');
                  },
                  child: const Text('Start')),
            ),
          ),
          Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, left: 24, bottom: 8),
              child: ElevatedButton(
                  onPressed: () {
                    context.go('/profile');
                  },
                  child: const Text('Profile')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24, bottom: 8),
            child: ElevatedButton(
                onPressed: () {
                  if (loggedIn) {
                    signOut();
                  } else {
                    context.push('/sign-in');
                  }
                },
                child: loggedIn ? const Text('Logout') : const Text('Login')),
          )
        ],
      ),
    );
  }
}
