import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/helpers/commonFunctions.dart';
import 'package:test_flutter/helpers/screenNavigation.dart';
import 'package:test_flutter/helpers/style.dart';
import 'package:test_flutter/models/UserModel.dart';
import 'package:test_flutter/screens/RegisterScreen.dart';
import 'package:test_flutter/service/DatabaseService.dart';
import 'package:test_flutter/service/Impl/DatabaseServiceImpl.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DatabaseService _databaseService = new DatabaseServiceImpl();

  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height,
              child: Scrollbar(
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
                              fontWeight: FontWeight.bold,
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
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Color(0XFF818181),
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
                                fontWeight: FontWeight.w300),
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
                                fontWeight: FontWeight.w300),
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
                            UserModel userModel = new UserModel(
                                _userNameController.value.text,
                                "",
                                generateMd5(_passwordController.value.text));
                            print(userModel.test_user_password);
                            print(userModel.test_user_email);
                            print(userModel.test_user_user_name);
                            if (await _databaseService
                                .loginValidate(userModel)) {
                              print("success");
                            }else{
                              Fluttertoast.showToast(
                                  msg: "Login Details incorrect or not a registered user.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black45,
                                  fontSize: 16.0
                              );
                            }
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
                                      fontWeight: FontWeight.bold,
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
                                changeScreen(context, RegisterScreen());
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        )));
  }
}
