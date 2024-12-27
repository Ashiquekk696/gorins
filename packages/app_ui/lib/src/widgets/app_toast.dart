
import 'package:app_ui/app_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor:AppColors.blue,
    textColor: AppColors.white,
    fontSize: 16.0,
  );
}