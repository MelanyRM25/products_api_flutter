import 'package:api_back/pages/formulario.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  //var contador = 0;
  List products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productGet(); //lamando metodo para obt5ener los productos
  }

  productGet() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/products');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        products = jsonResponse;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  // incrementar() {
  //   contador++;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: Text("Mi app"),
        ),
        body: Center(
          child: Column(
            children: [
              // Text("Contador:" + contador.toString()),
              // ElevatedButton(
              //     onPressed: () {
              //       incrementar();
              //     },
              //     child: Text("Incrementar")),
              ElevatedButton(
                  onPressed: () {
                    productGet();
                  },
                  child: Text("Actualizar productos")),

              Expanded(
                child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(products[index]['name']),
                        subtitle: Text(products[index]['price'].toString()),
                      );
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              //redireccionar a Formlario.dart
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Formulario()));
            },
            child: Icon(Icons.add)));
  }
}
