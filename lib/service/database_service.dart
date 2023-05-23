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

  getChats(String spaceId) async {
    return spaceCollection.doc(spaceId).collection("messages").orderBy("time").snapshots();
  }

  Future getSpaceAdmin(String spaceId) async {
    DocumentReference documentReference = spaceCollection.doc(spaceId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['admin'];
  }

  getSpaceMembers(String spaceId) async {
    return spaceCollection.doc(spaceId).snapshots();
  }

  searchByName(String spaceName){
    return spaceCollection.where('spaceName', isEqualTo: spaceName).get();
  }

  Future<bool> isUserJoined(String spaceName, String spaceId, String name) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> spaces = await documentSnapshot['spaces'];
    if (spaces.contains("${spaceId}_$spaceName")) {
      return true;
    }
    return false;
  }

  Future toggleGroupJoin(String spaceId, String name, String spaceName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference spaceDocumentReference = spaceCollection.doc(spaceId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> spaces = await documentSnapshot['spaces'];
    if (spaces.contains("${spaceId}_$spaceName")) {
      await userDocumentReference.update({
        "spaces": FieldValue.arrayRemove(["${spaceId}_$spaceName"])
      });
      await spaceDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$name"])
      });
    } else {
      await userDocumentReference.update({
        "spaces": FieldValue.arrayUnion(["${spaceId}_$spaceName"])
      });
      await spaceDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$name"])
      });
    }
  }

}
