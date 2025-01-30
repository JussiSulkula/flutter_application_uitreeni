import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_uitreeni/data/db_helper.dart';
import 'package:flutter_application_uitreeni/data/todo_list_manager.dart';
import 'package:flutter_application_uitreeni/views/mainview.dart';
import 'package:flutter_application_uitreeni/views/todo_list_view.dart';
import 'package:provider/provider.dart';

import 'views/input_view.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();

await DatabaseHelper.instance.init();
runApp(ChangeNotifierProvider(
  create: (context){
    var model = TodoListManager();
    model.init();
    return model;
  },
  child:  const MyApp()),
 );
}
  

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
     final providers = [EmailAuthProvider()];
     void onSignedIn() {
      Navigator.pushReplacementNamed(context, '/todolist');
    }
    return MaterialApp(
      title: appTitle,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/todolist',
      routes: {
        '/main' : (context) => MainView(),
        '/todolist' : (context) => TodoListView(),
        '/input' : (context) => InputView(),
         '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) {
                // Put any new user logic here
                onSignedIn();
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                onSignedIn();
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            providers: providers,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },

      },
    );
  }
}