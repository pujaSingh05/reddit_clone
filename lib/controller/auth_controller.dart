import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/repository/auth_repository.dart';


//provider for auth controller


final authControllerProvider =  Provider<AuthController>((ref) => AuthController(authRepository: ref.read(authRepositoryProvider)));

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository;

  void SignInWithGoogle() {
    _authRepository.SignInWithGoogle();
  }

}