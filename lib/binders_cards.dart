import "package:flutter/material.dart";

const List<String> years = [
  "2015",
  "2016",
  "2017",
  "2018",
  "2019",
  "2020",
  "2021",
  "2022"
];

class BinderPage extends StatefulWidget {
  const BinderPage({super.key});

  @override
  State<BinderPage> createState() => _BinderPageState();
}

class _BinderPageState extends State<BinderPage> {
  List<String> binderNames = List.empty();

  String dropdownValue = years.first;
  String binderName = "";

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
                                    binderName = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 125,
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
                                        print(val);
                                        dropdownValue = val!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
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
          children: binderNames.map<Card>(
        (e) {
          return Card(
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Text(e),
            ),
          );
        },
      ).toList()),
    );
  }
}
