import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/ui/home/screen/home_screen.dart';
import 'package:notepad/ui/login/screen/login_screen.dart';
import 'package:notepad/ui/app_manager/app_manager_cubit.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCp-Xw3XqNT-ddV8YGeyXWwJTt3yiFtFr8",
      appId: "1:889999914025:android:9d7deef2c7bd1e841fd838",
      messagingSenderId: "889999914025",
      projectId: "notepad-a6a65",
      storageBucket: "notepad-a6a65.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppManagerCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        home: FirebaseAuth.instance.currentUser == null
            ? const LoginScreen()
            : const HomeScreen(),
      ),
    );
  }
}
