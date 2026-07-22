

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> bookAppointment({
    required String userId,
    required String doctorName,
    required String specialty,
    required String date,
    required String time,
  }) async {
    await _firestore.collection("Appoinments").add({
      "userId": userId,
      "doctorName": doctorName,
      "speciality": specialty,
      "date": date,
      "time": time,
      "status": "Booked",
      "createdAt": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getAppointments(String userId) {
    return _firestore
        .collection("Appoinments")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }
 Stream<QuerySnapshot> getDoctors() {
  return _firestore.collection("123456").snapshots();
}
Future<void> rescheduleAppointment({
  required String id,
  required String date,
  required String time,
}) async {
  await _firestore
      .collection("Appoinments")
      .doc(id)
      .update({
    "date": date,
    "time": time,
  });
}

  Future<void> cancelAppointment(String id) async {
    await _firestore.collection("Appoinments").doc(id).delete();
  }
  Future<void> submitRating({
  required String doctorId,
  required String userId,
  required double rating,
  required String review,
}) async {
  await _firestore
      .collection("123456")
      .doc(doctorId)
      .collection("reviews")
      .doc(userId)
      .set({
    "userId": userId,
    "rating": rating,
    "review": review,
    "createdAt": Timestamp.now(),
  });
}
  
  Future<String> getReviews({
    required String docId,
    required String userId,
  })async{
    final doc = await _firestore.collection('123456').doc(docId).collection('reviews').doc(userId).get();
    if(!doc.exists){
      return 'No Reviews Yet';

    }
    return doc['review'] ??'';

  }
  Future<double> getAverageRating(String doctorId) async {
  final snapshot = await _firestore
      .collection("123456")
      .doc(doctorId)
      .collection("reviews")
      .get();

  if (snapshot.docs.isEmpty) {
    return 0.0;
  }

  double total = 0;

  for (var doc in snapshot.docs) {
    total += (doc["rating"] as num).toDouble();
  }

  return total / snapshot.docs.length;
}
Future<int> getTotalReviews(String doctorId)async{
  final snapshot = await _firestore.collection('123456').doc(doctorId).collection('reviews').get();
  return snapshot.docs.length;
  
}
Future<void> addfavorites({
  required String userId,
  required String doctorId,
  required Map<String,dynamic> doctor,

})async{
  await _firestore.collection('users').doc(userId).collection('favorites').doc(doctorId).set({
     "name": doctor["name"],
    "speciality": doctor["speciality"],
    "experience": doctor["experience"],
    "fee": doctor["fee"],
    "image": doctor["image"],
    "description": doctor["description"],
    "createdAt": Timestamp.now(),
  });

}
Future<void> removefavorites({
  required String doctorId,
  required String userId,
})async{
  await _firestore.collection('users').doc(userId).collection('favorites').doc(doctorId).delete();

}
Future<bool> isfavorite({
  required String doctorId,
   required String  userId,
  })async{
     final doc = await _firestore.collection('users').doc(userId).collection('favorites').doc(doctorId).get();
  return doc.exists;

}
// Get all Favorites 
Stream<QuerySnapshot> getfavorites(String userId){
  return _firestore.collection('users').doc(userId).collection('favorites').orderBy('createdAt',descending: true).snapshots();

}
  



  }

  // 123456 is the collection for the doctors
// Appoinments is the collection for the appoinment booking
// users  stores infomration specific to the users like favorites 

