
class VentaDetalleModel {
  final int id;
  int id_venta;
  final int id_producto;
  double cantidad_vendida;
  final double precio_unitario;
  final double descuento_aplicado;
  final String? observacion;
  

  VentaDetalleModel(
    {
      required this.id,
      required this.id_venta,
      required this.id_producto,
      required this.cantidad_vendida,
      required this.precio_unitario,
      required this.descuento_aplicado,
      this.observacion,
      
    }
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_venta': id_venta,
      'id_producto': id_producto,
      'cantidad_vendida': cantidad_vendida,
      'precio_unitario': precio_unitario,
      'descuento_aplicado': descuento_aplicado,
      'observacion': observacion,
    };
  }

  static VentaDetalleModel fromMap(Map<String, dynamic> map) {
    return VentaDetalleModel(
      id: map['id'],
      id_venta: map['id_venta'],
      id_producto: map['id_producto'],
      cantidad_vendida: map['cantidad_vendida'],
      precio_unitario: map['precio_unitario'],
      descuento_aplicado: map['descuento_aplicado'],
      observacion: map['observacion'],
    );
  }
}
