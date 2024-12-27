import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gorins/presentation/auth/providers/auth_provider.dart';
import 'package:gorins/routes.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late AuthProvider authProvider;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  
  ///[isEmailInValid],[isNameInValid] and [isPasswordInValid] are used to track email,name and password validation status.
  ///Although [Validator] helps in valdiation,some complexity in [CustomTextField] UI has caused the usage of these flags.
  bool isEmailInValid = false;
  bool isNameInValid = false;
  bool isPasswordInValid = false;
  @override
  void didChangeDependencies() {
    authProvider = Provider.of<AuthProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign up with email",
                  style: AppTextStyle.heading,
                ),
                20.0.h,  
                GestureDetector(
                  onTap: authProvider
                      .pickProfileImage, /// Function to pick image on tap
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.shadow,
                    backgroundImage: authProvider.selectedImage != null
                        ? FileImage(authProvider.selectedImage!)
                        : null,
                    child: authProvider.isImageUploading
                        ? const CircularProgressIndicator()
                        : authProvider.selectedImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                  ),
                ),
                15.0.h,  
                CustomTextField(
                    controller: nameController,
                    hasErrorCallback: (hasError) {
                      /// Update the error STATUS
                      isNameInValid = hasError;
                    },
                    hintText: "Name",
                    validator: (v) {
                      return Validator.validateField(v, "Name");
                    }),
                15.0.h, // Space between text fields
                CustomTextField(
                  hasErrorCallback: (hasError) {
                    isEmailInValid = hasError;
                  },
                  controller: emailController,
                  validator: Validator.validateEmail,
                  hintText: "Email",
                ),
                15.0.h,
                CustomTextField(
                  hasErrorCallback: (hasError) {
                    isPasswordInValid = hasError;
                  },
                  controller: passwordController,
                  hintText: "Password",
                  validator: Validator.validatePassword,
                  isPassword: true,
                ),
                30.0.h,

                /// [Signup] Button
                authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: "Sign Up",
                        onPressed: () {
                             if (formKey.currentState!.validate() &&
                              !isEmailInValid &&
                              !isNameInValid &&
                              !isPasswordInValid) {
                            authProvider.signUp(
                                email: emailController.text,       /// Email input
                                password: passwordController.text, /// Password input
                                username: nameController.text,     /// Name input
                                context: context);                 /// Navigation context
                          }
                        },
                      ),
                30.0.h, // Space below the button

                const Text(
                  "Already have an account? ",
                  style: AppTextStyle.heading,
                ),

                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.login);
                    // Navigate to login screen
                  },
                  child: const Text(
                    "Login",
                    style: AppTextStyle.bodyXL600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
