import 'package:education/core/classes/user.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/authentication_service.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';
import 'package:uuid/uuid.dart';

class RegisterModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  String errorMessage;

  Future<User> registerUser(String name, String password, String age) async {
    setState(ViewState.Busy);
    // Check user name exists
    bool isExist = await _authenticationService.checkUserNameExists(name);
    if(isExist) {
      setState(ViewState.Idle);
      return null;
    } else {
      // Register user
      var uuid = Uuid();
      User user = new User();
      user.id = uuid.v4();
      user.name = name.toLowerCase()[0].toUpperCase() + name.toLowerCase().substring(1);
      user.password = password;
      user.age = int.tryParse(age);
      user.registeredDate = DateTime.now().toString();
      user.postTotal = 0;
      user.likeTotal = 0;
      user.skillTotal = 0;
      await _authenticationService.registerKid(user);
      setState(ViewState.Idle);
      return user;
    }
  }
}