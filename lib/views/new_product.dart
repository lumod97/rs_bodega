import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:rs_bodega/DAO/producto_dao.dart';
import 'package:rs_bodega/DAO/producto_model.dart';
import 'package:rs_bodega/views/new_sale.dart';
import 'package:rs_bodega/views/sales_list.dart';

class InsertarProductoScreen extends StatefulWidget {
  const InsertarProductoScreen({super.key});

  @override
  _InsertarProductoScreenState createState() => _InsertarProductoScreenState();
}

class _InsertarProductoScreenState extends State<InsertarProductoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _tamanoController = TextEditingController();
  final TextEditingController _idCategoriaController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _idProveedorController = TextEditingController();
  final TextEditingController _fechaIngresoController = TextEditingController();
  final TextEditingController _SKUController = TextEditingController();
  final TextEditingController _fechaVencimientoController =
      TextEditingController();
  final TextEditingController _precioCompraController = TextEditingController();
  final TextEditingController _precioVentaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  final ProductoDAO _productoDAO = ProductoDAO(); // Instancia de tu DAO

  @override
  void initState() {
    super.initState();
    _productoDAO
        .open(); // Abre la conexión a la base de datos al iniciar la pantalla
  }

  @override
  void dispose() {
    _productoDAO
        .close(); // Cierra la conexión a la base de datos al salir de la pantalla
    super.dispose();
  }

  void _insertarProducto() async {
    // Recolectar los datos de los TextField
    ProductoModel nuevoProducto = ProductoModel(
      // id: 0, // Este valor no se usará ya que la base de datos lo autoincrementará
      name: _nameController.text,
      description: _descriptionController.text,
      marca: _marcaController.text,
      modelo: _modeloController.text,
      color: _colorController.text,
      tamano: _tamanoController.text,
      id_category: int.parse(_idCategoriaController.text),
      stock: int.parse(_stockController.text),
      id_proveedor: (_idProveedorController.text.isNotEmpty)
          ? int.parse(_idProveedorController.text)
          : null,
      fecha_ingreso: _fechaIngresoController.text,
      SKU: _SKUController.text,
      fecha_vencimiento: (_fechaVencimientoController.text.isNotEmpty)
          ? _fechaVencimientoController.text
          : null,
      precio_compra: (_precioCompraController.text.isNotEmpty)
          ? double.parse(_precioCompraController.text)
          : null,
      precio_venta: (_precioVentaController.text.isNotEmpty)
          ? double.parse(_precioVentaController.text)
          : null,
      peso: (_pesoController.text.isNotEmpty)
          ? double.parse(_pesoController.text)
          : null,
    );

    // Insertar el nuevo producto utilizando el DAO
    await _productoDAO.insertProducto(nuevoProducto);

    // Mostrar mensaje de éxito o navegar a otra pantalla, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Producto insertado correctamente')),
    );
  }

  void _generarVenta() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RealizarVentaScreen()),
    );
  }

  void _verVentas() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SalesListScreen()),
    );
  }

  Future<void> _escanearCodigoBarras() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

    if (barcodeScanRes != '-1') {
      setState(() {
        _SKUController.text = barcodeScanRes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insertar Nuevo Producto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _marcaController,
              decoration: InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              controller: _modeloController,
              decoration: InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            TextField(
              controller: _tamanoController,
              decoration: InputDecoration(labelText: 'Tamaño'),
            ),
            TextField(
              controller: _idCategoriaController,
              decoration: InputDecoration(labelText: 'ID de Categoría'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _idProveedorController,
              decoration:
                  InputDecoration(labelText: 'ID de Proveedor (opcional)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fechaIngresoController,
              decoration:
                  InputDecoration(labelText: 'Fecha de Ingreso (YYYY-MM-DD)'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _SKUController,
                    decoration: InputDecoration(labelText: 'SKU'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: _escanearCodigoBarras,
                ),
              ],
            ),
            TextField(
              controller: _fechaVencimientoController,
              decoration:
                  InputDecoration(labelText: 'Fecha de Vencimiento (opcional)'),
            ),
            TextField(
              controller: _precioCompraController,
              decoration:
                  InputDecoration(labelText: 'Precio de Compra (opcional)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _precioVentaController,
              decoration:
                  InputDecoration(labelText: 'Precio de Venta (opcional)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _pesoController,
              decoration: InputDecoration(labelText: 'Peso (opcional)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _insertarProducto,
              child: Text('Insertar Producto'),
            ),
            ElevatedButton(
              onPressed: _generarVenta,
              child: Text('Realizar Venta'),
            ),
            ElevatedButton(
              onPressed: _verVentas,
              child: Text('Ver Ventas'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InsertarProductoScreen(),
  ));
}
