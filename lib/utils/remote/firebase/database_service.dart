import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
// Add Employ Details
  Future<void> addEmployDetails(Map<String, dynamic> employinfoMap) async {
    employinfoMap['CreatedAt'] = FieldValue.serverTimestamp();
    await firestore.collection("Employee").add(employinfoMap);
  }

  //fetch all employ details
  Stream<QuerySnapshot> FetchemployDetails() {
    return firestore
        .collection('Employee')
        // .where('age', isGreaterThan: 18) // Filters age greater than 18
        .orderBy('CreatedAt',
            descending: true) // Orders by CreatedAt in descending order
        .snapshots();
  }

  //Update Employ Details
  Future<void> updateEmploy(
      String docId, Map<String, dynamic> updatinfo) async {
    await firestore.collection("Employee").doc(docId).update(updatinfo);
  }
  //Detete employ Details ;

  void deleteEmploy(String docId) {
    firestore.collection("Employee").doc(docId).delete();
  }
}
