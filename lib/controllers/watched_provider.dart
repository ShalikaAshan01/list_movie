import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/models/firebase_movie_model.dart';
import 'package:popcorn/models/popular_movie_model.dart';

import 'auth_provider.dart';

class WatchedProvider{

  final _firestore = Firestore.instance;
  final _auth = AuthProvider();
  Stream moviStream;

  addToWatchedMovies(FirebaseMovieModel movie) async{
    final user = await _auth.getUser();
    _firestore
        .collection('user')
        .document(user.uid)
        .collection("Movies").where('movieId', isEqualTo: movie.movieId).getDocuments().then((value)  {
          if(value.documents.length == 0){
              _firestore
                .collection('user')
                .document(user.uid)
                .collection("Movies")
                .add(movie.toMap()).then((value) => null);
          }else {
              _firestore
                .runTransaction((transaction) async =>
                await transaction.update(value.documents[0].reference, { 'watched': true })
              );
          }
        });
  }

  removeWatchedMovies(movieID) async{
    final user = await _auth.getUser();
    _firestore
        .collection('user')
        .document(user.uid)
        .collection("Movies").where('movieId', isEqualTo: movieID).getDocuments().then((value){
          if(value.documents[0].data["watched"]==true &&value.documents[0].data["favourite"]==false){
            _firestore
                .runTransaction((transaction) async {
              await transaction.delete(value.documents[0].reference);
            });
          }else{
            _firestore
                .runTransaction((transaction) async =>
            await transaction.update(value.documents[0].reference, { 'watched': false })
            );
          }
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