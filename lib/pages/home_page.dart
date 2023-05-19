import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:space_chat/helper/helper_functions.dart';
import 'package:space_chat/pages/auth/login_page.dart';
import 'package:space_chat/pages/profile_page.dart';
import 'package:space_chat/pages/search_page.dart';
import 'package:space_chat/service/auth_service.dart';
import 'package:space_chat/service/database_service.dart';
import 'package:space_chat/shared/constants.dart';
import 'package:space_chat/widgets/space_tile.dart';
import 'package:space_chat/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  String email = "";
  Stream? spaces;
  bool _isLoading = false;
  String spaceName = "";
  AuthService authService = AuthService();

  getUserData() async {
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        name = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserSpaces()
        .then((snapshot) {
      setState(() {
        spaces = snapshot;
      });
    });
  }

  getSpaceId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  getSpaceName(String res){
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    getUserData();
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
          "SPACES",
          style: TextStyle(
            fontFamily: "NanumPenScript",
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, const SearchPage());
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 60),
          children: [
            const Icon(Icons.account_circle_rounded, size: 100),
            const SizedBox(height: 20),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
              leading: const Icon(Icons.forum_rounded),
              title:
                  const Text("SPACES", style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              onTap: () {
                nextScreen(context, ProfilePage(name: name, email: email));
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              leading: const Icon(Icons.account_circle_rounded),
              title:
                  const Text("PROFILE", style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Hold up!"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel_outlined,
                                color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(Icons.logout, color: Colors.green),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              leading: const Icon(Icons.logout),
              title:
                  const Text("LOGOUT", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
      body: spaceList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Create a new group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : TextField(
                  onChanged: (val){
                    setState((){
                      spaceName = val;
                    });
                  },
                  decoration: textInputDecoration,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if(spaceName != ""){
                    setState((){
                      _isLoading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createSpace(
                      name, FirebaseAuth.instance.currentUser!.uid, spaceName).whenComplete((){
                        _isLoading = false;
                    });
                    Navigator.pop(context);
                    showSnackBar(context, Colors.green, "A whole new space has been created!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                child: const Text("Create"),
              ),
            ],
          );
        });
  }

  spaceList() {
    return StreamBuilder(
      stream: spaces,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['spaces'] != null) {
            if (snapshot.data['spaces'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['spaces'].length,
                itemBuilder: (context, index){
                  // to get recently joined groups at the top
                  int reverseIndex = snapshot.data['spaces'].length - index - 1;
                  return SpaceTile(
                    name: snapshot.data['name'],
                    spaceId: getSpaceId(snapshot.data['spaces'][reverseIndex]),
                    spaceName: getSpaceName(snapshot.data['spaces'][reverseIndex]),
                  );
                },
              );
            } else {
              return noSpacesWidget();
            }
          } else {
            return noSpacesWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}
