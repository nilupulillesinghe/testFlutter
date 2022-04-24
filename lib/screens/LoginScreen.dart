import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/helpers/commonFunctions.dart';
import 'package:test_flutter/helpers/screenNavigation.dart';
import 'package:test_flutter/helpers/style.dart';
import 'package:test_flutter/models/UserModel.dart';
import 'package:test_flutter/screens/DashboardScreen.dart';
import 'package:test_flutter/screens/RegisterScreen.dart';
import 'package:test_flutter/service/DatabaseService.dart';
import 'package:test_flutter/service/Impl/DatabaseServiceImpl.dart';
import 'package:test_flutter/service/ServiceLocator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late DatabaseService _databaseService;

  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _databaseService = locator<DatabaseServiceImpl>();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? _lastPressedAt;

    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 1)) {
          Fluttertoast.showToast(
            fontSize: 12.0,
            msg: "Press again to exit the app",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            textColor: Colors.black87,
            gravity: ToastGravity.BOTTOM,
          );
          //Re-timed after two clicks of more than 1 second
          _lastPressedAt = DateTime.now();
          return false;
        }
        return true;
      },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: Form(
                              key: _loginFormKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "SignIn",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          fontFamily: 'Nunito'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0XFFF0F1FA),
                                            blurRadius: 0.2,
                                            spreadRadius: 0.2,
                                            // offset: Offset(0, 2),
                                          ),
                                        ]),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required.';
                                        }
                                        return null;
                                      },
                                      textAlign: TextAlign.start,
                                      autocorrect: false,
                                      cursorColor: primaryColor,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.04,
                                          color: Color(0XFF818181),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Nunito'
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Username",
                                        hintStyle: TextStyle(
                                            color: Color(0XFF818181),
                                            fontSize:
                                            MediaQuery.of(context).size.width * 0.04,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Nunito'),
                                      ),
                                      controller: _userNameController,
                                      obscureText: false,
                                      enableSuggestions: false,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0XFFF0F1FA),
                                            blurRadius: 0.2,
                                            spreadRadius: 0.2,
                                            // offset: Offset(0, 2),
                                          ),
                                        ]),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required.';
                                        }
                                        return null;
                                      },
                                      textAlign: TextAlign.start,
                                      autocorrect: false,
                                      cursorColor: primaryColor,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.04,
                                          color: Color(0XFF818181),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Nunito'
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color: Color(0XFF818181),
                                            fontSize:
                                            MediaQuery.of(context).size.width * 0.04,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Nunito'),
                                      ),
                                      controller: _passwordController,
                                      obscureText: true,
                                      enableSuggestions: false,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (_loginFormKey.currentState!.validate()) {
                                        await _signIn();
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0XFFFF3A44),
                                                Color(0xFFFF8086)
                                              ])),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Center(
                                            child: Text(
                                              "SignIn",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Nunito'),
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.25,
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            changeScreen(context, RegisterScreen());
                                          },
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Nunito',
                                                fontSize: 12),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height*0.065,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ))));
  }

  /// Login process.
  _signIn() async {
    UserModel userModel = new UserModel(_userNameController.value.text, "",
        generateMd5(_passwordController.value.text));
    print(userModel.test_user_password);
    print(userModel.test_user_email);
    print(userModel.test_user_user_name);
    bool status = await _databaseService.loginValidate(userModel).catchError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "${error.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
      print("outer: $error");
    });
    if (status) {
      bool internetStatus = await checkInternet().catchError((error, stackTrace) {
        Fluttertoast.showToast(
            msg: "Please check internet, Connectivity.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black45,
            fontSize: 16.0);
        print("outer: $error");
      });
      if(internetStatus) {
        Fluttertoast.showToast(
            msg: "Login success.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black45,
            fontSize: 16.0);
        changeScreenReplacement(context, DashboardScreen());
      }else{
        Fluttertoast.showToast(
            msg: "Internet Not Available.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black45,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Login Details incorrect or not a registered user.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
    }
  }
}
