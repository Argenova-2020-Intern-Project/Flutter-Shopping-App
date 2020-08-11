import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/services/auth-errors.dart';
import 'package:Intern/main.dart' as ref;


class AuthService{
  AuthResultStatus _singInStat;
  AuthResultStatus _signUpStat;
  AuthResultStatus _passResetStat;

  Future<AuthResultStatus> signIn({email, pass}) async {
    try {
      AuthResult result = await ref.auth
          .signInWithEmailAndPassword(email: email, password: pass);
      if (result.user != null) {
        _singInStat = AuthResultStatus.successful;
      } else {
        _singInStat = AuthResultStatus.undefined;
      }
    } catch (e) {
      _singInStat = AuthExceptionHandler.handleException(e);
    }
    return _singInStat;
  }
  
  Future<AuthResultStatus> signUp({email, pass}) async {
    try {
      AuthResult result = (await ref.auth
          .createUserWithEmailAndPassword(email: email, password: pass));
      if (result.user != null) {
        _signUpStat = AuthResultStatus.successful;
      } else {
        _signUpStat = AuthResultStatus.undefined;
      }
      FirebaseUser user = result.user;
      await user.sendEmailVerification();
    } catch (e) {
      _signUpStat = AuthExceptionHandler.handleException(e);
    }
    return _signUpStat;
  }

  Future<AuthResultStatus> resetPassword({email}) async {
    try {
      await ref.auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _passResetStat = AuthExceptionHandler.handleException(e);
    }
    return _passResetStat;
  }
  
  Future signOut() async {
    try {
      return await ref.auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}