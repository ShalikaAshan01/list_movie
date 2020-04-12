import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/controllers/auth_provider.dart';
import 'package:popcorn/models/firebase_movie_model.dart';

class FavouriteProvider{
  final _firestore = Firestore.instance;
  final _auth = AuthProvider();

  ///This method will add or remove favourite items from firestore
  Future<void> addOrRemoveFavourite(FirebaseMovieModel movie) async {
    final user = await _auth.getUser();
    final id = movie.movieId;
    _firestore.runTransaction((transaction)async {
      QuerySnapshot snapshot = await _firestore.collection("user").document(user.uid).collection("Movies").where('movieId', isEqualTo: id).getDocuments();
      if(snapshot.documents.length == 0){
        //add new collection
        _firestore
            .collection('user')
            .document(user.uid)
            .collection("Movies")
            .add(movie.toMap());
        return;
      }
      else{
        final value = snapshot.documents.first;
        //if movie is not favourite of watched remove it from db
        if(value.data["watched"]==false && !movie.favourite){
          value.reference.delete();
          return;
        }else{
          value.reference.updateData({"favourite":movie.favourite});
        }
      }

    });
  }

  Stream<QuerySnapshot> getFavouriteList(String user){
    return _firestore.collection("user").document(user).collection("Movies").where('favourite', isEqualTo: true).snapshots();
  }

}