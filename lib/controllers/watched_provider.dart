import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/models/firebase_movie_model.dart';

import 'auth_provider.dart';

/// This entry point used for accessing specific user's watch movie list
class WatchedProvider {
  final _firestore = Firestore.instance;
  final _auth = AuthProvider();
  Stream moviStream;

  /// Provide a method for adding watched movie to user's watch list
  addToWatchedMovies(FirebaseMovieModel movie) async {
    final user = await _auth.getUser();
    _firestore
        .collection('user')
        .document(user.uid)
        .collection("Movies")
        .where('movieId', isEqualTo: movie.movieId)
        .getDocuments()
        .then((value) {
      if (value.documents.length == 0) {
        _firestore
            .collection('user')
            .document(user.uid)
            .collection("Movies")
            .add(movie.toMap())
            .then((value) => null);
      } else {
        _firestore.runTransaction((transaction) async => await transaction
            .update(value.documents[0].reference, {'watched': true}));
      }
    });
  }

  /// Provides a method for removing movie from existing watch list
  removeWatchedMovies(movieID) async {
    final user = await _auth.getUser().then((_user) =>
        _firestore
            .collection('user')
            .document(_user.uid)
            .collection("Movies")
            .where('movieId', isEqualTo: movieID)
            .getDocuments()
            .then((value) {
          if(value.documents.length != 0 ){
            if (value.documents.first.data["favourite"] == false ) {
              _firestore.runTransaction((transaction) async {
                await transaction.delete(value.documents.first.reference);
                print(movieID);
              });
            } else {
              _firestore.runTransaction((transaction) async => await transaction
                  .update(value.documents.first.reference, {'watched': false}));
            }
          }else{
            print(value.documents.length);
            print(_user.uid);
            print(movieID);
          }
        })
    );

  }

//  Future<void> removeWatched(movieID) async {
//    final user = await _auth.getUser();
//    final id = movieID;
//    print(id);
//    //run the firestore transaction
//    _firestore.runTransaction((transaction) async {
//      QuerySnapshot snapshot = await _firestore
//          .collection("user")
//          .document(user.uid)
//          .collection("Movies")
//          .where('movieId', isEqualTo: id)
//          .getDocuments();
//      // if movie is not in the firestore collection then add it.
//      if (snapshot.documents.length == 0) {
//        return;
//      } else {
//        final value = snapshot.documents.first;
//        //if movie is favourite
//        if (value.data["favourite"] == false || value.data["favourite"] == null) {
//          value.reference.delete();
//          return;
//        } else {
//          print("object");
//          value.reference.updateData({"watched": false});
//        }
//      }
//    });
//  }

  /// Provides a method for get one time watch list for the logged user
  Future<QuerySnapshot> getWatchedMovies() {
    Future<QuerySnapshot> snapshot = _auth.getUser().then((value) {
      return _firestore
          .collection('user')
          .document(value.uid)
          .collection('Movies')
          .where('watched', isEqualTo: true)
          .getDocuments();
    });
    return snapshot;
  }

  ///Provides a method for get logged user watch list as a stream
  getWatchedMovies2() async {
    Stream<QuerySnapshot> snapshot = await _auth.getUser().then((value) async {
      this.moviStream = _firestore
          .collection('user')
          .document(value.uid)
          .collection('Movies')
          .where('watched', isEqualTo: true)
          .getDocuments()
          .asStream();
      return null;
    });

    return snapshot;
  }
  ///Provides a method for set the stream for watched movie list
  setMovieStream() {
    this.getWatchedMovies2();
    return this.moviStream;
  }

  /// Provides a realtime(stream) method for accessing specific user's favourite movie
  /// list
  Stream<QuerySnapshot> getWatchedList(String user) {
    return _firestore
        .collection("user")
        .document(user)
        .collection("Movies")
        .where('watched', isEqualTo: true)
        .snapshots();
  }

}
