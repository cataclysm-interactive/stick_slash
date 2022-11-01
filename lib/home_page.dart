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
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
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
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
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
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
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
                              child: AdWidget(
                                ad: _topBannerAd!,
                              ),
                            ),
                          if (_middleBannerAd != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                width: _middleBannerAd!.size.width.toDouble(),
                                height: _middleBannerAd!.size.height.toDouble(),
                                child: AdWidget(
                                  ad: _middleBannerAd!,
                                ),
                              ),
                            ),
                          if (_bottomBannerAd != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                width: _bottomBannerAd!.size.width.toDouble(),
                                height: _bottomBannerAd!.size.height.toDouble(),
                                child: AdWidget(
                                  ad: _bottomBannerAd!,
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
        ],
      ),
    );
  }
}
