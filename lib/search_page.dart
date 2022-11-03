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
  // ignore: prefer_typing_uninitialized_variables
  var apidata; //for decoded JSON data
  // It's JSON data from my API, and I don't feel like writing a type for it

  List cards2015 = [];
  List cards2016 = [];
  List cards2017 = [];
  List cards2018 = [];
  List cards2019 = [];
  List cards2020 = [];
  List cards2021 = [];
  List cardsCanada = [];
  List cards2022 = [];

  List<List> cardArrays = [];

  List<String> setNames = [];

  String setFilterValue = "All";

  List<List> cardsFinal = [];

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  getData() async {
    setNames.add("All");
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    String url = "https://timhortonsapi.azurewebsites.net/api/hockeycards";
    //don't use "http://localhost/" use local IP or actual live URL

    Response response = await dio.get(url);
    apidata = response.data; //get JSON decoded data from response

    if (response.statusCode != 200) {
      error = true;
      errmsg = "Error while fetching data.";
      return;
    }

    // Yes, yes, I know. Switch case statements exist, and I should probably
    // use one here, but idc, and it was giving weird errors.
    apidata.forEach(
      (element) {
        if (element["year"] == "2015") {
          cards2015.add(element);
        } else if (element["year"] == "2016") {
          cards2016.add(element);
        } else if (element["year"] == "2017") {
          cards2017.add(element);
        } else if (element["year"] == "2018") {
          cards2018.add(element);
        } else if (element["year"] == "2019") {
          cards2019.add(element);
        } else if (element["year"] == "2020") {
          cards2020.add(element);
        } else if (element["year"] == "2021") {
          cards2021.add(element);
        } else if (element["year"] == "2022") {
          cards2022.add(element);
        } else if (element["year"] == "2021-can") {
          cardsCanada.add(element);
        }
        bool matching = false;
        for (var setName in setNames) {
          if (element["set"] == setName) {
            matching = true;
          }
        }
        if (matching == false) {
          setNames.add(element["set"]);
        }
      },
    );

    // TODO: Add the rest of the cards from other sets into the API
    loading = false;

    resetCards();

    //This is because cardArrays will be modified and changed as time goes on.
    setState(() {}); //refresh UI
  }

  resetCards() {
    print("Resetting Cards");
    //MUST BE IN THE SAME ORDER AS THE TABS IN THE APP BAR
    cardArrays = [];
    print(cards2015.length);
    cardArrays.add(cards2015);
    cardArrays.add(cards2016);
    cardArrays.add(cards2017);
    cardArrays.add(cards2018);
    cardArrays.add(cards2019);
    cardArrays.add(cards2020);
    cardArrays.add(cards2021);
    cardArrays.add(cardsCanada);
    cardArrays.add(cards2022);
  }

  filterCards() {
    //Sets
    resetCards();
    print("Filtering");
    print(cardArrays.length);
    print(cardArrays[0].length);
    if (setFilterValue != "All") {
      for (var year in cardArrays) {
        List cardsToRemove = [];
        for (var card in year) {
          if (card["set"] != setFilterValue) {
            cardsToRemove.add(card);
          }
        }
        for (var card in cardsToRemove) {
          year.remove(card);
        }
      }
    }
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
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: "2015",
              ),
              Tab(
                text: "2016",
              ),
              Tab(
                text: "2017",
              ),
              Tab(
                text: "2018",
              ),
              Tab(
                text: "2019",
              ),
              Tab(
                text: "2020",
              ),
              Tab(
                text: "2021",
              ),
              Tab(
                text: "2021 Team Canada",
              ),
              Tab(
                text: "2022",
              ),
            ],
            isScrollable: true,
          ),
          backgroundColor: Colors.red[600],
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: error
                    ? Text("Error: $errmsg")
                    : TabBarView(
                        children: cardArrays
                            .map(
                              (cardArray) => ListView(
                                children: cardArray
                                    .map(
                                      (card) => ListTile(
                                        title: Text(
                                          card["playerName"],
                                        ),
                                        subtitle: Text(
                                          card["set"],
                                        ),
                                        trailing: Text(
                                          "\$${card["price"].toString()}",
                                        ),
                                        onTap: () {
                                          //TODO: Display information about the card
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
                                print(setFilterValue);
                                filterCards();
                              },
                            ),
                            const Text("Bottom Sheet"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          backgroundColor: Colors.red[600],
          child: const Icon(Icons.filter_list),
        ),
      ),
    );
  }
}
