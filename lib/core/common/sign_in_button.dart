
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/controller/auth_controller.dart';
import 'package:reddit_clone/theme/palllete.dart/pallete.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});


  void signInWithGoogle(WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    authController.SignInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(onPressed: 
      ()=>
      signInWithGoogle(ref), icon: Image.asset(
        'assets/images/google.png',
        width: 35,
      ), label: const Text('Continue with Google',style: TextStyle(fontSize: 18),
      ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        )
      ),
      );
  }
}