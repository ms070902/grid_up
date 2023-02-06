import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/auth/providers/auth_state_provider.dart';
import 'package:nexus/state/auth/providers/is_logged_in_provider.dart';
import 'package:nexus/state/providers/is_loading_provider.dart';
import 'package:nexus/views/components/loading/loading_screen.dart';
import 'package:nexus/views/login/login_view.dart';
import 'package:nexus/views/main/main_view.dart';
import 'firebase_options.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

final Map<int, Color> _whiteTheme = {
  50: Colors.white,
  100: Colors.white70,
  200: Colors.white60,
  300: Colors.white54,
  400: Colors.white38,
  500: Colors.white30,
  600: Colors.white24,
  700: Colors.white12,
  800: Colors.white10,
};

final MaterialColor _whiteSwatch = MaterialColor(
  Colors.white.value,
  _whiteTheme,
);

ThemeData _themeDark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  indicatorColor: Colors.blueGrey,
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   primarySwatch: Colors.blueGrey,
      //   indicatorColor: Colors.blueGrey,
      // ),
      theme: ThemeData(
        primarySwatch: _whiteSwatch,
        brightness: Brightness.light,
        indicatorColor: Colors.blue,
        dialogBackgroundColor: Colors.blueGrey[100],
        primaryColor: Colors.blueGrey,
        bottomAppBarColor: Colors.white54,
        dividerColor: Colors.blueGrey[300],
        dividerTheme: DividerThemeData(
          color: Colors.blueGrey[200],
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          circularTrackColor: Colors.blueGrey[500],
        ),
      ),
      themeMode: ThemeMode.system,
      darkTheme: _themeDark,
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          ref.listen<bool>(
            isLoadingProvider,
            (previous, isLoading) {
              if (isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                );
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}

///when user is logged in
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NexUs'),
      ),
      body: Consumer(
        builder: (_, ref, child) {
          return TextButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logOut();
            },
            child: const Text(
              'Log Out',
            ),
          );
        },
      ),
    );
  }
}
