import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth{
  Future<FirebaseUser> signIn(String email,String password);
  Future<FirebaseUser> signInGoogle();
  Future<void> signOut();
  Future<FirebaseUser> getCurrentUser();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;


  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result=await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user=result.user;
    return user;
  }

  Future <FirebaseUser> signInGoogle() async{
    try{
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if(account == null )
        return null;
      AuthResult res = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));

      if(res.user == null)
        return null;

      //print(res.user);
      return res.user;


    }catch(e){
      print("Error logging with google");
      return null;
    }
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