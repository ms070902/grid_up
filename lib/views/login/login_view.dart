import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/auth/providers/auth_state_provider.dart';
import 'package:nexus/views/components/constants/app_colors.dart';
import 'package:nexus/views/constants/strings.dart';
import 'package:nexus/views/login/divider_with_margins.dart';
import 'package:nexus/views/login/facebook_button.dart';
import 'package:nexus/views/login/google_button.dart';
import 'package:nexus/views/login/login_view_signup_links.dart';

class LoginView extends ConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.appName,
          style: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                Strings.welcomeToAppName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.blueGrey,
                ),
              ),
              const DividerWithMargins(),
              Text(
                Strings.logIntoYourAccount,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.loginButtonColor,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
                onPressed:
                    ref.read(authStateProvider.notifier).loginWithFacebook,
                child: const FacebookButton(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.loginButtonColor,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
                onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
                child: const GoogleButton(),
              ),
              const DividerWithMargins(),
              const LoginViewSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }
}
