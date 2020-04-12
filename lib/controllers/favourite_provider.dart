import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/controllers/auth_provider.dart';

class FavouriteProvider{
  final _firestore = Firestore.instance;
  final _auth = AuthProvider();

  ///This method will add or remove favourite items from firestore
  Future<void> addOrRemoveFavourite(int id) async {
    final user = await _auth.getUser();
    _firestore.runTransaction((transaction)async {
      DocumentSnapshot snapshot = await _firestore.collection("user").document(user.uid).get();
      var doc = snapshot.data;
      if(doc['favourite']== null){
        await transaction.update(snapshot.reference, <String, dynamic>{
          'favourite': FieldValue.arrayUnion([id])
        });
      }else if (doc['favourite'].contains(id)) {
        await transaction.update(snapshot.reference, <String, dynamic>{
          'favourite': FieldValue.arrayRemove([id])
        });
      } else {
        await transaction.update(snapshot.reference, <String, dynamic>{
          'favourite': FieldValue.arrayUnion([id])
        });
      }

    });
  }

  Future<List> getFavouriteList() async {
    final user = await _auth.getUser();
    DocumentSnapshot snapshot = await  _firestore.collection("user").document(user.uid).get();
    return snapshot.data["favourite"];
  }

}