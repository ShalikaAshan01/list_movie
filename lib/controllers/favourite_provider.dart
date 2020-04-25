import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/controllers/auth_provider.dart';
import 'package:popcorn/models/firebase_movie_model.dart';

/// This entry point for accessing firestore favourites movies for the specific
/// user( Logged user)
class FavouriteProvider {
  final _firestore = Firestore.instance;
  final _auth = AuthProvider();

  /// Provides a method for add or remove favourite items from firestore
  Future<void> addOrRemoveFavourite(FirebaseMovieModel movie) async {
    final user = await _auth.getUser();
    final id = movie.movieId;

    //run the firestore transaction
    _firestore.runTransaction((transaction) async {
      QuerySnapshot snapshot = await _firestore
          .collection("user")
          .document(user.uid)
          .collection("Movies")
          .where('movieId', isEqualTo: id)
          .getDocuments();
      // if movie is not in the firestore collection then add it.
      if (snapshot.documents.length == 0) {
        //add new collection
        _firestore
            .collection('user')
            .document(user.uid)
            .collection("Movies")
            .add(movie.toMap());
        return;
      } else {
        final value = snapshot.documents.first;
        //if movie is not favourite of watched remove it from db
        if (value.data["watched"] == false && !movie.favourite) {
          value.reference.delete();
          return;
        } else {
          value.reference.updateData({"favourite": movie.favourite});
        }
      }
    });
  }

  /// Provides a realtime(stream) method for accessing specific user's favourite movie
  /// list
  Stream<QuerySnapshot> getFavouriteList(String user) {
    return _firestore
        .collection("user")
        .document(user)
        .collection("Movies")
        .where('favourite', isEqualTo: true)
        .snapshots();
  }
}
