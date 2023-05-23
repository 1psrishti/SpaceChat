import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:space_chat/helper/helper_functions.dart';
import 'package:space_chat/service/database_service.dart';
import 'package:space_chat/shared/constants.dart';
import 'package:space_chat/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  bool isJoined = false;
  String name = "";
  User? user;

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  getCurrentUserIdAndName() async {
    await HelperFunctions.getUserName().then((val) {
      setState(() {
        name = val!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    getCurrentUserIdAndName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Constants().appbarColor, Theme.of(context).primaryColor],
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Search Spaces",
          style: TextStyle(
            fontFamily: "NanumPenScript",
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search spaces...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      searchSpaces();
                    },
                    icon: const Icon(Icons.search_rounded),
                  ),
                ],
              ),
            ),
            _isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
                : spaceList(),
          ],
        ),
      ),
    );
  }

  searchSpaces() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  spaceList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return spaceTile(
                name,
                searchSnapshot!.docs[index]['spaceId'],
                searchSnapshot!.docs[index]['spaceName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  joinedOrNot(String name, String spaceId, String spaceName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(spaceName, spaceId, name)
        .then((val) {
      setState(() {
        isJoined = val;
      });
    });
  }

  Widget spaceTile(
      String name, String spaceId, String spaceName, String admin) {
    joinedOrNot(name, spaceId, spaceName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          spaceName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title:
          Text(spaceName, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid).toggleGroupJoin(spaceId, name, spaceName);
          if(isJoined){
            setState((){
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.green, "Entered a new space");
          } else {
            setState((){
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.green, "Left space");
          }
        },
        child: isJoined
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor.withOpacity(0.6),
                ),
                child:
                    const Text("LEAVE", style: TextStyle(color: Colors.white)),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor,
                ),
                child:
                    const Text("ENTER", style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }
}
