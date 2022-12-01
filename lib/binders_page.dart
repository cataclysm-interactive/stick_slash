import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';
import "binder.dart";

class Binder extends StatefulWidget {
  const Binder({super.key});

  @override
  State<Binder> createState() => _BinderState();
}

class _BinderState extends State<Binder> {
  Dio dio = Dio();
  Map<String, List> binders = {}; //The key is the binder's name

  List<String> years = [];

  String dropdownValue = "";
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
      List<String> pathSplit = file.path.split("/");
      String binderName =
          pathSplit[pathSplit.length - 1].replaceAll(".json", "");
      binders[binderName] = jsonDecode(str);
    });
    loadedFromDisk = true;
    setState(() {});
  }

  void getYears() async {
    Response res =
        await dio.get("https://stickslash-api.azurewebsites.net/api/years");
    var apidata = res.data;
    for (var e in apidata) {
      years.add(e["yearStr"]);
    }
    dropdownValue = years.first;
  }

  @override
  void initState() {
    getYears();
    loadBindersFromDisk();
    super.initState();
  }

  createNewBinder() async {
    loading = true;
    setState(() {});

    // Create the binder
    binders[textboxValue] = [];

    Response res = await dio.get(
        "https://stickslash-api.azurewebsites.net/api/hockeycards/$dropdownValue");
    // ignore: unused_local_variable
    var apidata = res.data;

    //The user has to actually open and then back out of the binder to save changes.
    apidata.forEach((element) {
      element["owned"] = false; //Init the checklist part.
      binders[textboxValue]!.add(element);
    });

    loading = false;

    FirebaseAnalytics.instance.logEvent(
      name: "create_binder",
      parameters: {"name": textboxValue, "year": dropdownValue},
    );

    setState(() {});
  }

  deleteBinder(String title) async {
    final directory = await getApplicationDocumentsDirectory();
    Directory finalPath = Directory("${directory.path}/Binders");
    if (finalPath.existsSync() == false) {
      await finalPath.create();
      //I sure hope this code never gets called, cause something SERIOUSLY wrong would have to happen
    }
    File file = File("${directory.path}/Binders/$title.json");
    await file.delete();

    FirebaseAnalytics.instance.logEvent(
      name: "delete_binder",
      parameters: {"name": title, "year": binders[title]?[0]["year"]},
    );

    binders.remove(title);
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
                                decoration: InputDecoration(
                                  focusColor: Colors.red[700],
                                  border: const OutlineInputBorder(),
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
                                      setState(
                                        () {
                                          dropdownValue = val!;
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              createNewBinder();
                              Navigator.of(context).pop();
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
                  children: binders.keys.map<Card>(
                    (e) {
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.red[600]?.withAlpha(30),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  children: [
                                    const Center(
                                      child: Text(
                                        "Delete this Binder?",
                                        textScaleFactor: 1.2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              deleteBinder(e.toString());
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Yes"),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            color: Colors.red[600],
                                            child: const Text("No"),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BinderPage(
                                  binder: binders[e]!,
                                  title: e.toString(),
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(e),
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
