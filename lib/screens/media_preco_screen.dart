import 'package:acaide/components/drawer_item.dart';
import 'package:flutter/material.dart';

class MediaPrecoScreen extends StatefulWidget {
  const MediaPrecoScreen({Key? key}) : super(key: key);

  @override
  State<MediaPrecoScreen> createState() => _MediaPrecoScreenState();
}

class _MediaPrecoScreenState extends State<MediaPrecoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      drawer: Drawer(
        child: DrawerItem(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Preço Médio",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
        backgroundColor: Colors.purple[800],
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.announcement_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [],
      ),
    );
  }
}
