import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StickSlash',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.red[600],
      ),
      home: const Layout(title: 'Stick Slash'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[600],
      ),
      body: ListView(
        children: const [
          Card(
            child: SizedBox(
              width: 350,
              height: 250,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Ooga Booga, News goes here",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Card(
            child: SizedBox(
              width: 350,
              height: 250,
              child: Center(
                child: Text("Ooga Booga, News goes here"),
              ),
            ),
          ),
          Card(
            child: SizedBox(
              width: 350,
              height: 250,
              child: Center(
                child: Text("Ooga Booga, News goes here"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/rawCards.txt');
  }

  Future<File> writeData(String jsonData) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(jsonData);
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

    writeData(apidata.toString());

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

    // TODO: convert all set names from the API back into their actual names

    print(cards2015[1]);
    loading = false;

    setState(() {}); //refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "All Cards",
            style: TextStyle(color: Colors.white),
          ),
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
                                subtitle: Text(
                                    "${e["set"]}          \$${e["price"]}"),
                                onTap: () {
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

// It's the main object
class Layout extends StatefulWidget {
  const Layout({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(key: Key("HomePage")),
    AllCardsPage(
      key: Key("AllCards"),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          )
          // TODO: Add Settings, and the actual collection/binders page
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.red[600],
        selectedItemColor: Colors.white,
      ),
    );
  }
}
