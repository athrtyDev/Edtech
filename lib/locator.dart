import 'package:education/core/viewmodels/activity_home_model.dart';
import 'package:education/core/viewmodels/activity_instruction_model.dart';
import 'package:education/core/viewmodels/main_page_model.dart';
import 'package:education/core/viewmodels/profile_model.dart';
import 'package:education/core/viewmodels/publish_model.dart';
import 'package:education/core/viewmodels/register_model.dart';
import 'package:get_it/get_it.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/services/authentication_service.dart';
import 'package:education/core/viewmodels/home_model.dart';
import 'package:education/core/viewmodels/login_model.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => LoginModel());
  locator.registerFactory(() => RegisterModel());
  locator.registerFactory(() => MainPageModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => ActivityHomeModel());
  locator.registerFactory(() => ActivityInstructionModel());
  locator.registerFactory(() => PublishModel());
  locator.registerFactory(() => ProfileModel());
}