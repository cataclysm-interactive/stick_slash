import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BannerAd myBanner = BannerAd(
    adUnitId:
        'ca-app-pub-3940256099942544/6300978111', //TODO: Replace with LIVE unit id
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  @override
  void initState() {
    myBanner.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Card(
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text(
                      "Advertisements",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    AdWidget(ad: myBanner),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
