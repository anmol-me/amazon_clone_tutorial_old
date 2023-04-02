import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/common/widgets/custom_button.dart';
import 'package:flutter_amazon_clone_tutorial_master/common/widgets/custom_textfield.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/auth_service.dart';

enum AuthType { signIn, signUp }

final authTypeProvider = StateProvider((ref) {
  return AuthType.signUp;
});

class AuthScreen extends HookConsumerWidget {
  static const routeNamed = '/auth-screen';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authTypeController = ref.read(authTypeProvider.notifier);
    final authType = ref.watch(authTypeProvider);
    final authService = ref.watch(authServiceProvider);

    final signUpFormKey = GlobalKey<FormState>();
    final signInFormKey = GlobalKey<FormState>();

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    void signUp() {
      authService.signUpUser(
        context: context,
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    }

    void signIn() {
      authService.signInUser(
        context: context,
        email: emailController.text,
        password: passwordController.text,
      );
    }

    final scaffoldKeyAuth = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      key: scaffoldKeyAuth,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                // textAlign: TextAlign.start,
              ),

              /// Create Account Section

              ListTile(
                tileColor: authType == AuthType.signUp
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.greyBackgroundColor,
                title: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: AuthType.signUp,
                  groupValue: authType,
                  onChanged: (AuthType? value) {
                    authTypeController.update((state) => value!);
                  },
                ),
              ),
              if (authType == AuthType.signUp)
                Container(
                  color: GlobalVariables.backgroundColor,
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Name',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Email',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'Sign Up',
                          onTap: () {
                            if (signUpFormKey.currentState!.validate()) {
                              signUp();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              /// Login Section

              ListTile(
                tileColor: authType == AuthType.signIn
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.greyBackgroundColor,
                title: const Text(
                  'Sign-In.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: AuthType.signIn,
                  groupValue: authType,
                  onChanged: (AuthType? value) {
                    authTypeController.update((state) => value!);
                  },
                ),
              ),
              if (authType == AuthType.signIn)
                Container(
                  color: GlobalVariables.backgroundColor,
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: signInFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Email',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'Sign In',
                          onTap: () {
                            if (signInFormKey.currentState!.validate()) {
                              signIn();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
