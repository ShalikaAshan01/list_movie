import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  ///This method used for login,register
  Future<void> loginWithEmail(String email, String password) async {
    email = email.trim();
    //check user exsist or not
    final documentSnapshot = await _firestore.collection("user").where("email",isEqualTo: email).getDocuments();

    //if document snapshot return 1 list do login
    AuthResult authResult;
    if(documentSnapshot.documents.length> 0){
      print("Login now");
      authResult = await _login(email, password);
    }else{
      print("Signup now");
      authResult = await _signUp(email, password);
    }

    ///send email if  user's email is not verified
    if(!authResult.user.isEmailVerified){
      print("send verified");
      await authResult.user.sendEmailVerification();
    }else{
      print("already verified");
    }
  }

  /// THis method will return auth result logged user
  Future<AuthResult> _login(String email,String password)async{
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  ///This method used for create new user
  Future<AuthResult> _signUp(String email,String password)async{

    AuthResult authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection("user").document(authResult.user.uid).setData({
      "email":email
    });
    return authResult;
  }

  ///This method is used for rest the user password
  Future<void> resetPassword(String email)async{
    email = email.trim();
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> getUser(){
    return _auth.currentUser();
  }

}
