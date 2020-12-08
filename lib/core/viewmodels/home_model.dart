import 'package:education/core/classes/Interface_dynamic.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class HomeModel extends BaseModel {
  final Api _api = locator<Api>();
  InterfaceDynamic interfaceDynamic;

  void initHomeView(BuildContext context) async{
    setState(ViewState.Busy);
    interfaceDynamic = await _api.getInterfaceDynamic();
    // Check app version to update
    //try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      print('app verions: ' + version);
      print('db app version: ' + interfaceDynamic.appVersion);
      print((interfaceDynamic.appVersion == version).toString());
      if(interfaceDynamic.appVersion != version) {
        // Goto update page
        Navigator.pushNamed(context, '/update');
      }
    /*} catch (e) {
      print('error: Failed to check version');
    }*/
    notifyListeners();
    setState(ViewState.Idle);
  }
}