import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class MesaService {
  static const String baseUrl = 'http://69.6.207.221';

  // Obtener todas las mesas y sus importes pendientes.
  static Future<List<Map<String, dynamic>>> obtenerMesas() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/mesas'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error al obtener las mesas: ${response.statusCode}');
    }

    final Map<String, dynamic> respuesta =
        jsonDecode(response.body) as Map<String, dynamic>;

    debugPrint(response.body);

    if (respuesta['exito'] != true) {
      throw Exception('Laravel no devolvió las mesas correctamente.');
    }

    final List<dynamic> datos = respuesta['data'] ?? [];

    return datos.map((mesa) => Map<String, dynamic>.from(mesa as Map)).toList();
  }

  // Obtener todos los pedidos pendientes de una mesa por su ID real.
  static Future<List<Map<String, dynamic>>> obtenerPedidosPendientes(
    int idMesa,
  ) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/mesas/$idMesa/pedidos-pendientes'))
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

  // Marcar un pedido específico como SERVIDO.
  static Future<void> marcarPedidoComoServido(int idPedido) async {
    final response = await http
        .patch(
          Uri.parse('$baseUrl/api/cocina/pedidos/$idPedido/estado'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'fk_id_estado': 4}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'No se pudo marcar el pedido como servido: '
        '${response.statusCode}',
      );
    }

    final respuesta = jsonDecode(response.body) as Map<String, dynamic>;

    if (respuesta['fk_id_estado'] != 4) {
      throw Exception('Laravel no confirmó el estado SERVIDO.');
    }
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

  // Obtener todas las secciones registradas en Laravel.
  static Future<List<Map<String, dynamic>>> obtenerSecciones() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/secciones'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error al obtener las secciones: ${response.statusCode}');
    }

    final Map<String, dynamic> respuesta =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (respuesta['exito'] != true) {
      throw Exception('Laravel no devolvió las secciones correctamente.');
    }

    final List<dynamic> datos = respuesta['data'] ?? [];

    return datos
        .map((seccion) => Map<String, dynamic>.from(seccion as Map))
        .toList();
  }

  // Obtener todas las categorías desde Laravel.
  static Future<List<Map<String, dynamic>>> obtenerCategorias() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/v1/categorias'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener las categorías: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> respuesta =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (respuesta['exito'] != true) {
      throw Exception('Laravel no devolvió las categorías correctamente.');
    }

    final List<dynamic> datos = respuesta['data'] ?? [];

    return datos
        .map((categoria) => Map<String, dynamic>.from(categoria as Map))
        .toList();
  }

 
}
