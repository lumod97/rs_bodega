import 'package:flutter/material.dart';
import 'package:rs_bodega/views/new_product.dart';
import 'package:rs_bodega/views/new_sale.dart';
import 'package:rs_bodega/views/sales_detail_list.dart';
import 'package:rs_bodega/views/sales_list.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => InsertarProductoScreen(),
  '/sales': (context) => SalesListScreen(),
  '/details': (context) => SalesDetailScreen(
      ventaId: ModalRoute.of(context)!.settings.arguments as int),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/details':
      final args = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => RealizarVentaScreen(),
      );
    case '/details_sale':
      final int ventaId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => SalesDetailScreen(ventaId: ventaId),
      );

    case '/sales':
      return MaterialPageRoute(
        builder: (context) => SalesListScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => InsertarProductoScreen(),
      );
  }
}
