import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Future<String> signIn(String email,String password);
  Future<void> signOut();
  Future<FirebaseUser> getCurrentUser();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;


  Future<String> signIn(String email, String password) async {
    AuthResult result=await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user=result.user;
    return user.uid;
  }

  Future<void> signOut() {
    // TODO: implement signOut
    return _firebaseAuth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser user=await _firebaseAuth.currentUser();
    return user;
  }

}