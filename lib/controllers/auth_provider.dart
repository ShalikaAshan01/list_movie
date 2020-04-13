import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

///This is provide the all firebase authentications.
class AuthProvider {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  /// Provides a login method or registration method according to user's email
  /// If email is already registered then do the firebase login, otherwise
  /// create a new user account
  Future<void> loginWithEmail(String email, String password) async {
    email = email.trim();
    //check user is exist in firestore or not
    final documentSnapshot = await _firestore
        .collection("user")
        .where("email", isEqualTo: email)
        .getDocuments();

    //if document snapshot length is 1 it means user is already exist,So call
    //the login function, otherwise call the register function
    AuthResult authResult;
    if (documentSnapshot.documents.length > 0) {
      authResult = await _login(email, password);
    } else {
      authResult = await _signUp(email, password);
    }

    ///send verification mail to user,if his email is not verified
    if (!authResult.user.isEmailVerified) {
      await authResult.user.sendEmailVerification();
    }
  }

  /// Provides a method for login, this method will return Firebase AuthResult
  Future<AuthResult> _login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  /// Provide a method for signup, This method will create new collection in firestore.
  /// This method also return AuthResult object
  Future<AuthResult> _signUp(String email, String password) async {
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore
        .collection("user")
        .document(authResult.user.uid)
        .setData({"email": email});
    return authResult;
  }

  /// Provides a method for reset the user's password using firebase
  Future<void> resetPassword(String email) async {
    email = email.trim();
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Provide a already logged firebase user's object.
  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  /// Provide a method for update user's display name.
  Future<void> updateDisplayName(String name) async {
    final user = await getUser();
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await user.updateProfile(userUpdateInfo);
  }

  /// Provide a method for the user's for log out from the app
  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("darkMode", false);
  }
}
