import 'package:flutter/material.dart';
import 'package:rs_bodega/DAO/venta_dao.dart';
import 'package:rs_bodega/DAO/venta_model.dart';

class SalesListScreen extends StatelessWidget {
  final VentaDAO _ventaDAO = VentaDAO();

  Future<void> _openDatabase() async {
    await _ventaDAO.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Ventas'),
      ),
      body: FutureBuilder<void>(
        future: _openDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return FutureBuilder<List<VentaModel>>(
              future: _ventaDAO.getAllVentas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay ventas disponibles.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final venta = snapshot.data![index];
                      return ListTile(
                        title: Text('Venta ID: ${venta.id}'),
                        subtitle: Text('Fecha: ${venta.fecha_venta}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/details_sale',
                            arguments: venta.id,
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
