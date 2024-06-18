import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:rs_bodega/DAO/producto_dao.dart';
import 'package:rs_bodega/DAO/producto_model.dart';
import 'package:rs_bodega/DAO/venta_dao.dart';
import 'package:rs_bodega/DAO/venta_detalle_dao.dart';
import 'package:rs_bodega/DAO/venta_detalle_model.dart';
import 'package:rs_bodega/DAO/venta_model.dart';

class RealizarVentaScreen extends StatefulWidget {
  @override
  _RealizarVentaScreenState createState() => _RealizarVentaScreenState();
}

class _RealizarVentaScreenState extends State<RealizarVentaScreen> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _vendedorController = TextEditingController();

  final VentaDAO _ventaDAO = VentaDAO(); // Instancia de tu DAO de venta
  final VentaDetalleDAO _ventaDetalleDAO = VentaDetalleDAO(); // Instancia de tu DAO de venta detalle
  final ProductoDAO _productoDAO = ProductoDAO(); // Instancia de tu DAO de productos

  List<VentaDetalleModel> _detallesVenta = []; // Lista para almacenar los detalles de la venta
  double _totalVenta = 0.0; // Variable para calcular el total de la venta

  @override
  void initState() {
    super.initState();
    _ventaDAO.open(); // Abre la conexión a la base de datos de ventas al iniciar la pantalla
    _ventaDetalleDAO.open(); // Abre la conexión a la base de datos de detalles de ventas al iniciar la pantalla
    _productoDAO.open(); // Abre la conexión a la base de datos de productos al iniciar la pantalla
  }

  @override
  void dispose() {
    _ventaDAO.close(); // Cierra la conexión a la base de datos de ventas al salir de la pantalla
    _ventaDetalleDAO.close(); // Cierra la conexión a la base de datos de detalles de ventas al salir de la pantalla
    _productoDAO.close(); // Cierra la conexión a la base de datos de productos al salir de la pantalla
    super.dispose();
  }

  void _agregarProducto(ProductoModel producto) {
    // Buscar si el producto ya está en la lista de detalles de venta
    int index = _detallesVenta.indexWhere((detalle) => detalle.id_producto == producto.id);

    if (index != -1) {
      // Si el producto ya existe, incrementar la cantidad y actualizar el subtotal
      _detallesVenta[index].cantidad_vendida++;
      _totalVenta += _detallesVenta[index].precio_unitario; // Sumar solo el precio unitario al total
    } else {
      // Si el producto no existe, crear un nuevo detalle de venta
      VentaDetalleModel detalleVenta = VentaDetalleModel(
        id: 0, // El ID se genera automáticamente en la base de datos
        id_venta: 0, // Lo actualizaremos después de insertar la venta
        id_producto: producto.id ?? 0000000000000,
        cantidad_vendida: 1, // Cantidad inicial
        precio_unitario: producto.precio_venta ?? 0, // Precio de venta del producto
        descuento_aplicado: 0, // Puedes ajustar esto según tu lógica de venta
      );

      // Calcular el subtotal del nuevo detalle y actualizar el total de la venta
      double subtotal = detalleVenta.cantidad_vendida * detalleVenta.precio_unitario - detalleVenta.descuento_aplicado;
      _totalVenta += subtotal;

      // Agregar el detalle a la lista
      _detallesVenta.add(detalleVenta);
    }

    // Actualizar la interfaz
    setState(() {});
  }

  Future<void> _escanearCodigoBarras() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

    if (barcodeScanRes != '-1') {
      ProductoModel? producto = await _productoDAO.getProductByIdLike(barcodeScanRes);

      if (producto != null) {
        // Si encontramos el producto, lo agregamos a la venta
        _agregarProducto(producto);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto no encontrado')),
        );
      }
    }
  }

  void _realizarVenta() async {
    // Validar que se hayan agregado detalles de venta
    if (_detallesVenta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agrega al menos un producto para realizar la venta')),
      );
      return;
    }

    // Crear la venta principal
    VentaModel venta = VentaModel(
      id: 0, // El ID se genera automáticamente en la base de datos
      fecha_venta: _dateFormat.format(DateTime.now()),
      id_cliente: _clienteController.text,
      id_vendedor: _vendedorController.text,
    );

    // Insertar la venta y obtener su ID generado
    int idVenta = await _ventaDAO.insertVenta(venta);

    // Asignar el ID de la venta a cada detalle de venta y luego insertarlos
    for (var detalle in _detallesVenta) {
      detalle.id_venta = idVenta;
      await _ventaDetalleDAO.insertVentaDetalle(detalle);
    }

    // Mostrar mensaje de éxito o navegar a otra pantalla, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Venta realizada correctamente')),
    );

    // Limpiar la lista de detalles y resetear el total de la venta
    _detallesVenta.clear();
    _totalVenta = 0.0;

    // Actualizar la interfaz
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Venta'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _clienteController,
              decoration: InputDecoration(labelText: 'ID Cliente'),
            ),
            TextField(
              controller: _vendedorController,
              decoration: InputDecoration(labelText: 'ID Vendedor'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _escanearCodigoBarras,
              child: Text('Escanear Código de Barras'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Detalles de la Venta',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            if (_detallesVenta.isNotEmpty)
              Column(
                children: _detallesVenta.map((detalle) {
                  return ListTile(
                    title: Text('Producto: ${detalle.id_producto}, Cantidad: ${detalle.cantidad_vendida}'),
                    subtitle: Text(
                      'Precio Unitario: S/ ${detalle.precio_unitario.toStringAsFixed(2)} - SubTotal: S/ ${(detalle.precio_unitario * detalle.cantidad_vendida).toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          // Restar el subtotal del detalle eliminado del total de la venta
                          double subtotal = detalle.cantidad_vendida * detalle.precio_unitario - detalle.descuento_aplicado;
                          _totalVenta -= subtotal;
                          // Eliminar el detalle de la lista
                          _detallesVenta.remove(detalle);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 20.0),
            Text(
              'Total de la Venta: S/ ${_totalVenta.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _realizarVenta,
              child: Text('Realizar Venta'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RealizarVentaScreen(),
  ));
}
