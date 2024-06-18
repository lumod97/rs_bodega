import 'package:path/path.dart';
import 'package:rs_bodega/DAO/venta_detalle_model.dart';
import 'package:sqflite/sqflite.dart';

class VentaDetalleDAO {
  late Database _db;

  Future<void> open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'venta_detalle.db');

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE venta_detalle (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          id_venta INTEGER,
          id_producto INTEGER,
          cantidad_vendida REAL,
          precio_unitario REAL,
          descuento_aplicado REAL,
          observacion TEXT
        )
      ''');
    });
  }

  Future<void> close() async => _db.close();

  Future<void> insertVentaDetalle(VentaDetalleModel ventaDetalle) async {
    await _db.insert(
      'venta_detalle',
      ventaDetalle.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<VentaDetalleModel?> getVentaDetalleById(int id) async {
    List<Map<String, dynamic>> maps = await _db.query(
      'venta_detalle',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return VentaDetalleModel.fromMap(maps.first);
  }

  Future<List<VentaDetalleModel>> getAllVentaDetalles() async {
    List<Map<String, dynamic>> maps = await _db.query('venta_detalle');
    return List.generate(maps.length, (i) {
      return VentaDetalleModel.fromMap(maps[i]);
    });
  }

  Future<List<VentaDetalleModel>> getDetallesByVentaId(int idVenta) async {
    List<Map<String, dynamic>> maps = await _db.query(
      'venta_detalle',
      where: 'id_venta = ?',
      whereArgs: [idVenta],
    );
    return List.generate(maps.length, (i) {
      return VentaDetalleModel.fromMap(maps[i]);
    });
  }

  Future<void> updateVentaDetalle(VentaDetalleModel ventaDetalle) async {
    await _db.update(
      'venta_detalle',
      ventaDetalle.toMap(),
      where: 'id = ?',
      whereArgs: [ventaDetalle.id],
    );
  }

  Future<void> deleteVentaDetalle(int id) async {
    await _db.delete(
      'venta_detalle',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
