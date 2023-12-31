import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart'; // new

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // new
import 'package:gtk_flutter/color_schemes.g.dart';
import 'package:gtk_flutter/screens/main_page.dart';
import 'package:gtk_flutter/screens/timetable_page.dart';
import '../src/jp.dart'; // new

import 'package:go_router/go_router.dart'; // new
import 'package:gtk_flutter/screens/top_page.dart';
import 'package:provider/provider.dart'; // new

import 'model/app_state.dart'; // new
import 'model/app_state_model.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApplicationState()),
        ChangeNotifierProvider(
            create: (context) => AppStateModel()..loadProducts()),
      ],
      child: const App(),
    ),
  );
}

// Add GoRouter configuration outside the App class
final _router = GoRouter(
  // redirect: (BuildContext context, GoRouterState state) {
  //   final isAuthenticated =  // your logic to check if user is authenticated
  //   if (!isAuthenticated) {
  //     return '/';
  //   } else {
  //     return null; // return "null" to display the intended route without redirecting
  //   }
  // },
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
                      'uid': FirebaseAuth.instance.currentUser!.uid,
                      'email': FirebaseAuth.instance.currentUser!.email,
                      'timetables': {
                        for (var i = 1; i <= 10; i++) 'timetable$i': {"1": ""}
                      },
                      'bottomInfo': ["", "", ""]
                    }).then((value) {
                      print("User Added");
                      if (!user.emailVerified) {
                        user.sendEmailVerification();
                        const snackBar = SnackBar(
                            content: Text(
                                'Please check your email to verify your email address'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }).catchError((error) {
                      print("Failed to add user: $error");
                    });
                  }

                  context.go('/');
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
                  context.go('/');
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
GoRouter get router => _router;

// Change MaterialApp to MaterialApp.router and add the routerConfig
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    return MaterialApp.router(
      title: 'Uniberry',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: brightnessValue == Brightness.dark
            ? darkColorScheme
            : lightColorScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,

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
