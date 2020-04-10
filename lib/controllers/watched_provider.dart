import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_provider.dart';

class WatchedProvider{

  final _firestore = Firestore.instance;
  final _auth = AuthProvider();
  Stream moviStream;

  addToWatchedMovies(movieName, movieId, poster, vote, release) async{
    final user = await _auth.getUser();
    _firestore
        .collection('user')
        .document(user.uid)
        .collection("Movies").where('id', isEqualTo: movieId).getDocuments().then((value) => {
          if(value.documents.length == 0){
              _firestore
                .collection('user')
                .document(user.uid)
                .collection("Movies")
                .add({'title': movieName, 'id': movieId, 'poster': poster, 'favourite': false, 'watched': true, 'vote': vote, 'release': release }).then((value) => null)
          }else {
              _firestore
                .runTransaction((transaction) async =>
                await transaction.update(value.documents[0].reference, { 'watched': true })
              )

//            _firestore
//                .collection('user')
//                .document(user.uid)
//                .collection("Movies").document().
//                .where(field)
          }
        });
  }

  removeWatchedMovies(movieID) async{
    final user = await _auth.getUser();
    _firestore
        .collection('user')
        .document(user.uid)
        .collection("Movies").where('id', isEqualTo: movieID).getDocuments().then((value) => {
        _firestore
            .runTransaction((transaction) async {
        await transaction.delete(value.documents[0].reference);
        })
    });
  }

  Future<QuerySnapshot> getWatchedMovies()  {

    Future<QuerySnapshot> snapshot  =  _auth.getUser().then((value) {
      return    _firestore.collection('user').document(value.uid)
          .collection('Movies').where('watched', isEqualTo: true )
          .getDocuments();

    });

//      Future<QuerySnapshot> snapshot = _firestore.collection('user').document(user.uid)
//          .collection('Movies').where('watched', isEqualTo: true )
//          .getDocuments();

//      Stream<dynamic> snapshot2 = _firestore.collection('user').document(user.uid)
//          .collection('Movies').where('watched', isEqualTo: true )
//          .snapshots();

      return snapshot;
  }

//  String getUid() {
//    return FirebaseAuth.instance.currentUser().then((value) => )
////    return user;
//  }

  getWatchedMovies2()  async{
    Stream<QuerySnapshot> snapshot  =  await _auth.getUser().then((value) async {
      this.moviStream =  _firestore.collection('user').document(value.uid)
          .collection('Movies').where('watched', isEqualTo: true )
          .getDocuments().asStream();
      return null;
    });

    return snapshot;
  }

  setMovieStream(){
    this.getWatchedMovies2();
    return this.moviStream;
  }

}