import 'package:education/core/classes/user.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/authentication_service.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';

class LoginModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  var customer;
  String errorMessage;

  Future<User> login(String name, String password) async {
    setState(ViewState.Busy);
    name = name.toLowerCase()[0].toUpperCase() + name.toLowerCase().substring(1);
    User user = await _authenticationService.readCustomer(name, password);
    setState(ViewState.Idle);
    return user;
  }
}