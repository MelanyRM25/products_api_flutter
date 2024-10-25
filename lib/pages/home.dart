import 'package:api_back/pages/formulario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    var url = Uri.parse(dotenv.env['API_BACK']! + '/products');

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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Formulario(
                                              id: products[index]['id'],
                                              name: products[index]['name'],
                                              price: products[index]['price'],
                                              amount: products[index]['amount'],
                                            )),
                                  );
                                  productGet();
                                },
                                icon: Icon(Icons.edit)),
                            //Borrar
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                AlertDialog(
                                  title: Text("Eliminar"),
                                  content: Text(
                                      "¿Estas seguro de eliminar este producto?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          var url = Uri.parse(dotenv
                                                  .env['API_BACK']! +
                                              '/products/' +
                                              products[index]['id'].toString());
                                          var response = await http.delete(url);
                                          if (response.statusCode == 200) {
                                            productGet();
                                          } else {
                                            print(
                                                'Request failed with status: ${response.statusCode}.');
                                          }
                                        },
                                        child: Text("Eliminar"))
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            onPressed: () async {
              //redireccionar a Formlario.dart
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Formulario()));
              productGet();
            },
            child: Icon(Icons.add)));
  }
}
