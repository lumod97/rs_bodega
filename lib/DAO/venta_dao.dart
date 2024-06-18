import 'package:path/path.dart';
import 'package:rs_bodega/DAO/venta_model.dart';
import 'package:sqflite/sqflite.dart';

class VentaDAO {
  late Database _db;

  Future<void> open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ventas.db');

    _db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE ventas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fecha_venta TEXT,
          id_cliente TEXT,
          id_vendedor TEXT
        )
      ''');
    });
  }

  Future<void> close() async => _db.close();

  Future<int> insertVenta(VentaModel venta) async {
    int id = await _db.insert(
      'ventas',
      venta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Devuelve el id generado
    return id;
  }

  Future<VentaModel?> getVentaById(int id) async {
    List<Map<String, dynamic>> maps = await _db.query(
      'ventas',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return VentaModel.fromMap(maps.first);
  }

  Future<List<VentaModel>> getAllVentas() async {
    List<Map<String, dynamic>> maps = await _db.query('ventas');
    return List.generate(maps.length, (i) {
      return VentaModel.fromMap(maps[i]);
    });
  }

  Future<void> updateVenta(VentaModel venta) async {
    await _db.update(
      'ventas',
      venta.toMap(),
      where: 'id = ?',
      whereArgs: [venta.id],
    );
  }

  Future<void> deleteVenta(int id) async {
    await _db.delete(
      'ventas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
