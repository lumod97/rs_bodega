import 'package:flutter/material.dart';
import 'package:rs_bodega/DAO/venta_detalle_dao.dart';
import 'package:rs_bodega/DAO/venta_detalle_model.dart';

class SalesDetailScreen extends StatelessWidget {
  final int ventaId;

  SalesDetailScreen({required this.ventaId});

  final VentaDetalleDAO _ventaDetalleDAO = VentaDetalleDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Venta'),
      ),
      body: FutureBuilder<List<VentaDetalleModel>>(
        future: _ventaDetalleDAO.getDetallesByVentaId(ventaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay detalles disponibles para esta venta.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final detalle = snapshot.data![index];
                return ListTile(
                  title: Text('Producto ID: ${detalle.id_producto}'),
                  subtitle: Text('Cantidad Vendida: ${detalle.cantidad_vendida}'),
                  trailing: Text('Total: S/ ${detalle.precio_unitario * detalle.cantidad_vendida}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
