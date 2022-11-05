//The page that shows the actual binder
import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';

class BinderPage extends StatefulWidget {
  const BinderPage({super.key, required this.binder, required this.title});

  final List binder;
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
          children: widget.binder.map<ListTile>(
            (e) {
              return ListTile(
                title: Text(e["playerName"]),
                subtitle: Text(e["set"]),
                trailing: Checkbox(
                  value: e["owned"],
                  onChanged: ((value) {
                    e["owned"] = value!;
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
