import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_chat/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login

  // register
  Future registerUser(String name, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if(user!=null){
        await DatabaseService(uid: user.uid).updateUserData(name, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign out

}
