import 'package:rs_bodega/DAO/producto_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductoDAO {
  late Database _db;

  Future<void> open() async {
    // Obtener la ruta del directorio de la base de datos:
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'productos.db');

    // Abrir la base de datos. Crear si no existe:
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Crear la tabla productos:
      await db.execute('''
        CREATE TABLE productos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          marca TEXT,
          modelo TEXT,
          color TEXT,
          tamano TEXT,
          id_category INTEGER,
          stock INTEGER,
          id_proveedor INTEGER,
          fecha_ingreso TEXT,
          SKU TEXT,
          fecha_vencimiento TEXT,
          precio_compra REAL,
          precio_venta REAL,
          peso REAL
        )
      ''');
    });
  }

  Future<void> close() async => _db.close();

  Future<void> insertProducto(ProductoModel producto) async {
    await _db.insert(
      'productos',
      producto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ProductoModel?> getProductoById(int id) async {
    List<Map<String, dynamic>> maps = await _db.query(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return ProductoModel.fromMap(maps.first);
  }

  Future<ProductoModel?> getProductByIdLike(String idLike) async {
    List<Map<String, dynamic>> maps = await _db.rawQuery('''
      SELECT * FROM productos
      WHERE SKU LIKE '%$idLike%'
    ''');

    if (maps.isEmpty) {
      return null;
    }
    return ProductoModel.fromMap(maps.first);
  }

  Future<List<ProductoModel>> getProductos() async {
    List<Map<String, dynamic>> maps = await _db.query('productos');
    return List.generate(maps.length, (i) {
      return ProductoModel.fromMap(maps[i]);
    });
  }

  Future<void> updateProducto(ProductoModel producto) async {
    await _db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  Future<void> deleteProducto(int id) async {
    await _db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
