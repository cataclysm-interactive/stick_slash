import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';
import "binder.dart";

const List<String> years = [
  "2015",
  "2016",
  "2017",
  "2018",
  "2019",
  "2020",
  "2021",
  "2021-Can",
  "2022"
];

class Binder extends StatefulWidget {
  const Binder({super.key});

  @override
  State<Binder> createState() => _BinderState();
}

class _BinderState extends State<Binder> {
  Dio dio = Dio();
  List<Map<String, bool>> binders = List.empty(growable: true);
  List<String> binderNames = [];

  String dropdownValue = years.first;
  String textboxValue = "";

  bool loading = false;
  bool loadedFromDisk = false;

  void loadBindersFromDisk() async {
    final dir = await getApplicationDocumentsDirectory();
    Directory binderDir = Directory("${dir.path}/Binders");
    var folder = binderDir.list();
    folder.forEach((element) {
      File file = File(element.path);
      String str = file.readAsStringSync();
      Map<String, dynamic> jsonData = jsonDecode(str);
      Map<String, bool> binder = {};
      for (var element in jsonData.keys) {
        if (jsonData[element] == false) {
          binder[element] = false;
        } else {
          binder[element] = true;
        }
      }
      List<String> pathSplit = file.path.split("/");
      binderNames.add(pathSplit[pathSplit.length - 1].replaceAll(".json", ""));
      binders.add(binder);
    });
    loadedFromDisk = true;
    setState(() {});
  }

  @override
  void initState() {
    loadBindersFromDisk();
    super.initState();
  }

  createNewBinder() async {
    loading = true;

    setState(() {});

    Map<String, bool> binder = {};

    Response res = await dio.get(
        "https://timhortonsapi.azurewebsites.net/api/hockeycards/$dropdownValue");
    // ignore: unused_local_variable
    var apidata = res.data;

    apidata.forEach(
        (element) => {binder[element["playerName"].toString()] = false});

    //The user has to actually open and then back out of the binder to save changes.
    binderNames.add("$textboxValue-$dropdownValue");
    binders.add(binder);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Binders"),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text("Create New Binder"),
                children: [
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: SizedBox(
                              width: 250,
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Binder Name",
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    textboxValue = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 175,
                              child: Row(
                                children: [
                                  const Text(
                                    "Year:    ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  DropdownButton<String>(
                                    items: years
                                        .map<DropdownMenuItem<String>>(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                    value: dropdownValue,
                                    onChanged: (String? val) {
                                      setState(() {
                                        dropdownValue = val!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              createNewBinder();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.red[600]!),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                            ),
                            child: const Text("Create!"),
                          )
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.red[600],
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (loading == true)
            LinearProgressIndicator(
              color: Colors.red[700],
            ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              if (binders.isEmpty && loadedFromDisk == true) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      "You don't have any binders!",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              } else {
                return Column(
                  children: binders.map<Card>(
                    (e) {
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.red[600]?.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BinderPage(
                                    binder: e,
                                    title: binderNames[binders.indexOf(e)]),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(binderNames[binders.indexOf(e)]),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
