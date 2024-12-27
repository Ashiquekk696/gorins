import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gorins/di/di.dart';
import 'package:gorins/presentation/home/providers/home_provider.dart';
import 'package:gorins/core/network/firebase_manager.dart';
import 'package:gorins/presentation/auth/providers/auth_provider.dart';
import 'package:gorins/presentation/auth/views/login_screen.dart';
import 'package:gorins/routes.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initDependencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider(getItInstance<FirebaseHelper>())),
        ChangeNotifierProvider(
            create: (_) => HomeProvider(getItInstance<FirebaseHelper>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        onGenerateRoute: Routes.generateRoute,
        initialRoute: Routes.login,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.lightGrey,
          ),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
