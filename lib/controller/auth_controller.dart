import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reddit_clone/core/util.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/repository/auth_repository.dart';


//provider for auth controller
final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider =  StateNotifierProvider<AuthController, bool>((ref) => AuthController(authRepository: ref.watch(authRepositoryProvider),
ref: ref),);


//state notifier for auth controller is responsible for handling the state of the user and also for calling the sign in method from the auth repository and updating the user provider with the user data.
class AuthController  extends StateNotifier<bool>{
  final AuthRepository _authRepository;
  final Ref _ref ;
  AuthController({required AuthRepository authRepository, required Ref ref}) : _authRepository = authRepository,
_ref = ref, super(false); //loading state is false initially




  void signInWithGoogle(BuildContext context) async{
    state = true;
  final user =  await  _authRepository.signInWithGoogle();
  state = false;
  user.fold((l)=>showSnackBar(context, l.message),(userModel) => _ref.read(userProvider.notifier).update((state) => userModel));
  }
}