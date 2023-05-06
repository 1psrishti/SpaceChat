import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_chat/helper/helper_functions.dart';
import 'package:space_chat/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginUser(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;
      if(user!=null){
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUser(String name, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if(user!=null){
        await DatabaseService(uid: user.uid).saveUserData(name, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign out
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserName("");
      await HelperFunctions.saveUserEmail("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

}
