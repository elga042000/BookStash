import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceHelper {

  //create account with email and password
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

//login using email and password

  static Future<String> loginWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Successfull";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // logout
  static Future logout(
     ) async {
    try {
      await FirebaseAuth.instance
          .signOut();

    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // check user is logged in or not

  static Future<bool> isUserLoggedIn(
      ) async {
    var currentUser=FirebaseAuth.instance.currentUser;
      return currentUser!=null?true:false;

  }

}
