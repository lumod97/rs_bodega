class ProductoModel {
  final int? id;
  final String name;
  final String description;
  final String marca;
  final String modelo;
  final String color;
  final String tamano;
  final int id_category;
  final int stock;
  final int? id_proveedor;
  final String fecha_ingreso;
  final String SKU;
  final String? fecha_vencimiento;
  final double? precio_compra;
  final double? precio_venta;
  final double? peso;

  ProductoModel({
    this.id,
    required this.name,
    required this.description,
    required this.marca,
    required this.modelo,
    required this.color,
    required this.tamano,
    required this.id_category,
    required this.stock,
    this.id_proveedor,
    required this.fecha_ingreso,
    required this.SKU,
    this.fecha_vencimiento,
    this.precio_compra,
    this.precio_venta,
    this.peso,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'marca': marca,
      'modelo': modelo,
      'color': color,
      'tamano': tamano,
      'id_category': id_category,
      'stock': stock,
      'id_proveedor': id_proveedor,
      'fecha_ingreso': fecha_ingreso,
      'SKU': SKU,
      'fecha_vencimiento': fecha_vencimiento,
      'precio_compra': precio_compra,
      'precio_venta': precio_venta,
      'peso': peso,
    };
  }

  static ProductoModel fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      marca: map['marca'],
      modelo: map['modelo'],
      color: map['color'],
      tamano: map['tamano'],
      id_category: map['id_category'],
      stock: map['stock'],
      id_proveedor: map['id_proveedor'],
      fecha_ingreso: map['fecha_ingreso'],
      SKU: map['SKU'],
      fecha_vencimiento: map['fecha_vencimiento'],
      precio_compra: map['precio_compra'],
      precio_venta: map['precio_venta'],
      peso: map['peso'],
    );
  }
}
