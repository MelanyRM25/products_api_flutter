import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart'; // Para convertir respuestas JSON

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  initState() {
    super.initState();
    _emailController.text = 'admin@gmail.com';
    _passwordController.text = 'admin';
    _checkToken();
  }

//verificara si existe un token
  Future<void> _checkToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHome()), // Reemplaza con tu pantalla Home
      );
    }
  }

  // Método para manejar el login
  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // URL de la API para login (cambia a la que uses)
    final String apiUrl = dotenv.env['API_BACK']! + '/login';

    // Cuerpo de la solicitud
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    // Manejar la respuesta
    if (response.statusCode == 200) {
      // La solicitud fue exitosa, manejar la respuesta
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token =
          responseData['token']; // Ejemplo si la API retorna un token
      print('Login exitoso, Token: $token');
      localStorage.setItem('token', token); //guardar token

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHome()),
      );
    } else {
      // Hubo un error en la solicitud
      print('Error en el login: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error en el login, verifique sus credenciales'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: Image.asset("images/background.jpg").image,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            color: Colors.blueAccent[700],
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Imagen de cabecera
                  Image.asset(
                    "images/flutter_dash.png", // Ruta de la imagen del logo
                    height: 120,
                  ),
                  SizedBox(
                      height: 40), // Espacio entre la imagen y el formulario

                  // Campo de correo electrónico
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: 'Correo electrónico',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Campo de contraseña
                  TextField(
                    controller: _passwordController,
                    obscureText: true, // Ocultar el texto para la contraseña
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Botón de login
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
