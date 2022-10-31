import 'package:dio/dio.dart';
import "package:flutter/material.dart";

class SetItem {
  SetItem(String titl) {
    title = titl;
  }
  List<String> cardNames = List.empty(growable: true);
  List<bool> checkedBoxes = List.empty(growable: true);
  String title = "";
  bool isExpanded = false;
}

class Binders extends StatefulWidget {
  const Binders({super.key});

  @override
  State<Binders> createState() => _BindersState();
}

class _BindersState extends State<Binders> {
  //TODO: Grab data from API and feed it into a list of BinderItems
  Dio dio = Dio();
  //Each Item is equal to a set from a year.
  List<SetItem> _data = List.empty(growable: true);
  String url = "https://timhortonsapi.azurewebsites.net/api/hockeycards/2015";
  // Reason: Its API data, too lazy to write a class for the API data.
  // ignore: prefer_typing_uninitialized_variables
  var apiData;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    Response res = await dio.get(url);
    if (res.statusCode != 200) {
      return;
    }

    apiData = res.data;
    int numberOfSets = 0;
    String set = "";
    apiData.forEach((item) {
      if (set != item["set"]) {
        bool exists = false;
        for (var element in _data) {
          {
            if (element.title == item["set"]) {
              exists = true;
            }
          }
        }
        set = item["set"];
        if (exists != true) {
          _data.add(SetItem(item["set"]));
          numberOfSets++;
        }
        //Should loop through each card, and figure out how many sets there are.
        // Yes, I could also just update the API to tell me this information, but f that
      }
      for (var element in _data) {
        if (element.title == item["set"]) {
          element.cardNames.add(item["playerName"]);
        }
      }
    });

    print(numberOfSets);

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
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>(
        (e) {
          return (ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(e.title),
              );
            },
            body: Column(
              children: e.cardNames.map<Row>((e) {
                return Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Checkbox(value: false, onChanged: ((value) {})),
                  ],
                );
              }).toList(),
            ),
            isExpanded: e.isExpanded,
          ));
        },
      ).toList(),
    );
  }
}
