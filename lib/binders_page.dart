import "package:flutter/material.dart";

class Binders extends StatelessWidget {
  const Binders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Binders"),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
      ),
    );
  }
}
