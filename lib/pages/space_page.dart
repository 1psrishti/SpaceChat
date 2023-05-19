import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
