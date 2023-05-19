import 'package:flutter/material.dart';
import 'package:space_chat/pages/auth/login_page.dart';
import 'package:space_chat/pages/home_page.dart';
import 'package:space_chat/service/auth_service.dart';
import 'package:space_chat/shared/constants.dart';
import 'package:space_chat/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  String name;
  String email;

  ProfilePage({
    required this.name,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

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
          "profile",
          style: TextStyle(
            fontFamily: "NanumPenScript",
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 60),
          children: [
            const Icon(Icons.account_circle_rounded, size: 100),
            const SizedBox(height: 20),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            const Divider(),
            ListTile(
              onTap: (){
                nextScreen(context, const HomePage());
              },
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
              leading: const Icon(Icons.forum_rounded),
              title:
              const Text("SPACES", style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle_rounded, size: 100),
            // const SizedBox(height: 30),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Full Name : ",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "NanumPenScript",
                  ),
                ),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "NanumPenScript",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email : ",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "NanumPenScript",
                  ),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "NanumPenScript",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
