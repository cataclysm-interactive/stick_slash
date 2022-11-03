//The page that shows the actual binder
import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';

class BinderPage extends StatefulWidget {
  const BinderPage({super.key, required this.binder, required this.title});

  final Map<String, bool> binder;
  final String title;

  @override
  State<BinderPage> createState() => _BinderPageState();
}

class _BinderPageState extends State<BinderPage> {
  String title = "";
  String year = "";

  @override
  void initState() {
    title = widget.title;

    widget.binder.remove("name");
    widget.binder.remove("year");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final directory = await getApplicationDocumentsDirectory();
        Directory finalPath = Directory("${directory.path}/Binders");
        if (finalPath.existsSync() == false) {
          await finalPath.create();
        }
        File file = File("${directory.path}/Binders/$title.json");
        await file.writeAsString(jsonEncode(widget.binder));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
        ),
        body: ListView(
          //TODO: Implement ExpansionLists to sort by set (Flow of Time, etc.)
          children: widget.binder.keys.map<ListTile>(
            (e) {
              return ListTile(
                title: Text(e),
                trailing: Checkbox(
                  value: widget.binder[e],
                  onChanged: ((value) {
                    widget.binder[e] = value!;
                    setState(() {});
                  }),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
