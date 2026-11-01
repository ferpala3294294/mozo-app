import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductoService {
  // =====================================================
  // URL DE LARAVEL
  // =====================================================

  static const String baseUrl = 'http://127.0.0.1:8000';

  // =====================================================
  // OBTENER PRODUCTOS
  // =====================================================

  static Future<List<Map<String, dynamic>>> obtenerProductos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/productos'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      if (respuesta['exito'] == true) {
        final List<dynamic> datos = respuesta['data'] ?? [];

        return datos
            .map(
              (producto) =>
                  Map<String, dynamic>.from(producto),
            )
            .toList();
      }

      throw Exception(
        'La API no devolvió los productos correctamente.',
      );
    }

    throw Exception(
      'Error al obtener los productos. '
      'Código: ${response.statusCode}',
    );
  }
}