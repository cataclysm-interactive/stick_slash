// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _topBannerAd;
  BannerAd? _middleBannerAd;
  BannerAd? _bottomBannerAd;

  @override
  void initState() {
    BannerAd(
      adUnitId: "ca-app-pub-9636577749309906/6245736421",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _topBannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
    BannerAd(
      adUnitId: "ca-app-pub-9636577749309906/6437609439",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _middleBannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
    BannerAd(
      adUnitId: "ca-app-pub-9636577749309906/9706993345",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bottomBannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
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
                child: Center(
                  child: Text(
                    //TODO: Update the patch notes BEFORE each update
                    //Also could hook this up to the API to allow it to be updated wirelessly
                    "Version 1.0.3 Patch Notes \n" +
                        "- Fixed a bunch of crashes\n" +
                        "- Added Total Value to binders page\n" +
                        "- Adjusted Filters\n" +
                        "- Fixed Firebase Analytics",
                    style: TextStyle(fontSize: 20),
                  ),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          if (_topBannerAd == null)
                            CircularProgressIndicator(
                              color: Colors.red[600],
                            ),
                          if (_topBannerAd != null)
                            SizedBox(
                              width: _topBannerAd!.size.width.toDouble(),
                              height: _topBannerAd!.size.height.toDouble(),
                              child: StatefulBuilder(
                                builder: (context, state) => AdWidget(
                                  ad: _topBannerAd!,
                                ),
                              ),
                            ),
                          if (_middleBannerAd != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                width: _middleBannerAd!.size.width.toDouble(),
                                height: _middleBannerAd!.size.height.toDouble(),
                                child: StatefulBuilder(
                                  builder: (context, state) => AdWidget(
                                    ad: _middleBannerAd!,
                                  ),
                                ),
                              ),
                            ),
                          if (_bottomBannerAd != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                width: _bottomBannerAd!.size.width.toDouble(),
                                height: _bottomBannerAd!.size.height.toDouble(),
                                child: StatefulBuilder(
                                  builder: (context, state) => AdWidget(
                                    ad: _bottomBannerAd!,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Card(
            child: SizedBox(
              width: 350,
              height: 150,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Hey, do you like this app? Wanna see more of my work?" +
                        "Take a look at my GitHub profile: untold-titan. " +
                        "There you can find all my past, present and future work, " +
                        "and sponsor it too! Feedback can be left on the Google Play Store, " +
                        "or on the GitHub Repository, or emailed to me directly at gamerdev2020@gmail.com",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          //TODO: Add Social media links. Discord, Reddit, Github.
        ],
      ),
    );
  }
}
