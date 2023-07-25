import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart'; // new

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // new
import 'package:gtk_flutter/color_schemes.g.dart';
import '../src/jp.dart'; // new

import 'package:go_router/go_router.dart'; // new
import 'package:gtk_flutter/screens/top_page.dart';
import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

// Add GoRouter configuration outside the App class
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, appState) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    // create user in firestore
                    user.updateDisplayName(user.email!.split('@')[0]);
                    FirebaseFirestore.instance.collection('users').add({
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'email': FirebaseAuth.instance.currentUser!.email,
                      'currentTimetable': {'1': ''},
                    }).then((value) {
                      print("User Added");
                    }).catchError((error) {
                      print("Failed to add user: $error");
                    });
                  }
                  // if (!user.emailVerified) {
                  //   user.sendEmailVerification();
                  //   const snackBar = SnackBar(
                  //       content: Text(
                  //           'Please check your email to verify your email address'));
                  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // }
                  context.pushReplacement('/');
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: 'top',
          builder: (context, state) {
            return TopPage();
          },
        ),
      ],
      // redirect: (context, appState) => true ? '/sign-in' : null,
    ),
  ],
);
// end of GoRouter configuration

// Change MaterialApp to MaterialApp.router and add the routerConfig
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Uniberry',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: _router,

      // Add the localization delegates
      localizationsDelegates: [
        // Creates an instance of FirebaseUILocalizationDelegate with overridden labels
        FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
        // Delegates below take care of built-in flutter widgets
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // This delegate is required to provide the labels that are not overridden by LabelOverrides
        FirebaseUILocalizations.delegate,
      ],
    );
  }
}
