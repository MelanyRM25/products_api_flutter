import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Formulario extends StatefulWidget {
  final int? id;
  final String? name;
  final String? price;
  final String? amount;
  const Formulario({
    super.key,
    this.id,
    this.name,
    this.price,
    this.amount,
  });

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  initState() {
    super.initState();
    if (widget.id != null) {
      nameController.text = widget.name!;
      priceController.text = widget.price!;
      amountController.text = widget.amount!;
    }
  }

  registrar() {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todos los campos son requeridos'),
        ),
      );
    }
    var url = Uri.parse(dotenv.env['API_BACK']! + '/products');
    var token = localStorage.getItem('token');
    http.post(url, body: {
      'name': nameController.text,
      'price': priceController.text,
      'amount': amountController.text,
    }, headers: {
      'Authorization': 'Bearer $token',
    }).then((value) {
      print(value.statusCode);
      if (value.statusCode == 201) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Precio',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
              ),
              keyboardType: TextInputType.number,
            ),
            widget.id != null
                ? ElevatedButton(
                    onPressed: () {
                      var token = localStorage.getItem('token');
                      var url = Uri.parse(
                          dotenv.env['API_BACK']! + '/products/${widget.id}');
                      http.put(url, body: {
                        'name': nameController.text,
                        'price': priceController.text,
                        'amount': amountController.text,
                      }, headers: {
                        'Authorization': 'Bearer $token',
                      }).then((value) {
                        print(value.statusCode);
                        if (value.statusCode == 200) {
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: const Text('Actualizar'),
                  )
                : ElevatedButton(
                    onPressed: registrar,
                    child: const Text('Guardar'),
                  ),
          ],
        ),
      ),
    );
  }
}
