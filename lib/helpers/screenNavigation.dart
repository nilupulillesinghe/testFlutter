import 'package:flutter/material.dart';

/// For navigate to screens(can use back button).
void changeScreen(BuildContext context, Widget widget){
  Navigator.push(context,MaterialPageRoute(builder: (context) => widget));
}

/// For navigate to screens(can't use back button).
void changeScreenReplacement(BuildContext context,Widget widget) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => widget), (
      route) => false);
}

/// For navigate to previous screens.
void backToPrevious(BuildContext context){
  Navigator.pop(context);
}