import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:space_chat/helper/helper_functions.dart';
import 'package:space_chat/service/auth_service.dart';
import 'package:space_chat/shared/constants.dart';
import 'package:space_chat/widgets/widgets.dart';
import '../home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String email = "";
  String password = "";
  String name = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : SingleChildScrollView(
              child: SafeArea(
                minimum:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontFamily: "NanumPenScript",
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      Image.asset(
                        "assets/images/register.png",
                        height: 200,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Name cannot be empty";
                          }
                        },
                        decoration: textInputDecoration.copyWith(
                          labelText: "Full Name",
                          prefixIcon: Icon(
                            Icons.person_rounded,
                            color: Constants().primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                        decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Constants().primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                            color: Constants().primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                                text: "Login Now",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreenReplace(
                                        context, const LoginPage());
                                  }),
                          ])),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState((){
        _isLoading = true;
      });
      await authService.registerUser(name, email, password).then((value) async {
        if(value==true){
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(name);
          nextScreenReplace(context, HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState((){
            _isLoading = false;
          });
        }
      });
    }
  }
}
