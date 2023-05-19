import 'package:flutter/material.dart';
import 'package:space_chat/pages/space_page.dart';
import 'package:space_chat/widgets/widgets.dart';

class SpaceTile extends StatefulWidget {
  final String name;
  final String spaceId;
  final String spaceName;

  const SpaceTile({
    required this.name,
    required this.spaceId,
    required this.spaceName,
    Key? key,
  }) : super(key: key);

  @override
  State<SpaceTile> createState() => _SpaceTileState();
}

class _SpaceTileState extends State<SpaceTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            SpacePage(
              name: widget.name,
              spaceId: widget.spaceId,
              spaceName: widget.spaceName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.spaceName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.spaceName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the space as ${widget.name}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}