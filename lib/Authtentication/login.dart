import 'package:flutter/material.dart';
import 'package:quiz/Authtentication/signup.dart';
import 'package:quiz/JsonModels/users.dart';
import 'package:quiz/SQLite/sqlite.dart';
import 'package:quiz/Views/notes.dart';

import '../_constant/button.dart';
import '../_constant/color.dart';
import '../_constant/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //TextEditing controller to control the text when we enter into it
  final username = TextEditingController();
  final password = TextEditingController();

  //A bool variable for show and hide password
  bool isVisible = false;

  //Here is our bool variable
  bool isLoginTrue = false;

  final db = DatabaseHelper();

  //Now we should call this function in login button
  login() async {
    Users? usr = await db.getCurrentUser(username.text);
    var response = await db
        .login(Users(usrName: username.text, usrPassword: password.text));
    if (response == true) {
      print("------------------------{$username}");
      //If login is correct, then goto notes
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Notes()));
    } else {
      //If not, true the bool value to show error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  //We have to create global key for our form
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              //We put all our textfield to a form to be controlled and not allow as empty
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text('Let’s Login',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 55),

                    //Username field
                    //  Before we show the image, after we copied the image we need to define the location in pubspec.yaml
                    // Image.asset(
                    //   "lib/assets/login.png",
                    //   width: 210,
                    // ), const SizedBox(height: 50),
                    AuthField(
                      // title: 'Username',
                      prefixIconData: Icons.person,
                      hintText: 'Username',
                      controller: username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length > 100) {
                          return "Password can't to be larger than 100 letter";
                        }
                        if (value.length < 4) {
                          return "Username can't to be less than 4 letter";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    // Password Field.
                    AuthField(
                      // title: 'Password',
                      hintText: 'password',
                      prefixIconData: Icons.lock,
                      controller: password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 5) {
                          return 'Password should be at least 5 characters long';
                        }
                        return null;
                      },
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                    ),
                    // button login
                    const SizedBox(height: 15),
                    PrimaryButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          login();
                          password.clear();
                          username.clear();
                        }
                      },
                      text: 'LOGIN',
                    ),
                    //Sign up button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                            onPressed: () {
                              //Navigate to sign up
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()));
                            },
                            child: const Text(
                              "SIGN UP",
                              style: TextStyle(color: AppColors.kPrimary),
                            ))
                      ],
                    ),

                    // We will disable this message in default, when user and pass is incorrect we will trigger this message to user
                    isLoginTrue
                        ? const Text(
                            "Username or password is incorrect",
                            style: TextStyle(color: Colors.red),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
