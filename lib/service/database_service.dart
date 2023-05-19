import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference spaceCollection =
      FirebaseFirestore.instance.collection("spaces");

  Future saveUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      "name": name,
      "email": email,
      "spaces": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  getUserSpaces() async {
    return userCollection.doc(uid).snapshots();
  }

  Future createSpace(String name, String id, String spaceName) async {
    DocumentReference spaceDocumentReference = await spaceCollection.add({
      "spaceName": spaceName,
      "spaceIcon": "",
      "spaceId": "",
      "admin": "${id}_$name",
      "members": [],
      "recentMessage": "",
      "recentMessageSender": "",
    });
    await spaceDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$name"]),
      "spaceId": spaceDocumentReference.id,
    });
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "spaces":
          FieldValue.arrayUnion(["${spaceDocumentReference.id}_$spaceName"])
    });
  }
}
