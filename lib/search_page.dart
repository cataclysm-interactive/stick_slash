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

  List<String> setNames = <String>[""];

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  getData() async {
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
      (element) => {
        if (element["year"] == "2015")
          {cards2015.add(element)}
        else if (element["year"] == "2016")
          {cards2016.add(element)}
        else if (element["year"] == "2017")
          {cards2017.add(element)}
        else if (element["year"] == "2018")
          {cards2018.add(element)}
        else if (element["year"] == "2019")
          {cards2019.add(element)}
        else if (element["year"] == "2020")
          {cards2020.add(element)}
        else if (element["year"] == "2021")
          {cards2021.add(element)}
        else if (element["year"] == "2022")
          {cards2022.add(element)}
        else if (element["year"] == "2021-can")
          {cardsCanada.add(element)}
      },
    );

    // TODO: Add the rest of the cards from other sets into the API
    loading = false;

    setState(() {}); //refresh UI
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
                        children: <Widget>[
                          ListView(
                              children: cards2015.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(e["set"]),
                                trailing: Text("\$${e["price"]}"),
                                onTap: () {
                                  //TODO: Display Information about the card that was tapped on
                                  print("Tapped!");
                                },
                              );
                            },
                          ).toList()),
                          ListView(
                              children: cards2016.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                              );
                            },
                          ).toList()),
                          ListView(
                              children: cards2017.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                              );
                            },
                          ).toList()),
                          ListView(
                              children: cards2018.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                              );
                            },
                          ).toList()),
                          ListView(
                              children: cards2019.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                              );
                            },
                          ).toList()),
                          ListView(
                              children: cards2020.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                              );
                            },
                          ).toList()),
                          ListView(
                              children: cards2021.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                              );
                            },
                          ).toList()),
                          ListView(
                              children: cardsCanada.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                              );
                            },
                          ).toList()),
                          ListView(
                              children: cards2022.map<Widget>(
                            (e) {
                              return ListTile(
                                title: Text(e["playerName"]),
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                              );
                            },
                          ).toList()),
                        ],
                      ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 300,
                  color: Colors.red[700],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Text("Bottom Sheet"),
                      ],
                    ),
                  ),
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
