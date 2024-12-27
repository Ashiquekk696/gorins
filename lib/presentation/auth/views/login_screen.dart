import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gorins/presentation/auth/providers/auth_provider.dart';
import 'package:gorins/routes.dart';
import 'package:provider/provider.dart';

/// The LoginScreen widget is a StatefulWidget responsible for building the login UI.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
/// State class for LoginScreen that manages form state and user interaction logic.
class _LoginScreenState extends State<LoginScreen> {
  @override
  void didChangeDependencies() {
    authProvider = Provider.of<AuthProvider>(context);
    super.didChangeDependencies();
  }

  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AuthProvider authProvider;

  ///[isEmailInValid] and [isPasswordInValid] are used to track email and password validation status.
  ///Although [Validator] helps in valdiation,some complexity in [CustomTextField] UI has caused the usage of these flags.
  bool isEmailInValid = false;  // Flag to track email validation status
  bool isPasswordInValid = false;  // Flag to track PASSWORD validation status
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Title text at the top
              const Text(
                "Login with email",
                style: AppTextStyle.heading,
              ),
              10.0.h,  
 
              CustomTextField(
                controller: emailController,
                validator: Validator.validateEmail,
                hintText: "Email",
                hasErrorCallback: (v) {
                  isEmailInValid = v;
                },
              ),
              15.0.h,  
              CustomTextField(
                hasErrorCallback: (v) {
                  isPasswordInValid = v;
                },
                validator: (v) {
                  return Validator.validateField(v, "Password");
                },
                controller: passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              15.0.h,
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password ?",
                      style: AppTextStyle.bodyXL600),
                ),
              ),
              20.0.h,

              // [Login] Button
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: "Login",
                      onPressed: () { 
                        if (formKey.currentState!.validate() &&    // Validate form 
                            !isEmailInValid &&                    // Ensure email is valid
                            !isPasswordInValid) {                 // Ensure password is valid
                          authProvider.signIn(
                            emailController.text.trim(),          // Trimmed email input
                            passwordController.text.trim(),       // Trimmed password input
                            context,                             // Context for navigation
                          );
                        }
                      },
                    ),
              40.0.h,
              const Text(
                "Don't have an account? ",
                style: AppTextStyle.heading,
              ),

              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.signup);
                  },
                  child: const Text("Sign Up", style: AppTextStyle.bodyXL600)),
            ],
          ),
        ),
      ),
    );
  }
}
