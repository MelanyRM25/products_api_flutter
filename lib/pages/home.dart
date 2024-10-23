import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var contador = 0;
  incrementar() {
    contador++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi app"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Contador:" + contador.toString()),
            ElevatedButton(
                onPressed: () {
                  incrementar();
                },
                child: Text("Incrementar"))
          ],
        ),
      ),
    );
  }
}
