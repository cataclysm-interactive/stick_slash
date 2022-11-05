import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AllCardsPage extends StatefulWidget {
  const AllCardsPage({Key? key}) : super(key: key);

  @override
  State<AllCardsPage> createState() => _AllCardsPageState();
}

class _AllCardsPageState extends State<AllCardsPage> {
  late Response response;
  Dio dio = Dio();

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  String errCode = "";
  // ignore: prefer_typing_uninitialized_variables
  var apidata; //for decoded JSON data
  // It's JSON data from my API, and I don't feel like writing a type for it

  Map<String, List> cards = {};
  Map<String, List> cardsFinal = {};

  String setFilterValue = "All";
  List<String> setNames = [];

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  getData() async {
    //TODO: Remake the sorting algorythmn to actually sort the cards properly, and nicely
    setNames.add("All");
    loading = true; //make loading true to show progressindicator
    setState(() {});

    String baseUrl = "https://timhortonsapi.azurewebsites.net/api/";

    Response cardsRes = await dio.get('${baseUrl}hockeycards');
    var cardData = cardsRes.data;

    if (cardsRes.statusCode != 200) {
      error = true;
      errmsg = cardsRes.data;
      errCode = cardsRes.statusCode.toString();
    }

    for (var card in cardData) {
      if (cards[card["year"]] == null) {
        cards[card["year"]] = [];
        cards[card["year"]]!.add(card);
        cardsFinal[card["year"]] = [];
        cardsFinal[card["year"]]!.add(card);
      } else {
        cards[card["year"]]!.add(card);
        cardsFinal[card["year"]]!.add(card);
      }
      bool foundSet = false;
      for (var set in setNames) {
        if (set == card["set"]) {
          foundSet = true;
        }
      }
      if (foundSet != true) {
        setNames.add(card["set"]);
      }
    }

    loading = false;

    setState(() {}); //refresh UI
  }

  resetCards() {
    // cards = {...cardsFinal};
    //TODO: Find a way to reset the cards array without pointing to cardsFinal
  }

  filterCards() {
    resetCards();
    // loading = true;
    setState(() {});

    Map<String, List> cardsToRemove = {};
    for (var year in cards.keys) {
      cardsToRemove[year] = [];
      for (var card in cards[year]!) {
        if (card["set"] != setFilterValue && setFilterValue != "All") {
          cardsToRemove[year]!.add(card);
        }
      }
    }

    for (var year in cardsToRemove.keys) {
      for (var card in cardsToRemove[year]!) {
        cards[year]!.remove(card);
      }
    }

    // loading = false;

    cards = cards;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("All Cards"),
          foregroundColor: Colors.white,
          bottom: loading
              ? null
              : TabBar(
                  tabs: cards.keys
                      .map<Widget>(
                        (e) => Tab(
                          text: e,
                        ),
                      )
                      .toList(),
                  isScrollable: true,
                ),
          backgroundColor: Colors.red[600],
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.red[600],
              ))
            : error
                ? Column(
                    children: [
                      const Text("An Error Occured"),
                      Text(errCode),
                      Text(errmsg),
                      const Text("Please try again later")
                    ],
                  )
                : Center(
                    child: error
                        ? Text("Error: $errmsg")
                        : TabBarView(
                            children: cards.values
                                .map(
                                  (yearOfCards) => ListView(
                                    children: yearOfCards
                                        .map(
                                          (card) => ListTile(
                                            title: Text(card["playerName"]),
                                            trailing: Text(
                                                "\$${card["price"].toString()}"),
                                            subtitle: Text(card["set"] +
                                                "   " +
                                                card["year"]),
                                            onTap: () {
                                              //TODO: View information for cards when tapped
                                              // ignore: avoid_print
                                              print("Tapped");
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (loading == false) {
              showBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: 300,
                        color: Colors.red[700],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              DropdownButton<String>(
                                value: setFilterValue,
                                items: setNames
                                    .map<DropdownMenuItem<String>>(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (String? val) {
                                  setFilterValue = val!;
                                  setState(() {});
                                  // TODO: actually implement filtering.
                                  // filterCards();
                                },
                              ),
                              const Text(
                                  "Filtering is currently being worked on, it is not fully functional"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
          backgroundColor: Colors.red[600],
          child: const Icon(Icons.filter_list),
        ),
      ),
    );
  }
}
