import 'package:flutter/material.dart';
import 'package:quiz/Authtentication/login.dart';
import 'package:quiz/JsonModels/users.dart';
import 'package:quiz/SQLite/sqlite.dart';

import '../_constant/button.dart';
import '../_constant/color.dart';
import '../_constant/snackbar.dart';
import '../_constant/textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();

  bool isVisible = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confpasswordController = TextEditingController();

  DatabaseHelper dbHelper = DatabaseHelper();

  void _register(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confpasswordController.text.trim();

    bool userExists = await dbHelper.doesUserExist(username);

    if (userExists) {
      CustomSnackBar.show(
        context,
        message: 'Username already existe',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
    } else {
      final db = DatabaseHelper();
      db
          .signup(Users(usrName: username, usrPassword: password))
          .whenComplete(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
      CustomSnackBar.show(
        context,
        message: 'Registration successful',
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //SingleChildScrollView to have an scrol in the screen
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //We will copy the previous textfield we designed to avoid time consuming

                    const Text('Let’s Sign you in',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 55),

                    //As we assigned our controller to the textformfields

                    AuthField(
                      // title: 'Username',
                      prefixIconData: Icons.person,
                      hintText: 'Username',
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length > 100) {
                          return "Username can't to be larger than 100 letter";
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
                      hintText: 'Password',
                      prefixIconData: Icons.lock,
                      controller: _passwordController,
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
                    const SizedBox(height: 15),
                    //password confirmed
                    AuthField(
                      // title: 'confirmation Password',
                      hintText: 'Confim Password',
                      prefixIconData: Icons.lock,
                      controller: _confpasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (_passwordController.text !=
                            _confpasswordController.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                    ),

                    const SizedBox(height: 15),
                    //Login button
                    PrimaryButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          _register(context);
                          _usernameController.clear();
                          _confpasswordController.clear();
                          _passwordController.clear();
                        }
                      },
                      text: 'SIGN UP',
                    ),

                    //Sign up button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              //Navigate to sign up
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: AppColors.kPrimary),
                            ))
                      ],
                    )
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
