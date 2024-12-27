import 'package:get_it/get_it.dart';
import 'package:gorins/presentation/home/providers/home_provider.dart';
import 'package:gorins/core/network/firebase_manager.dart';
import 'package:gorins/presentation/auth/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

final getItInstance = GetIt.I;

Future<void> initDependencies() async {
  getItInstance
    ..registerSingleton<FirebaseHelper>(FirebaseHelper())
    ..registerSingleton<ImagePicker>(ImagePicker())
    ..registerLazySingleton(
      () => AuthProvider(
        getItInstance<FirebaseHelper>()
      ),
    )
    ..registerLazySingleton(
      () => HomeProvider(
        getItInstance<FirebaseHelper>(),
      ),
    );
}
