import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constant.dart';
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

    void SignInWithGoogle() async {
        try{
            final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

            final googleAuth = googleUser.authentication;

            final credential = GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
            );

            UserCredential userCredential = await _auth.signInWithCredential(credential);

            if(userCredential.additionalUserInfo!.isNewUser){
            UserModel userModel = UserModel(name: userCredential.user!.displayName??'No name', profilePic: userCredential.user!.photoURL??Constants.avatarDefault, banner: Constants.bannerDefault, uid: userCredential.user!.uid,isAuthenticated: true, karma: 0, awards: []);
          await _users.doc(userCredential.user!.uid).set(
            userModel.toMap()
           );
            }
        }catch(e){
            print(e);
        }
    }
}


  