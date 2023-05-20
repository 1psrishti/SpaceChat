import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:space_chat/pages/space_info_page.dart';
import 'package:space_chat/service/database_service.dart';
import 'package:space_chat/shared/constants.dart';
import 'package:space_chat/widgets/widgets.dart';

class SpacePage extends StatefulWidget {
  final String name;
  final String spaceId;
  final String spaceName;

  const SpacePage({
    required this.name,
    required this.spaceId,
    required this.spaceName,
    Key? key,
  }) : super(key: key);

  @override
  State<SpacePage> createState() => _SpacePageState();
}

class _SpacePageState extends State<SpacePage> {
  String admin = "";
  Stream<QuerySnapshot>? chats;

  getChatAndAdmin(){
    DatabaseService().getChats(widget.spaceId).then((val){
      setState((){
        chats = val;
      });
    });
    DatabaseService().getSpaceAdmin(widget.spaceId).then((val){
      admin = val;
    });
  }

  @override
  void initState() {
    getChatAndAdmin();
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
        title: Text(
          widget.spaceName,
          style: const TextStyle(
            fontFamily: "NanumPenScript",
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              nextScreen(context, SpaceInfoPage(
                spaceId: widget.spaceId,
                spaceName: widget.spaceName,
                admin: admin,
              ));
            },
            icon: Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
    );
  }
}
