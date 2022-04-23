import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/helpers/commonFunctions.dart';
import 'package:test_flutter/helpers/screenNavigation.dart';
import 'package:test_flutter/helpers/style.dart';
import 'package:test_flutter/models/UserModel.dart';
import 'package:test_flutter/screens/DashboardScreen.dart';
import 'package:test_flutter/screens/LoginScreen.dart';
import 'package:test_flutter/service/DatabaseService.dart';
import 'package:test_flutter/service/Impl/DatabaseServiceImpl.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DatabaseService _databaseService = new DatabaseServiceImpl();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      key: _registerFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Nunito',
                                  fontSize: 18),
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
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
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
                                        MediaQuery.of(context).size.width *
                                            0.04,
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
                                } else if (!_emailController.value.text
                                        .contains("@") ||
                                    !_emailController.value.text
                                        .contains(".")) {
                                  return 'Invalid email.';
                                }
                                return null;
                              },
                              textAlign: TextAlign.start,
                              autocorrect: false,
                              cursorColor: primaryColor,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                color: Color(0XFF818181),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Nunito'
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    color: Color(0XFF818181),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Nunito'),
                              ),
                              controller: _emailController,
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
                                } else if (_passwordController.value.text !=
                                    _passwordRepeatController.value.text) {
                                  return 'Passwords do not match.';
                                }
                                return null;
                              },
                              textAlign: TextAlign.start,
                              autocorrect: false,
                              cursorColor: primaryColor,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
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
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Nunito'),
                              ),
                              controller: _passwordController,
                              obscureText: true,
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
                                } else if (_passwordController.value.text !=
                                    _passwordRepeatController.value.text) {
                                  return 'Passwords do not match.';
                                }
                                return null;
                              },
                              textAlign: TextAlign.start,
                              autocorrect: false,
                              cursorColor: primaryColor,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
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
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Nunito'),
                              ),
                              controller: _passwordRepeatController,
                              obscureText: true,
                              enableSuggestions: false,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_registerFormKey.currentState!.validate()) {
                                await _register();
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
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Nunito',
                                      fontSize: 18),
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
                                    changeScreen(context, LoginScreen());
                                  },
                                  child: Text(
                                    "SignIn",
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
        )));
  }

  _register() async {
    UserModel userModel = new UserModel(
        _userNameController.value.text,
        _emailController.value.text,
        generateMd5(_passwordController.value.text));
    if (await _databaseService.checkUsername(userModel)) {
      if (await _databaseService.saveUserDetails(userModel)) {
        if(await checkInternet()) {
          Fluttertoast.showToast(
              msg: "Successfully Saved.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black45,
              fontSize: 16.0);
          changeScreenReplacement(context, DashboardScreen());
        } else{
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
            msg: "Error.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black45,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Already registered username or email, try with different one.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
    }
  }
}
