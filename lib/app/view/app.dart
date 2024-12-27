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
/// Initializes the state of the widget by setting up dependencies
/// and calling the superclass's initState method.

  void initState() {
    initDependencies();
    super.initState();
  }

  @override
  /// Builds the material app widget tree by providing the auth provider and
  /// home provider and setting up the routes and initial route.
  ///
  /// The [MaterialApp] widget is wrapped in a [MultiProvider] widget which
  /// provides the [AuthProvider] and [HomeProvider] to its child widgets.
  ///
  /// The app's theme is set to a light grey theme and the material 3 design
  /// language is used. The [LoginScreen] widget is set as the home widget.
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
