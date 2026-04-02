import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constant.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/models/user_model.dart';




final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(firestore: ref.watch(firestoreProvider), auth: ref.watch(authProvider), googleSignIn: ref.watch(googleSignInProvider),),);

class AuthRepository{
    final FirebaseFirestore _firestore;
    final FirebaseAuth _auth;
    final GoogleSignIn _googleSignIn;


    AuthRepository({required FirebaseFirestore firestore, required FirebaseAuth auth, required GoogleSignIn googleSignIn})
        : _firestore = firestore,
          _auth = auth,
          _googleSignIn = googleSignIn;

          CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

    FutureEither<UserModel> signInWithGoogle() async {
        try{
            final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
            
            if (googleUser == null) {
              return Left(Failure('Sign in was cancelled'));
            }

            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

            final credential = GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            );

            UserCredential userCredential = await _auth.signInWithCredential(credential);

            UserModel userModel = UserModel(name: userCredential.user!.displayName??'No name', profilePic: userCredential.user!.photoURL??Constants.avatarDefault, banner: Constants.bannerDefault, uid: userCredential.user!.uid,isAuthenticated: true, karma: 0, awards: []);

            if(userCredential.additionalUserInfo!.isNewUser){
          await _users.doc(userCredential.user!.uid).set(
            userModel.toMap()
           );
            }else{
              userModel = await getUserData(userCredential.user!.uid).first;
            }

            return Right(userModel);
        } on FirebaseException catch (e) {
          return Left(Failure(e.message ?? 'Firebase error'));
        } catch (e) {
            return Left(Failure(e.toString()));
        }
    }

    Stream<UserModel> getUserData(String uid){
      return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
    }
}


  