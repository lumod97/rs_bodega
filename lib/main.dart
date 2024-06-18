import 'package:flutter/material.dart';
import 'package:rs_bodega/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Ruta inicial de la aplicación
      routes: routes, // Mapa de rutas definido en routes.dart
      onGenerateRoute: generateRoute, // Función para generar rutas dinámicas
    );
  }
}
