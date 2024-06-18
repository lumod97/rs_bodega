
class VentaModel {
  final int id;
  final String fecha_venta;
  final String id_cliente;
  final String id_vendedor;
  

  VentaModel(
    {
      required this.id,
      required this.fecha_venta,
      required this.id_cliente,
      required this.id_vendedor,
      
    }
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha_venta': fecha_venta,
      'id_cliente': id_cliente,
      'id_vendedor': id_vendedor,
    };
  }

  static VentaModel fromMap(Map<String, dynamic> map) {
    return VentaModel(
      id: map['id'],
      fecha_venta: map['fecha_venta'],
      id_cliente: map['id_cliente'],
      id_vendedor: map['id_vendedor'],
    );
  }
}
