
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class MesaService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Obtener todas las mesas y sus importes pendientes.
  static Future<List<Map<String, dynamic>>> obtenerMesas() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/mesas'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener las mesas: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> respuesta =
        jsonDecode(response.body) as Map<String, dynamic>;

    debugPrint(response.body);

    if (respuesta['exito'] != true) {
      throw Exception('Laravel no devolvió las mesas correctamente.');
    }

    final List<dynamic> datos = respuesta['data'] ?? [];

    return datos
        .map((mesa) => Map<String, dynamic>.from(mesa as Map))
        .toList();
  }

  // Obtener todos los pedidos pendientes de una mesa por su ID real.
  static Future<List<Map<String, dynamic>>> obtenerPedidosPendientes(
    int idMesa,
  ) async {
    final response = await http
        .get(
          Uri.parse(
            '$baseUrl/api/mesas/$idMesa/pedidos-pendientes',
          ),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener los pedidos pendientes: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> respuesta =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (respuesta['exito'] != true) {
      throw Exception('Laravel no devolvió los pedidos correctamente.');
    }

    final List<dynamic> datos = respuesta['data'] ?? [];

    return datos
        .map((pedido) => Map<String, dynamic>.from(pedido as Map))
        .toList();
  }
    // Obtener pedidos de cocina y sus estados.
  static Future<List<Map<String, dynamic>>> obtenerPedidosCocina() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/cocina/pedidos'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener los pedidos de cocina: ${response.statusCode}',
      );
    }

    final List<dynamic> datos = jsonDecode(response.body) as List<dynamic>;

    return datos
        .map((pedido) => Map<String, dynamic>.from(pedido as Map))
        .toList();
  }
}
